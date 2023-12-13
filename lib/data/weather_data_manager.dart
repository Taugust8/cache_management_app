import 'package:cache_management_app/api/api_client.dart';
import 'package:cache_management_app/data/abstract_data_manager.dart';

class WeatherDataManager extends AbstractDataManager {
  factory WeatherDataManager() => _instance;
  WeatherDataManager._internal();
  static final WeatherDataManager _instance = WeatherDataManager._internal();
  static WeatherDataManager get instance => _instance;

  final String _accessKey = '77a4ea0ecda64bee967231549231112';

  Future<Map<dynamic, dynamic>> fetchWeather({required String city}) async {
    final apiUrl =
        'https://api.weatherapi.com/v1/current.json?key=$_accessKey&q=$city';

    if (cacheEnabled) {
      // Attempting to retrieve from cache
      final cachedData = cacheManager.fetchData(apiUrl);

      if (cachedData != null) {
        print('Weather data retrieved from cache');
        return cachedData;
      }
    }

    //Voluntary delays to demonstrate a long execution query
    await Future.delayed(const Duration(seconds: 2));

    // If the data is not cached, make an API call
    final responseData = await ApiClient.instance.getData(apiUrl);

    // Saving data to cache
    await cacheManager.saveData(apiUrl, responseData,
        expirationDurationInSeconds: expirationDurationInSeconds);

    return responseData;
  }
}
