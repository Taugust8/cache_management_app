import 'dart:convert';
import 'dart:typed_data';

import 'package:cache_management_app/cache/cache_entry.dart';
import 'package:cache_management_app/cache/cache_entry_adapter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
    await Hive.openBox(_boxName,
        encryptionCipher: HiveAesCipher(await _getEncryptionKey()));
  }

  Future<Uint8List> _getEncryptionKey() async {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    var containsEncryptionKey =
        await secureStorage.containsKey(key: 'encryptionKey');
    if (!containsEncryptionKey) {
      var key = Hive.generateSecureKey();
      await secureStorage.write(
          key: 'encryptionKey', value: base64UrlEncode(key));
    }
    var encryptionKey =
        base64Url.decode((await secureStorage.read(key: 'encryptionKey'))!);

    return encryptionKey;
  }

  void clear() {
    Hive.box(_boxName).clear();
    print('Cache cleared');
  }

  Future<void> saveData(String key, dynamic data,
      {int expirationDurationInSeconds = 3600}) async {
    final box = Hive.box(_boxName);
    final cacheEntry = CacheEntry(
        data, DateTime.now().add(Duration(seconds: expirationDurationInSeconds)));
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
