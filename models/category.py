class Category:
    def __init__(self, category_id: str, name: str, icon: str = "", description: str = ""):
        self.category_id = category_id
        self.name = name
        self.icon = icon
        self.description = description

    def to_dict(self) -> dict:
        return {
            "id": self.category_id,
            "name": self.name,
            "icon": self.icon,
            "description": self.description,
        }

    @classmethod
    def from_dict(cls, data: dict) -> "Category":
        return cls(
            category_id=data.get("id", ""),
            name=data.get("name", ""),
            icon=data.get("icon", ""),
            description=data.get("description", ""),
        )

    def __repr__(self):
        return f"<Category: {self.name}>"