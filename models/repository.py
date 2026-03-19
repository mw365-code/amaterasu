import os

from models.category import Category
from models.phrase import Phrase

DATA_DIR = os.path.join(os.path.dirname(__file__), "..", "data")
DATA_PATH = os.path.join(DATA_DIR, "phrases.yaml")


class PhraseRepository:
    def __init__(self):
        self._categories: list[Category] = []
        self._phrases: list[Phrase] = []
        self._load()

    def _load(self):
        if not os.path.exists(DATA_PATH):
            raise FileNotFoundError(
                f"Missing YAML data file: '{DATA_PATH}'."
            )

        try:
            import yaml  # PyYAML
        except ImportError as exc:
            raise ImportError(
                "PyYAML is required to read phrases.yaml. Install it with:\n"
                ".venv/bin/python -m pip install PyYAML"
            ) from exc

        with open(DATA_PATH, "r", encoding="utf-8") as f:
            data = yaml.safe_load(f) or {}

        self._categories = [Category.from_dict(c) for c in data.get("categories", [])]
        self._phrases = [Phrase.from_dict(p) for p in data.get("phrases", [])]

    def get_all_categories(self) -> list[Category]:
        return self._categories

    def get_category_by_id(self, category_id: str) -> Category | None:
        return next((c for c in self._categories if c.category_id == category_id), None)

    def get_phrases_by_category(self, category_id: str) -> list[Phrase]:
        return [p for p in self._phrases if p.category == category_id]

    def get_phrase_by_id(self, phrase_id: str) -> Phrase | None:
        return next((p for p in self._phrases if p.phrase_id == phrase_id), None)

    def get_all_phrases(self) -> list[Phrase]:
        return self._phrases
