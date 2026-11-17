import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/space_item.dart';

class FavoriteService {
  static const String _favKey = 'favorite_items';

  static Future<List<SpaceItem>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> list = prefs.getStringList(_favKey) ?? [];
    return list.map((item) => SpaceItem.fromJson(jsonDecode(item))).toList();
  }

  static Future<bool> isFavorite(int id) async {
    final favorites = await getFavorites();
    return favorites.any((item) => item.id == id);
  }

  static Future<bool> toggleFavorite(SpaceItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    final index = favorites.indexWhere((e) => e.id == item.id);

    bool isAdded;
    if (index >= 0) {
      favorites.removeAt(index);
      isAdded = false;
    } else {
      favorites.add(item);
      isAdded = true;
    }

    final List<String> stringList =
        favorites.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_favKey, stringList);
    return isAdded;
  }
}
