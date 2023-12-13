import 'package:cache_management_app/data/gallery_data_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PhotoGalleryScreenState();
}

class _PhotoGalleryScreenState extends State<GalleryScreen> {
  GalleryDataManager get _galleryDataManager => GalleryDataManager.instance;

  List<String> imageUrls = [];

  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  void _onRefresh() async {
    List<String> refreshedData =
        await _galleryDataManager.fetchImages(count: 30, cacheEnabled: true);
    setState(() {
      imageUrls = refreshedData;
    });
    _refreshController.refreshCompleted();
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
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => SizedBox(
                            height: 20,
                            child: Center(
                                child: CircularProgressIndicator(
                                    color: Colors.blue,
                                    value: downloadProgress.progress))),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                );
              },
            )),
      ),
    );
  }
}
