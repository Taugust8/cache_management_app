import 'package:cache_management_app/data/weather_data_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  WeatherDataManager get _weatherDataManager => WeatherDataManager.instance;
  final String city = 'Montreal';
  Map<dynamic, dynamic> weatherData = <String, dynamic>{};

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    setState(() {
      _refreshController.refreshCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: FutureBuilder(
              future: _weatherDataManager.fetchWeather(city: city),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.orange,
                  ));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('No data available'));
                } else {
                  weatherData = snapshot.data!;

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Last update : ${weatherData['location']['localtime']}',
                        ),
                        Text(
                          weatherData['location']['name'],
                          style: const TextStyle(
                              fontSize: 50, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${weatherData['location']['region']}, ${weatherData['location']['country']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '${weatherData['current']['temp_c']} °C',
                          style: const TextStyle(
                              fontSize: 50, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl:
                                  'https:${weatherData['current']['condition']['icon']}',
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => SizedBox(
                                      height: 10,
                                      child: Center(
                                          child: CircularProgressIndicator(
                                              strokeWidth: 1,
                                              color: Colors.orange,
                                              value:
                                                  downloadProgress.progress))),
                            ),
                            const SizedBox(width: 10),
                            Text(weatherData['current']['condition']['text'],
                                style: const TextStyle(fontSize: 25)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text('Humidity: ${weatherData['current']['humidity']}%',
                            style: const TextStyle(fontSize: 20)),
                        Text('Wind: ${weatherData['current']['wind_kph']} km/h',
                            style: const TextStyle(fontSize: 20)),
                        const SizedBox(height: 30),
                      ],
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}
