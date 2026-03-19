from tkinter import Label, Frame, Canvas, Scrollbar
from views.base_screen import BaseScreen
from widgets.header_bar import HeaderBar
from widgets.category_button import CategoryButton
from config import COLORS, FONTS


class HomeScreen(BaseScreen):
    def build(self):
        vm = self.controller.home_vm
        theme_bg = COLORS["home_bg"]
        self.configure(bg=theme_bg)

        # Header
        HeaderBar(self, title="🌏 Travel Phrases", show_back=False, bg_color=theme_bg)

        # Subtitle
        Label(
            self,
            text="Select a situation",
            font=FONTS["caption"],
            bg=theme_bg,
            fg=COLORS["text_light"],
        ).pack(pady=(0, 12))

        # Scrollable category list
        container = Frame(self, bg=theme_bg)
        container.pack(fill="both", expand=True, padx=16)

        canvas = Canvas(container, bg=theme_bg, highlightthickness=0)
        scrollbar = Scrollbar(container, orient="vertical", command=canvas.yview)
        scroll_frame = Frame(canvas, bg=theme_bg)

        scroll_frame.bind(
            "<Configure>",
            lambda e: canvas.configure(scrollregion=canvas.bbox("all"))
        )

        canvas.create_window((0, 0), window=scroll_frame, anchor="nw")
        canvas.configure(yscrollcommand=scrollbar.set)

        canvas.pack(side="left", fill="both", expand=True)
        scrollbar.pack(side="right", fill="y")

        for category in vm.get_categories():
            CategoryButton(
                scroll_frame,
                category=category,
                on_click=lambda cat=category: self._open_category(cat),
            ).pack(fill="x", pady=6)

    def _open_category(self, category):
        self.controller.state.set_category(category)
        self.controller.show("category", category_id=category.category_id)