from tkinter import Frame
from config import COLORS


class BaseScreen(Frame):
    """All screens inherit from this base class."""

    def __init__(self, parent, controller, **kwargs):
        super().__init__(parent, bg=COLORS["background"], **kwargs)
        self.controller = controller
        self.build()

    def build(self):
        """Override in subclasses to build UI."""
        raise NotImplementedError