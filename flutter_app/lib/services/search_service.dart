class SearchService<T> {
  List<T> search({
    required List<T> items,
    required String query,
    required bool Function(T item, String normalizedQuery) matchesQuery,
  }) {
    final normalized = query.trim();
    if (normalized.isEmpty) return items;

    return items.where((item) => matchesQuery(item, normalized)).toList();
  }
}