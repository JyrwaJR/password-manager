import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/cache_manager/cache_manager_instance.dart';

class BrandCircularAvatar extends StatelessWidget {
  const BrandCircularAvatar({
    super.key,
    required this.id,
    required this.radius,
  });
  final String id;
  final double radius;
  @override
  Widget build(BuildContext context) {
    final cacheInstance = CacheManagerInstance.instance;
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      radius: radius + 2,
      child: CircleAvatar(
        radius: radius,
        child: CachedNetworkImage(
          imageUrl: "https://api.multiavatar.com/$id Bond.png",
          cacheManager: cacheInstance.getManager(),
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          fit: BoxFit.cover,
          errorWidget: (context, url, error) {
            if (error is SocketException) {
              return const Center(child: Icon(Icons.error_outline));
            } else if (error is TimeoutException) {
              return const Center(child: Icon(Icons.error_outline));
            } else {
              return const Center(child: Icon(Icons.error_outline));
            }
          },
          imageBuilder: (context, imageProvider) {
            return Image.network(
              "https://api.multiavatar.com/$id Bond.png",
              fit: BoxFit.cover,
              alignment: Alignment.center,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                if (error is SocketException) {
                  return const Center(child: Icon(Icons.error_outline));
                } else if (error is TimeoutException) {
                  return const Center(child: Icon(Icons.error_outline));
                } else {
                  return const Center(child: Icon(Icons.error_outline));
                }
              },
            );
          },
        ),
      ),
    );
  }
}
