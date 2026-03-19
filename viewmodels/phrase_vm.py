from models.phrase import Phrase
from models.app_state import AppState


class PhraseViewModel:
    def __init__(self, state: AppState):
        self._state = state

    def get_phrase(self) -> Phrase | None:
        return self._state.current_phrase

    def toggle_favorite(self):
        phrase = self._state.current_phrase
        if phrase:
            self._state.toggle_favorite(phrase)

    def is_favorite(self) -> bool:
        phrase = self._state.current_phrase
        return self._state.is_favorite(phrase) if phrase else False