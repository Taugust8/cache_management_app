import 'package:cache_management_app/cache/cache_entry.dart';
import 'package:cache_management_app/cache/cache_entry_adapter.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CacheManager {
  factory CacheManager() => _instance;
  CacheManager._internal();
  static final CacheManager _instance = CacheManager._internal();
  static CacheManager get instance => _instance;

  final String _boxName = 'cacheBox';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CacheEntryAdapter());
    await Hive.openBox(_boxName);
  }

  void clear() {
    Hive.box(_boxName).clear();
  }

  Future<void> saveData(String key, dynamic data,
      {int expiryDurationInSeconds = 3600}) async {
    final box = Hive.box(_boxName);
    final cacheEntry = CacheEntry(
        data, DateTime.now().add(Duration(seconds: expiryDurationInSeconds)));
    await box.put(key, cacheEntry);
  }

  dynamic fetchData(String key) {
    final box = Hive.box(_boxName);
    final cacheEntry = box.get(key) as CacheEntry?;
    if (cacheEntry != null && !cacheEntry.isExpired()) {
      return cacheEntry.data;
    } else {
      return null;
    }
  }
}
