from tkinter import Frame
from models.app_state import AppState
from models.repository import PhraseRepository
from services.search_service import SearchService
from viewmodels.home_vm import HomeViewModel
from viewmodels.category_vm import CategoryViewModel
from viewmodels.phrase_vm import PhraseViewModel


class NavigationController:
    def __init__(self, root, state: AppState):
        self.root = root
        self.state = state
        self._stack: list[Frame] = []

        # Shared services and repository
        self._repo = PhraseRepository()
        self._search_service = SearchService()

        # Shared ViewModels
        self.home_vm = HomeViewModel(self._repo)
        self.category_vm = CategoryViewModel(self._repo, self._search_service)
        self.phrase_vm = PhraseViewModel(self.state)

    def show(self, screen_name: str, **kwargs):
        # Lazy import to avoid circular imports
        from views.home_screen import HomeScreen
        from views.category_screen import CategoryScreen
        from views.phrase_screen import PhraseScreen

        screen_map = {
            "home": HomeScreen,
            "category": CategoryScreen,
            "phrase": PhraseScreen,
        }

        screen_class = screen_map.get(screen_name)
        if not screen_class:
            raise ValueError(f"Unknown screen: {screen_name}")

        # Destroy current top screen if any
        if self._stack:
            self._stack[-1].destroy()
            self._stack.pop()

        frame = screen_class(self.root, self, **kwargs)
        frame.place(x=0, y=0, relwidth=1, relheight=1)
        self._stack.append(frame)

    def go_back(self):
        if len(self._stack) > 1:
            self._stack[-1].destroy()
            self._stack.pop()
            self._stack[-1].place(x=0, y=0, relwidth=1, relheight=1)
        else:
            self.show("home")