import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static Future getJson({required String key}) async {
    dynamic cache;
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      cache = sharedPreferences.getString(key);
    } catch (e) {
      debugPrint('Cache URL had a change => $e');
    }
    dynamic jsonMapCache;
    if (cache != null) {
      jsonMapCache = jsonDecode(cache) as Map<dynamic, dynamic>;
    }
    return jsonMapCache;
  }

  static Future deleteKey(String key, [dynamic takeAction]) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(key).whenComplete(() => takeAction);
  }

  static Future setJson(
      {required String key, required Map<dynamic, dynamic> value}) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    var jsonMap = value;
    await sharedPreferences.setString(key, jsonEncode(jsonMap));
  }
}
