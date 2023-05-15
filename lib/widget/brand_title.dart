import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/constant/export_constant.dart';

class BrandTitle extends StatelessWidget {
  const BrandTitle({
    required this.title,
    required this.id,
    super.key,
  });
  final String id, title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          capitalizeFirstLetter(title),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: Theme.of(context).textTheme.headlineLarge?.fontSize,
              fontWeight: FontWeight.bold),
        ),
        id.isNotEmpty
            ? CircleAvatar(
                radius: 34,
                backgroundColor: Theme.of(context).primaryColor,
                child: CircleAvatar(
                  radius: 30,
                  child: CachedNetworkImage(
                    imageUrl: "https://api.multiavatar.com/$id Bond.png",
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
                        errorBuilder: (context, error, stackTrace) {
                          if (error is SocketException) {
                            return const Center(
                                child: Icon(Icons.error_outline));
                          } else if (error is TimeoutException) {
                            return const Center(
                                child: Icon(Icons.error_outline));
                          } else {
                            return const Center(
                                child: Icon(Icons.error_outline));
                          }
                        },
                      );
                    },
                  ),
                ),
              )
            : CircleAvatar(
                backgroundColor: Theme.of(context).highlightColor,
                radius: 34,
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
      ],
    );
  }
}
