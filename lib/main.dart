import 'dart:convert';

import 'package:mEyeApp/exception/ExceptionHandler.dart';
import 'package:mEyeApp/screens/app_config_json.dart';
import 'package:mEyeApp/theme/theme.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'package:misrut_core/misrut_core.dart';
import 'package:mEyeApp/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  StorageRepository storageRepository = StorageRepository();
  // TODO: CHANGE BEFORE PROD RELEASE
  APIRepository apiRepository = APIRepository(
    storageRepository: storageRepository,
    baseUrls: {
      "uat": "https://checkoutapi-uat.mEyeApp.in",
      "prod": "https://checkoutapi.mEyeApp.in",
    },
    baseUrlApiPath: "/api",
    baseUrlName: "uat",
    exceptionHandler: MyExceptionHandler(),
    timeout: 45,
  );
  AppRepository appRepository = AppRepository(
    apiRepository: apiRepository,
    getAppConfig: (APIRepository apiRepository) async {
      return jsonDecode(app_configPageJson)['data'];
      // Map? appConfig = await apiRepository.post(path: '/get-config');
      // return appConfig["data"];
    },
  );
  UserRepository userRepository = UserRepository(
    apiRepository: apiRepository,
    storageRepository: storageRepository,
  );
  ThemeRepository themeRepository = ThemeRepository(
    theme: MyTheme(),
  );
  runApp(
    MyApp(
      appRepository: appRepository,
      apiRepository: apiRepository,
      userRepository: userRepository,
      storageRepository: storageRepository,
      themeRepository: themeRepository,
    ),
  );
}
