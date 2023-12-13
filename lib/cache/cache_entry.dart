import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class CacheEntry extends HiveObject {
  @HiveField(0)
  final dynamic data;

  @HiveField(1)
  final DateTime expiryTime;

  CacheEntry(this.data, this.expiryTime);

  bool isExpired() {
    return DateTime.now().isAfter(expiryTime);
  }
}
