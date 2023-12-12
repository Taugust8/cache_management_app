import 'package:cache_management_app/api/api_client.dart';
import 'package:cache_management_app/cache/cache_manager.dart';

class WeatherDataManager {
  factory WeatherDataManager() => _instance;
  WeatherDataManager._internal();
  static final WeatherDataManager _instance = WeatherDataManager._internal();
  static WeatherDataManager get instance => _instance;

  CacheManager get _cacheManager => CacheManager.instance;

  final String accessKey = '77a4ea0ecda64bee967231549231112';

  Future<Map<String, dynamic>> fetchWeather(
      {required String city, bool cacheEnabled = true}) async {
    final apiUrl =
        'https://api.weatherapi.com/v1/current.json?key=$accessKey&q=$city';

    if (cacheEnabled) {
      // Attempting to retrieve from cache
      final cachedData = _cacheManager.fetchData(apiUrl);

      if (cachedData != null) {
        print('Weather data retrieved from cache');
        return cachedData;
      }
    }

    // If the data is not cached, make an API call
    final responseData = await ApiClient.instance.getData(apiUrl);

    // Saving data to cache
    await _cacheManager.saveData(apiUrl, responseData,
        expiryDurationInSeconds: 5);

    return responseData;
  }
}
