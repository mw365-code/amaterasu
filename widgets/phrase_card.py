from tkinter import Frame, Label
from config import COLORS, FONTS


class PhraseCard(Frame):
    def __init__(self, parent, phrase, on_click, **kwargs):
        super().__init__(
            parent,
            bg=COLORS["blue_600"],
            cursor="hand2",
            padx=16,
            pady=12,
            **kwargs,
        )
        self._on_click = on_click
        self._build(phrase)
        self.bind("<Button-1>", lambda e: self._on_click())
        for child in self.winfo_children():
            child.bind("<Button-1>", lambda e: self._on_click())

    def _build(self, phrase):
        Label(
            self,
            text=phrase.english,
            font=FONTS["body"],
            bg=COLORS["blue_600"],
            fg="#FFFFFF",
            anchor="w",
            wraplength=280,
            justify="left",
        ).pack(anchor="w")

        Label(
            self,
            text=phrase.japanese,
            font=FONTS["japanese"],
            bg=COLORS["blue_600"],
            fg="#FFFFFF",
            anchor="w",
        ).pack(anchor="w", pady=(4, 0))