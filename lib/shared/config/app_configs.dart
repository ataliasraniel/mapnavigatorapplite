import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:mapnavigatorapp/shared/utils/permissions_manager.dart';

class AppConfigs {
  static void setupDependencies() {
    final GetIt getIt = GetIt.instance;

    getIt.registerLazySingleton<PermissionsManager>(() => PermissionsManager());

    getIt.isReady<PermissionsManager>().then((_) {
      log('PermissionsManager está pronto para uso.');
    });
  }
}
