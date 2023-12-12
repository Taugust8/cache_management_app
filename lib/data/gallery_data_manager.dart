import 'package:cache_management_app/api/api_client.dart';
import 'package:cache_management_app/cache/cache_manager.dart';

class GalleryDataManager {
  factory GalleryDataManager() => _instance;
  GalleryDataManager._internal();
  static final GalleryDataManager _instance = GalleryDataManager._internal();
  static GalleryDataManager get instance => _instance;

  CacheManager get _cacheManager => CacheManager.instance;

  final String accessKey = 'GVBLAKvuz9TgX05CjgS_MSETQpZOMncJ8fuomLoadkA';

  Future<List<String>> fetchImages(
      {int count = 30, bool cacheEnabled = true}) async {
    final apiUrl =
        'https://api.unsplash.com/photos/random?count=$count&client_id=$accessKey';

    if (cacheEnabled) {
      // Attempting to retrieve from cache
      final cachedData = _cacheManager.fetchData(apiUrl);

      if (cachedData != null) {
        print('Gallery data retrieved from cache');
        return cachedData;
      }
    }

    // If the data is not cached, make an API call
    final List<dynamic> responseData = await ApiClient.instance.getData(apiUrl);

    List<String> imageUrls = responseData
        .map((imageData) => imageData['urls']['raw'] as String)
        .toList();

    // Saving data to cache
    await _cacheManager.saveData(apiUrl, imageUrls,
        expiryDurationInSeconds: 20);

    return imageUrls;
  }
}