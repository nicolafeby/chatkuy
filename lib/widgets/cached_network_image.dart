import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final BoxFit? fit;
  final double? height;
  final double? width;
  final DefaultCacheManager? cacheManager;
  final Widget Function(
    BuildContext context,
    String url,
    dynamic error,
  )? errorWidget;
  final Widget Function(
    BuildContext context,
    String url,
    DownloadProgress downloadProgress,
  )? progressWidget;
  const CustomCachedNetworkImage({
    required this.imageUrl,
    this.fit,
    this.height,
    this.errorWidget,
    this.width,
    super.key,
    this.cacheManager,
    this.progressWidget,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          //debugger never comes here
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      imageUrl: imageUrl ?? 'https://placehold.co/600x400/000000/FFF',
      fit: fit,
      width: width,
      height: height,
      cacheManager: cacheManager,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
