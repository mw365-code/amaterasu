class Category {
  final String id;
  final String name;
  final String icon;
  final String description;

  const Category({
    required this.id,
    required this.name,
    this.icon = '',
    this.description = '',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'icon': icon,
        'description': description,
      };

  factory Category.fromMap(Map<String, dynamic> data) {
    return Category(
      id: (data['id'] ?? '').toString(),
      name: (data['name'] ?? '').toString(),
      icon: (data['icon'] ?? '').toString(),
      description: (data['description'] ?? '').toString(),
    );
  }

  @override
  String toString() => '<Category: $name>';
}