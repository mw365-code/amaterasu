from __future__ import annotations

from tkinter import Frame, Label
from typing import Callable

from config import COLORS, FONTS


class FlatButton(Frame):
    """
    A simple cross-platform button implemented with Frame+Label so bg colors
    are reliably respected (including on macOS where tk.Button may render natively).
    """

    def __init__(
        self,
        parent,
        text: str,
        command: Callable[[], None],
        bg: str,
        fg: str = "#FFFFFF",
        hover_bg: str | None = None,
        font=None,
        padx: int = 14,
        pady: int = 10,
        **kwargs,
    ):
        self._bg = bg
        self._hover_bg = hover_bg or bg
        self._fg = fg
        self._command = command

        super().__init__(parent, bg=self._bg, padx=padx, pady=pady, cursor="hand2", **kwargs)

        self._label = Label(
            self,
            text=text,
            bg=self._bg,
            fg=self._fg,
            font=font or FONTS["body"],
        )
        self._label.pack(expand=True, fill="both")

        self._bind_all(self)
        self._bind_all(self._label)

    def _bind_all(self, widget):
        widget.bind("<Button-1>", lambda e: self._command())
        widget.bind("<Enter>", lambda e: self._set_bg(self._hover_bg))
        widget.bind("<Leave>", lambda e: self._set_bg(self._bg))

    def _set_bg(self, color: str):
        super().configure(bg=color)
        self._label.configure(bg=color)

    def set_text(self, text: str):
        self._label.configure(text=text)

    def config(self, **kwargs):
        # convenience to match tkinter-style usage in the rest of the code
        if "text" in kwargs:
            self.set_text(kwargs.pop("text"))
        if "bg" in kwargs:
            self._bg = kwargs["bg"]
            self._set_bg(self._bg)
        if "fg" in kwargs:
            self._fg = kwargs["fg"]
            self._label.configure(fg=self._fg)
        super().config(**kwargs)

    configure = config

