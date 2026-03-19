class AppState:
    def __init__(self):
        self.current_category = None
        self.current_phrase = None
        self.favorites = []
        self.recently_viewed = []
        self.search_query = ""

        self.current_phrase_list = []
        self.current_phrase_index = -1

    def set_category(self, category):
        self.current_category = category

    def set_phrase(self, phrase):
        self.current_phrase = phrase
        self._add_to_recently_viewed(phrase)

    def set_phrase_context(self, phrases, phrase):
        self.current_phrase_list = list(phrases) if phrases else []
        try:
            self.current_phrase_index = self.current_phrase_list.index(phrase)
        except ValueError:
            self.current_phrase_index = -1
        self.set_phrase(phrase)

    def next_phrase(self):
        if not self.current_phrase_list:
            return None
        if self.current_phrase_index < 0:
            self.current_phrase_index = 0
        else:
            self.current_phrase_index = min(self.current_phrase_index + 1, len(self.current_phrase_list) - 1)
        self.set_phrase(self.current_phrase_list[self.current_phrase_index])
        return self.current_phrase

    def prev_phrase(self):
        if not self.current_phrase_list:
            return None
        if self.current_phrase_index < 0:
            self.current_phrase_index = 0
        else:
            self.current_phrase_index = max(self.current_phrase_index - 1, 0)
        self.set_phrase(self.current_phrase_list[self.current_phrase_index])
        return self.current_phrase

    def toggle_favorite(self, phrase):
        if phrase in self.favorites:
            self.favorites.remove(phrase)
        else:
            self.favorites.append(phrase)

    def is_favorite(self, phrase):
        return phrase in self.favorites

    def _add_to_recently_viewed(self, phrase):
        if phrase in self.recently_viewed:
            self.recently_viewed.remove(phrase)
        self.recently_viewed.insert(0, phrase)
        if len(self.recently_viewed) > 20:
            self.recently_viewed.pop()