from __future__ import annotations

from tkinter import Label, Frame
from tkinter import messagebox

from views.base_screen import BaseScreen
from widgets.header_bar import HeaderBar
from widgets.flat_button import FlatButton
from config import COLORS, FONTS
from services.audio_service import AudioService


class PhraseScreen(BaseScreen):
    def build(self):
        vm = self.controller.phrase_vm
        phrase = vm.get_phrase()

        theme_bg = COLORS["phrase_bg"]
        self.configure(bg=theme_bg)

        HeaderBar(
            self,
            title="Phrase Detail",
            show_back=True,
            on_back=self.controller.go_back,
            bg_color=theme_bg,
        )

        if not phrase:
            Label(
                self,
                text="No phrase selected.",
                font=FONTS["body"],
                bg=theme_bg,
                fg=COLORS["text_light"],
            ).pack(pady=40)
            return

        self._audio = AudioService()
        self._has_played = False
        self._play_btn = None

        self._build_phrase_card(phrase)
        self._build_nav_buttons(theme_bg)
        self._build_favorite_button(vm)

        self._bind_keys()

    def _build_phrase_card(self, phrase):
        card = Frame(self, bg=COLORS["card_bg"], padx=24, pady=24)
        card.pack(fill="x", padx=16, pady=16)

        self._field(
            parent=card,
            title="English",
            value=phrase.english,
            value_font=FONTS["heading"],
            value_fg=COLORS["text_dark"],
        )

        self._field(
            parent=card,
            title="Japanese",
            value=phrase.japanese,
            value_font=FONTS["japanese"],
            value_fg=COLORS.get("primary", COLORS["text_dark"]),
            bottom_pad=10,
        )

        self._play_btn = FlatButton(
            card,
            text="▶  Play" if not self._has_played else "🔁  Repeat",
            command=lambda p=phrase: self._play_audio(p),
            bg=COLORS["blue_600"],
            hover_bg=COLORS.get("blue_500", COLORS["blue_600"]),
            fg="#FFFFFF",
            font=FONTS["body"],
            padx=14,
            pady=10,
        )
        self._play_btn.pack(anchor="w", pady=(0, 14))

        if getattr(phrase, "romaji", ""):
            self._field(
                parent=card,
                title="Romaji",
                value=phrase.romaji,
                value_font=FONTS["body"],
                value_fg=COLORS["text_dark"],
                bottom_pad=0,
            )

    def _field(
        self,
        parent: Frame,
        title: str,
        value: str,
        value_font,
        value_fg: str,
        bottom_pad: int = 14,
    ):
        Label(
            parent,
            text=title,
            font=FONTS["caption"],
            bg=COLORS["card_bg"],
            fg=COLORS["text_light"],
        ).pack(anchor="w")

        Label(
            parent,
            text=value,
            font=value_font,
            bg=COLORS["card_bg"],
            fg=value_fg,
            wraplength=330,
            justify="left",
        ).pack(anchor="w", pady=(2, bottom_pad))

    def _play_audio(self, phrase):
        try:
            self._audio.speak(phrase.japanese, language="ja")
            if not self._has_played:
                self._has_played = True
                if self._play_btn is not None:
                    self._play_btn.config(text="🔁  Repeat")
        except NotImplementedError:
            messagebox.showinfo("Audio", "Audio playback is not implemented yet.")
        except Exception as exc:
            messagebox.showerror("Audio error", str(exc))

    def _build_nav_buttons(self, theme_bg: str):
        nav = Frame(self, bg=theme_bg)
        nav.pack(fill="x", padx=16, pady=(0, 10))

        FlatButton(
            nav,
            text="←",
            command=self._prev_phrase,
            bg=COLORS["blue_600"],
            hover_bg=COLORS.get("blue_500", COLORS["blue_600"]),
            fg="#FFFFFF",
            font=("Helvetica", 26, "bold"),
            padx=18,
            pady=6,
        ).pack(side="left", fill="x", expand=True, padx=(0, 8))

        FlatButton(
            nav,
            text="→",
            command=self._next_phrase,
            bg=COLORS["blue_600"],
            hover_bg=COLORS.get("blue_500", COLORS["blue_600"]),
            fg="#FFFFFF",
            font=("Helvetica", 26, "bold"),
            padx=18,
            pady=6,
        ).pack(side="left", fill="x", expand=True, padx=(8, 0))

    def _build_favorite_button(self, vm):
        self._fav_btn = FlatButton(
            self,
            text=self._fav_label(vm),
            command=lambda: self._toggle_favorite(vm),
            bg=COLORS["blue_600"],
            hover_bg=COLORS.get("blue_500", COLORS["blue_600"]),
            fg="#FFFFFF",
            font=FONTS["body"],
            padx=20,
            pady=12,
        )
        self._fav_btn.pack(pady=8, padx=16, fill="x")

    def _bind_keys(self):
        self.bind_all("<Left>", lambda e: self._prev_phrase())
        self.bind_all("<Right>", lambda e: self._next_phrase())
        self.bind_all(
            "<space>",
            lambda e: self._play_audio(self.controller.phrase_vm.get_phrase()),
        )

    def _prev_phrase(self):
        self.controller.state.prev_phrase()
        self.controller.show("phrase")

    def _next_phrase(self):
        self.controller.state.next_phrase()
        self.controller.show("phrase")

    def _fav_label(self, vm) -> str:
        return "❤️  Remove from Favorites" if vm.is_favorite() else "🤍  Add to Favorites"

    def _toggle_favorite(self, vm):
        vm.toggle_favorite()
        self._fav_btn.config(text=self._fav_label(vm))