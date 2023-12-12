import 'package:cache_management_app/api/api_client.dart';
import 'package:cache_management_app/cache/cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PhotoGalleryScreenState();
}

class _PhotoGalleryScreenState extends State<GalleryScreen> {
  CacheManager get _cacheManager => CacheManager.instance;
  final String accessKey = 'GVBLAKvuz9TgX05CjgS_MSETQpZOMncJ8fuomLoadkA';
  List<String> imageUrls = [];

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await fetchImages();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    if (_cacheManager.fetchData('gallery') == null) {
      await Future.delayed(const Duration(seconds: 3));
      List<dynamic> response = await ApiClient.instance.getData(
          'https://api.unsplash.com/photos/random?count=30&client_id=$accessKey');
      List<String> newImageUrls = response
          .map((imageData) => imageData['urls']['raw'] as String)
          .toList();
      _cacheManager.saveData('gallery', newImageUrls);
      setState(() {
        imageUrls = newImageUrls;
      });
    } else {
      setState(() {
        imageUrls = _cacheManager.fetchData('gallery');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: CachedNetworkImage(
                  imageUrl: imageUrls[index],
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      SizedBox(
                          height: 20,
                          child: Center(
                              child: CircularProgressIndicator(
                                  color: Colors.blue,
                                  value: downloadProgress.progress))),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
