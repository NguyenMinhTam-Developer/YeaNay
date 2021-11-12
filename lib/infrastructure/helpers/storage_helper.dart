import 'package:get_storage/get_storage.dart';

import '../../configs/app_config.dart';

class StorageHelper {
  final GetStorage storage = GetStorage(AppConfig.appName);
  final String path;

  StorageHelper(this.path);

  Future<void> write(dynamic value) => storage.write(AppConfig.appName + '/' + path, value);

  dynamic read() => storage.read(AppConfig.appName + '/' + path);

  void remove() => storage.remove(AppConfig.appName + '/' + path);
}

class StorageName {
  // Path
  static const String token = 'token';
}
