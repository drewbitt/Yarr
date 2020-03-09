import 'package:royalroad_api/royalroad_api.dart';
import 'package:test/test.dart';

void main() {
  test('Search single novel', () async {
    final result = await searchFiction('King of Avarice');
    expect(result[0].title, 'The King of Avarice');
  });
}
