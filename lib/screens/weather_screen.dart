import 'package:flutter/material.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '27°C',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.wb_sunny, size: 40),
                SizedBox(width: 10),
                Text('Sunny', style: TextStyle(fontSize: 25)),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Humidity: 60%', style: TextStyle(fontSize: 20)),
            const Text('Wind: 5 km/h', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.wb_cloudy),
                    title: Text('Day ${index + 1}'),
                    subtitle: const Text('Cloudy - 25°C'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
