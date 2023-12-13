import 'package:cache_management_app/cache/cache_entry.dart';
import 'package:hive/hive.dart';

class CacheEntryAdapter extends TypeAdapter<CacheEntry> {
  @override
  final int typeId = 0;

  @override
  CacheEntry read(BinaryReader reader) {
    return CacheEntry(
      reader.read(),
      reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, CacheEntry obj) {
    writer.write(obj.data);
    writer.write(obj.expirationTime);
  }
}
