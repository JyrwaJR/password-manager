import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/cache_manager/cache_manager_instance.dart';

class BrandCircularAvatar extends StatefulWidget {
  const BrandCircularAvatar({
    Key? key,
    required this.id,
    required this.radius,
  }) : super(key: key);

  final String id;
  final double radius;

  @override
  State<BrandCircularAvatar> createState() => _BrandCircularAvatarState();
}

class _BrandCircularAvatarState extends State<BrandCircularAvatar> {
  final cacheManager = CacheManagerInstance.instance;
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    final imageUrl = "https://api.multiavatar.com/${widget.id} Bond.png";
    final cachedImageProvider = CachedNetworkImageProvider(
      imageUrl,
      cacheManager: cacheManager.getManager(),
    );

    return CircleAvatar(
      backgroundColor: primaryColor,
      radius: widget.radius + 2,
      child: CircleAvatar(
        radius: widget.radius,
        child: FutureBuilder<bool>(
          future: cachedImageProvider.evict(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingIndicator();
            } else if (snapshot.hasError) {
              return const Center(child: Icon(Icons.error_outline));
            } else if (snapshot.data == true) {
              return Image(
                image: cachedImageProvider,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  return _buildLoadingBuilder(child, loadingProgress);
                },
                errorBuilder: (context, error, stackTrace) {
                  return _handleImageError(
                    error,
                  );
                },
              );
            } else {
              return CachedNetworkImage(
                imageUrl: imageUrl,
                cacheManager: cacheManager.getManager(),
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildLoadingIndicator(),
                errorWidget: (context, url, error) => _handleImageError(
                  error,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildLoadingBuilder(Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) {
      return child;
    }

    final progressValue = loadingProgress.cumulativeBytesLoaded /
        int.parse(loadingProgress.expectedTotalBytes.toString());

    return Center(
      child: CircularProgressIndicator(value: progressValue),
    );
  }

  Widget _handleImageError(
    dynamic error,
  ) {
    if (error is SocketException || error is TimeoutException) {
      return CachedNetworkImage(
        imageUrl: "https://api.multiavatar.com/${widget.id} Bond.png",
        cacheManager: cacheManager.getManager(),
        useOldImageOnUrlChange: false,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildLoadingIndicator(),
        errorWidget: (context, url, error) =>
            const Center(child: Icon(Icons.error_outline)),
      );
    } else {
      return const Center(child: Icon(Icons.error_outline));
    }
  }
}
