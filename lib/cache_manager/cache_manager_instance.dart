import 'package:password_manager/export.dart';

class CacheManagerInstance {
  static CustomCacheManager? _instance;

  static CustomCacheManager get instance {
    _instance ??= CustomCacheManager();
    return _instance!;
  }
}
