import 'package:flutter_test/flutter_test.dart';
import 'package:qoffa/core/search/search_normalizer.dart';

void main() {
  group('SearchNormalizer (Bilingual Arabic & French Normalization)', () {
    test('normalizes Arabic diacritics and tatweel', () {
      // حَلِيبٌ -> حليب
      expect(SearchNormalizer.normalize('حَلِيبٌ'), 'حليب');
      // حــــليب -> حليب
      expect(SearchNormalizer.normalize('حــــليب'), 'حليب');
    });

    test('normalizes varied Arabic Alef forms', () {
      expect(SearchNormalizer.normalize('أرز'), 'ارز');
      expect(SearchNormalizer.normalize('إجاص'), 'اجاص');
      expect(SearchNormalizer.normalize('آيس كريم'), 'ايس كريم');
    });

    test('normalizes Alif Maqsura and Taa Marbuta', () {
      expect(SearchNormalizer.normalize('حلوى'), 'حلوي');
      expect(SearchNormalizer.normalize('طماطم معلبة'), 'طماطم معلبه');
    });

    test('strips French accents for resilient discovery', () {
      expect(SearchNormalizer.normalize('Café Moulu'), 'cafe moulu');
      expect(SearchNormalizer.normalize('Crème Fraîche'), 'creme fraiche');
      expect(SearchNormalizer.normalize('Pâte'), 'pate');
    });

    test('matches normalized queries accurately', () {
      expect(
        SearchNormalizer.matches(query: 'حليب', target: 'حَلِيب كانديا 1 لتر'),
        isTrue,
      );
      expect(
        SearchNormalizer.matches(query: 'cafe', target: 'Café Boun'),
        isTrue,
      );
      expect(
        SearchNormalizer.matches(query: 'سمن', target: 'زبدة لابل'),
        isFalse,
      );
    });

    test('scores exact and prefix matches higher', () {
      expect(SearchNormalizer.matchScore(query: 'lait', target: 'lait'), 100);
      expect(
        SearchNormalizer.matchScore(query: 'lait', target: 'lait candia'),
        75,
      );
      expect(
        SearchNormalizer.matchScore(query: 'candia', target: 'lait candia'),
        50,
      );
      expect(
        SearchNormalizer.matchScore(query: 'and', target: 'lait candia'),
        25,
      );
      expect(
        SearchNormalizer.matchScore(query: 'yaourt', target: 'lait candia'),
        -1,
      );
    });
  });
}
