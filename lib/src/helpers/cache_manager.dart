import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static Future<Map<String, dynamic>?> getJson({required String key}) async {
    String? cache;
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      cache = sharedPreferences.getString(key);
    } catch (e) {
      debugPrint('Cache URL had a change => $e');
    }
    Map<String, dynamic>? jsonMapCache;
    if (cache != null) {
      jsonMapCache = jsonDecode(cache) as Map<String, dynamic>;
    }
    return jsonMapCache;
  }

  static Future deleteKey(String key, [VoidCallback? takeAction]) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences
        .remove(key)
        .whenComplete(() => (takeAction as void Function()?)?.call());
  }

  static Future<void> setJson({
    required String key,
    required Map<String, dynamic> value,
  }) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(key, jsonEncode(value));
  }
}
