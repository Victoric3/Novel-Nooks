import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'dart:io';

class DioConfig {
  static Dio? dio;
  static PersistCookieJar cookieJar = PersistCookieJar();

  static Future<void> setupDio() async {
    // Get the application documents directory

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = '${appDocDir.path}/.cookies';
    final dir = Directory(appDocPath);
    if (!await dir.exists()) {
      // Ensure the directory exists
      dir.createSync(recursive: true);
    }

    // Initialize PersistCookieJar with the directory path
    cookieJar = PersistCookieJar(storage: FileStorage(appDocPath));

    dio = Dio(
      BaseOptions(
        baseUrl: baseURL,
      ),
    );
    dio?.interceptors.add(CookieManager(cookieJar));
  }
}