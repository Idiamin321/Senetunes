class Media {
  final String thumbnail;
  final String medium;
  final String cover;

  /// Construit Media à partir d'une chaîne d'URLs séparées par des espaces.
  /// Choisit `small` pour thumbnail, `medium` pour medium, sinon `cover`.
  factory Media(String url) {
    final parts = (url.isEmpty
        ? <String>[]
        : url.split(' ').where((e) => e.trim().isNotEmpty).toList())
        .toList();

    String? _thumb;
    String? _med;
    String? _cov;

    for (final u in parts) {
      if (u.contains('small')) {
        _thumb = u;
      } else if (u.contains('medium')) {
        _med = u;
      } else {
        _cov = u;
      }
    }

    // Fallbacks robustes si certains formats manquent
    final fallback = parts.isNotEmpty ? parts.last : url;

    final thumbFinal = _thumb ?? _med ?? _cov ?? fallback;
    final medFinal = _med ?? _cov ?? _thumb ?? fallback;
    final covFinal = _cov ?? _med ?? _thumb ?? fallback;

    return Media._internal(
      thumbnail: thumbFinal,
      medium: medFinal,
      cover: covFinal,
    );
  }

  const Media._internal({
    required this.thumbnail,
    required this.medium,
    required this.cover,
  });

  Map<String, dynamic> toJson() => {
    'thumbnail': thumbnail,
    'medium': medium,
    'cover': cover,
  };

  @override
  String toString() => '$thumbnail $medium $cover';
}
