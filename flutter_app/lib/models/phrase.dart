class Phrase {
  final String id;
  final String categoryId;
  final String english;
  final String japanese;
  final String? romaji;
  final String? notes;
  final List<String> tags;

  const Phrase({
    required this.id,
    required this.categoryId,
    required this.english,
    required this.japanese,
    this.romaji,
    this.notes,
    this.tags = const [],
  });

  factory Phrase.fromMap(Map<String, dynamic> data) {
    final rawTags = data['tags'];
    final tags = (rawTags is List)
        ? rawTags.map((e) => e.toString()).toList(growable: false)
        : const <String>[];

    return Phrase(
      id: (data['id'] ?? '').toString(),
      categoryId: (data['category'] ?? data['categoryId'] ?? '').toString(),
      english: (data['english'] ?? '').toString(),
      japanese: (data['japanese'] ?? '').toString(),
      romaji: (data['romaji'] ?? data['romanji'])?.toString(),
      notes: data['notes']?.toString(),
      tags: tags,
    );
  }
}