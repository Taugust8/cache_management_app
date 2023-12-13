import 'package:cache_management_app/cache/cache_manager.dart';

abstract class AbstractDataManager {
  bool cacheEnabled = true;
  int expirationDurationInSeconds = 3600;
  CacheManager get cacheManager => CacheManager.instance;
}
