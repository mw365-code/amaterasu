from models.phrase import Phrase


class SearchService:
    def search(self, phrases: list[Phrase], query: str) -> list[Phrase]:
        if not query or not query.strip():
            return phrases
        return [p for p in phrases if p.matches_query(query.strip())]