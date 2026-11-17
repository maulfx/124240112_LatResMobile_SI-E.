import 'package:flutter_test/flutter_test.dart';
import 'package:latres_2/models/space_item.dart';

void main() {
  test('SpaceItem fromJson and toJson serialization test', () {
    final json = {
      'id': 101,
      'title': 'Test Title',
      'url': 'https://example.com/test',
      'image_url': 'https://example.com/image.jpg',
      'news_site': 'NASA',
      'summary': 'Test summary space mission',
      'published_at': '2026-11-17T00:00:00Z',
    };

    final item = SpaceItem.fromJson(json, endpoint: 'articles');
    expect(item.id, 101);
    expect(item.title, 'Test Title');
    expect(item.newsSite, 'NASA');
    expect(item.endpoint, 'articles');

    final backToJson = item.toJson();
    expect(backToJson['id'], 101);
    expect(backToJson['title'], 'Test Title');
  });
}

