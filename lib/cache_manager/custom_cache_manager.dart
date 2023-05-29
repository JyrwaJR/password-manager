import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:uuid/uuid.dart';

class CacheManagerFactory {
  // Factory method for creating a CacheManager instance
  static CacheManager create({
    required String key, // Cache key used for identification
    required Duration
        stalePeriod, // ! Duration after which a cached object is considered stale
    required int
        maxNrOfCacheObjects, // ! Maximum number of cache objects to be stored
    required CacheInfoRepository
        repo, // ! Repository for storing cache information
    required FileService fileService, // ! Service for handling file operations
    required Duration
        maxAgeCacheObject, // ! Maximum age allowed for a cache object
  }) {
    return CacheManager(
      Config(
        key,
        stalePeriod: stalePeriod,
        maxNrOfCacheObjects: maxNrOfCacheObjects,
        repo: repo,
        fileService: fileService,
      ),
    );
  }
}

class CustomCacheManager {
  final String cacheKey;
  final CacheManager manager;

  CustomCacheManager._(this.cacheKey, this.manager);

  factory CustomCacheManager() {
    final cacheKey =
        const Uuid().v1(); // Generate a unique cache key using UUID
    final manager = CacheManagerFactory.create(
      maxAgeCacheObject: const Duration(days: 1),
      key: cacheKey,
      stalePeriod: const Duration(days: 2),
      maxNrOfCacheObjects: 20,
      repo: JsonCacheInfoRepository(databaseName: cacheKey),
      fileService: HttpFileService(),
    );
    return CustomCacheManager._(
        cacheKey, manager); // Create a new CustomCacheManager instance
  }

  CacheManager getManager() {
    return manager; // Return the CacheManager instance
  }
}
