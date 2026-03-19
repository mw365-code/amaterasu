class Phrase:
    def __init__(self, phrase_id: str, english: str, japanese: str, romaji: str, category: str):
        self.phrase_id = phrase_id
        self.english = english
        self.japanese = japanese
        self.romaji = romaji
        self.category = category

    @classmethod
    def from_dict(cls, data: dict) -> "Phrase":
        return cls(
            phrase_id=data["id"],
            english=data["english"],
            japanese=data["japanese"],
            romaji=data["romanji"],
            category=data["category"],
        )

def matches_query(self, query: str) -> bool:
        q = query.lower()
        return (
            q in self.english.lower()
            or q in self.japanese.lower()
            or q in self.romaji.lower()
        )