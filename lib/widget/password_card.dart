import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/constant/export_constant.dart';
import 'package:password_manager/export.dart';

class PasswordGroupCard extends StatelessWidget {
  const PasswordGroupCard({
    super.key,
    required this.groupPassword,
  });
  final GroupPassword groupPassword;
  @override
  Widget build(BuildContext context) {
    String groupId = groupPassword.groupId;
    return Card(
      color: Theme.of(context).secondaryHeaderColor,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 70,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: CircleAvatar(
                      radius: 23,
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://api.multiavatar.com/$groupId Bond.png",
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          if (error is SocketException) {
                            return const Center(
                                child: Icon(Icons.error_outline));
                          } else if (error is TimeoutException) {
                            return const Center(
                                child: Text('Request timed out'));
                          } else {
                            return const Center(
                                child: Text('Failed to load image'));
                          }
                        },
                        imageBuilder: (context, imageProvider) {
                          return Image.network(
                            "https://api.multiavatar.com/$groupId Bond.png",
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
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    capitalizeFirstLetter(groupPassword.groupName),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
                color: Theme.of(context).primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
