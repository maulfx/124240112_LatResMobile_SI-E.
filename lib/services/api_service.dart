import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/space_item.dart';

class ApiService {
  static const String baseUrl = 'https://api.spaceflightnewsapi.net/v4';

  static Future<List<SpaceItem>> getItems(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint/'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List results = data['results'] ?? [];
      return results
          .map((item) => SpaceItem.fromJson(item, endpoint: endpoint))
          .toList();
    } else {
      throw Exception('Gagal memuat data dari $endpoint');
    }
  }

  static Future<SpaceItem> getItemDetail(String endpoint, int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint/$id/'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return SpaceItem.fromJson(data, endpoint: endpoint);
    } else {
      throw Exception('Gagal memuat detail data');
    }
  }
}
