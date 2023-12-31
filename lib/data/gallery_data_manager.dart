import 'package:cache_management_app/api/api_client.dart';
import 'package:cache_management_app/data/abstract_data_manager.dart';

class GalleryDataManager extends AbstractDataManager {
  factory GalleryDataManager() => _instance;
  GalleryDataManager._internal();
  static final GalleryDataManager _instance = GalleryDataManager._internal();
  static GalleryDataManager get instance => _instance;

  final String _accessKey = 'GVBLAKvuz9TgX05CjgS_MSETQpZOMncJ8fuomLoadkA';

  Future<List<String>> fetchImages({int count = 30}) async {
    final apiUrl =
        'https://api.unsplash.com/photos/random?count=$count&client_id=$_accessKey';

    if (cacheEnabled) {
      // Attempting to retrieve from cache
      final cachedData = cacheManager.fetchData(apiUrl);

      if (cachedData != null) {
        print('Gallery data retrieved from cache');
        return cachedData;
      }
    }

    //Voluntary delays to demonstrate a long execution query
    await Future.delayed(const Duration(seconds: 2));

    // If the data is not cached, make an API call
    final List<dynamic> responseData = await ApiClient.instance.getData(apiUrl);

    List<String> imageUrls = responseData
        .map((imageData) => imageData['urls']['raw'] as String)
        .toList();

    // Saving data to cache
    await cacheManager.saveData(apiUrl, imageUrls,
        expirationDurationInSeconds: expirationDurationInSeconds);

    return imageUrls;
  }
}
