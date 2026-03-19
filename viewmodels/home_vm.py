from models.repository import PhraseRepository
from models.category import Category


class HomeViewModel:
    def __init__(self, repository: PhraseRepository):
        self._repo = repository

    def get_categories(self) -> list[Category]:
        return self._repo.get_all_categories()