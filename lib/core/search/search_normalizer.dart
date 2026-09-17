class SearchNormalizer {
  SearchNormalizer._();

  static final RegExp _arabicDiacritics = RegExp(
    r'[\u064B-\u065F\u0670\u06D6-\u06ED]',
  );

  static final RegExp _arabicTatweel = RegExp(r'\u0640');
  static final RegExp _multipleWhitespace = RegExp(r'\s+');

  /// Normalizes a search query or product name for resilient bilingual matching:
  /// - Strips Arabic diacritics and tatweel
  /// - Normalizes Arabic Alef (أ, إ, آ -> ا)
  /// - Normalizes Arabic Ya/Alif Maqsura (ى -> ي)
  /// - Normalizes Taa Marbuta (ة -> ه)
  /// - Lowercases Latin text (French, English, Latin Darja)
  /// - Collapses whitespace
  static String normalize(String input) {
    if (input.isEmpty) return '';

    var text = input.trim().toLowerCase();

    // Remove Arabic diacritics / harakat
    text = text.replaceAll(_arabicDiacritics, '');

    // Remove tatweel
    text = text.replaceAll(_arabicTatweel, '');

    // Normalize Alefs
    text = text
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ٱ', 'ا');

    // Normalize Alif Maqsura to Ya
    text = text.replaceAll('ى', 'ي');

    // Normalize Taa Marbuta
    text = text.replaceAll('ة', 'ه');

    // Normalize French accents to base characters for fuzzy discovery
    text = text
        .replaceAll(RegExp(r'[éèêë]'), 'e')
        .replaceAll(RegExp(r'[àâä]'), 'a')
        .replaceAll(RegExp(r'[îï]'), 'i')
        .replaceAll(RegExp(r'[ôö]'), 'o')
        .replaceAll(RegExp(r'[ùûü]'), 'u')
        .replaceAll(RegExp(r'[ç]'), 'c');

    // Clean whitespace
    text = text.replaceAll(_multipleWhitespace, ' ');

    return text.trim();
  }

  /// Checks if [query] matches [target] using normalized rules
  static bool matches({required String query, required String target}) {
    final normQuery = normalize(query);
    if (normQuery.isEmpty) return true;
    final normTarget = normalize(target);
    return normTarget.contains(normQuery);
  }

  /// Score prefix matches higher than substring matches
  static int matchScore({required String query, required String target}) {
    final normQuery = normalize(query);
    if (normQuery.isEmpty) return 0;
    final normTarget = normalize(target);

    if (normTarget == normQuery) return 100; // Exact match
    if (normTarget.startsWith(normQuery)) return 75; // Prefix match
    if (normTarget.contains(' $normQuery')) return 50; // Word start match
    if (normTarget.contains(normQuery)) return 25; // Substring match
    return -1; // No match
  }
}
