from tkinter import Frame, Label
from config import COLORS, FONTS


class CategoryButton(Frame):
    def __init__(self, parent, category, on_click, **kwargs):
        super().__init__(
            parent,
            bg=COLORS["blue_600"],
            cursor="hand2",
            padx=16,
            pady=14,
            **kwargs,
        )
        self._on_click = on_click
        self._build(category)
        self.bind("<Button-1>", lambda e: self._on_click())
        for child in self.winfo_children():
            child.bind("<Button-1>", lambda e: self._on_click())

    def _build(self, category):
        Label(
            self,
            text=f"{category.icon}  {category.name}",
            font=FONTS["body"],
            bg=COLORS["blue_600"],
            fg="#FFFFFF",
            anchor="w",
        ).pack(side="left")

        Label(
            self,
            text=category.description,
            font=FONTS["caption"],
            bg=COLORS["blue_600"],
            fg="#FFFFFF",
            anchor="e",
        ).pack(side="right")