from tkinter import Frame, Label
from config import COLORS, FONTS
from widgets.flat_button import FlatButton


class HeaderBar(Frame):
    def __init__(
        self,
        parent,
        title: str,
        show_back: bool = False,
        on_back=None,
        bg_color: str | None = None,
        **kwargs,
    ):
        header_bg = bg_color or COLORS["secondary"]

        super().__init__(parent, bg=header_bg, pady=12, **kwargs)
        self.pack(fill="x")

        if show_back and on_back:
            FlatButton(
                self,
                text="←",
                command=on_back,
                bg=COLORS["blue_600"],
                hover_bg=COLORS.get("blue_500", COLORS["blue_600"]),
                fg="#FFFFFF",
                font=FONTS["heading"],
                padx=14,
                pady=8,
            ).pack(side="left", padx=(12, 0))

        Label(
            self,
            text=title,
            font=FONTS["heading"],
            bg=header_bg,
            fg=COLORS["text_dark"],
        ).pack(side="left", padx=12)