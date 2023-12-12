import 'dart:async';

import 'package:cache_management_app/cache/cache_manager.dart';
import 'package:cache_management_app/screens/gallery_screen.dart';
import 'package:cache_management_app/screens/weather_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

void main() async {
  await CacheManager.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    _messangerKey.currentState!.hideCurrentSnackBar();
    _messangerKey.currentState!.showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              result.name == ConnectionState.none.name
                  ? 'Network disabled'
                  : 'Network enabled',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            InkWell(
              onTap: () {
                _messangerKey.currentState!.hideCurrentSnackBar();
                CacheManager.instance.clear();
                _messangerKey.currentState!.showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        Text(
                          'Cache cleared',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                        )
                      ],
                    ),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'Clear cache',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.clear,
                        color: Colors.white,
                      )
                    ],
                  )),
            ),
          ],
        ),
        duration: const Duration(hours: 1),
      ),
    );
  }

  final List<Widget> _screens = [
    const WeatherScreen(),
    const GalleryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      home: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: SalomonBottomBar(
          unselectedItemColor: Colors.blue,
          currentIndex: _selectedIndex,
          onTap: (i) => _onItemTapped(i),
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.sunny),
              title: const Text("Weather"),
              selectedColor: Colors.orange,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.image),
              title: const Text("Gallery"),
              selectedColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
