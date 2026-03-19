from models.repository import PhraseRepository
from models.phrase import Phrase
from models.category import Category
from services.search_service import SearchService


class CategoryViewModel:
    def __init__(self, repository: PhraseRepository, search_service: SearchService):
        self._repo = repository
        self._search = search_service
        self.current_category: Category | None = None

    def load_category(self, category_id: str):
        self.current_category = self._repo.get_category_by_id(category_id)

    def get_phrases(self, query: str = "") -> list[Phrase]:
        if not self.current_category:
            return []
        phrases = self._repo.get_phrases_by_category(self.current_category.category_id)
        return self._search.search(phrases, query)

    def get_category_title(self) -> str:
        return self.current_category.name if self.current_category else ""