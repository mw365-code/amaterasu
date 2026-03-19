class Phrase {
  final String id;
  final String categoryId;
  final String english;
  final String japanese;
  final String? romaji;
  final String? notes;

  const Phrase({
    required this.id,
    required this.categoryId,
    required this.english,
    required this.japanese,
    this.romaji,
    this.notes,
  });
}