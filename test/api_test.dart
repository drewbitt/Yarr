import 'package:flutter_test/flutter_test.dart';
import 'package:royalroad_api/royalroad_api.dart';

void main() {
  // Duplicate test inside module to ensure module usage is OK
  test('Search single novel', () async {
    final result = await searchFiction('King of Avarice');
    expect(result[0].book.title, 'The King of Avarice');
  });
}