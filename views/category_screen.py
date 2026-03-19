from tkinter import Label, Frame, Entry, StringVar, Canvas, Scrollbar
from views.base_screen import BaseScreen
from widgets.header_bar import HeaderBar
from widgets.phrase_card import PhraseCard
from config import COLORS, FONTS


class CategoryScreen(BaseScreen):
    def __init__(self, parent, controller, category_id: str = "", **kwargs):
        self._category_id = category_id
        super().__init__(parent, controller, **kwargs)

    def build(self):
        vm = self.controller.category_vm
        vm.load_category(self._category_id)

        theme_bg = COLORS["category_bg"]
        self.configure(bg=theme_bg)

        # Header
        HeaderBar(
            self,
            title=vm.get_category_title(),
            show_back=True,
            on_back=self.controller.go_back,
            bg_color=theme_bg,
        )

        # Search bar
        self._search_var = StringVar()
        self._search_var.trace_add("write", self._on_search)

        search_frame = Frame(self, bg=COLORS["background"])
        search_frame.pack(fill="x", padx=16, pady=(0, 12))

        Entry(
            search_frame,
            textvariable=self._search_var,
            font=FONTS["body"],
            bg=COLORS["secondary"],
            fg=COLORS["text_dark"],
            relief="flat",
            bd=8,
            insertbackground=COLORS["text_dark"],
        ).pack(fill="x", ipady=8)

        # Scrollable phrase list
        self._list_container = Frame(self, bg=COLORS["background"])
        self._list_container.pack(fill="both", expand=True, padx=16)

        self._canvas = Canvas(self._list_container, bg=COLORS["background"], highlightthickness=0)
        scrollbar = Scrollbar(self._list_container, orient="vertical", command=self._canvas.yview)
        self._scroll_frame = Frame(self._canvas, bg=COLORS["background"])

        self._scroll_frame.bind(
            "<Configure>",
            lambda e: self._canvas.configure(scrollregion=self._canvas.bbox("all"))
        )

        self._canvas.create_window((0, 0), window=self._scroll_frame, anchor="nw")
        self._canvas.configure(yscrollcommand=scrollbar.set)

        self._canvas.pack(side="left", fill="both", expand=True)
        scrollbar.pack(side="right", fill="y")

        self._render_phrases()

    def _render_phrases(self):
        for widget in self._scroll_frame.winfo_children():
            widget.destroy()

        vm = self.controller.category_vm
        phrases = vm.get_phrases(self._search_var.get() if hasattr(self, "_search_var") else "")

        if not phrases:
            Label(
                self._scroll_frame,
                text="No phrases found.",
                font=FONTS["body"],
                bg=COLORS["category_bg"],
                fg=COLORS["text_light"],
            ).pack(pady=20)
            return

        for phrase in phrases:
            PhraseCard(
                self._scroll_frame,
                phrase=phrase,
                on_click=lambda p=phrase, plist=phrases: self._open_phrase(p, plist),
            ).pack(fill="x", pady=6)

    def _on_search(self, *args):
        self._render_phrases()

    def _open_phrase(self, phrase, phrases):
        self.controller.state.set_phrase_context(phrases, phrase)
        self.controller.show("phrase")