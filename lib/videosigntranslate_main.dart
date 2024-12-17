import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_sign_translate/data/sign_video_data.dart';

const String kHiveDirectory = 'video_sign_translate/hive';
const String kGifFolderDirectory = 'video_sign_translate/gif';
const String kHiveUrlBoxName = 'signBox';
Box<SignVideoData> kSignBox = Hive.box<SignVideoData>(kHiveUrlBoxName);
ValueListenable<Box<SignVideoData>> kSignBoxListenable = kSignBox.listenable();

class VideoSignTranslate {
  static final VideoSignTranslate _instance = VideoSignTranslate._internal();
  late String _apiKey;
  late String _appName;
  late String _packageName;
  late String _version;
  late String _buildNumber;
  bool _isInitialized = false;

  factory VideoSignTranslate() {
    return _instance;
  }

  VideoSignTranslate._internal();

  String get appName => _appName;
  String get packageName => _packageName;
  String get version => _version;
  String get buildNumber => _buildNumber;

  /// Initialize the WeAccess package with the [apiKey].
  ///
  /// This method should be called before using any other methods in the package.
  ///
  /// [apiKey] is the API key provided by WeAccess.
  ///
  /// This function [WidgetsFlutterBinding.ensureInitialized] contains.
  static Future<void> init({required String apiKey}) async {
    _instance._apiKey = apiKey;
    _instance._isInitialized = true;
    WidgetsFlutterBinding.ensureInitialized();
    getAppInfo();
    await _initializeHiveBox();
    await createGifFolder();
  }

  static void ensureInitialized() {
    if (!_instance._isInitialized) {
      if (kDebugMode) {
        throw Exception('WeAccess has not been initialized. Please call WeAccess.init() before using the package.');
      }
    }
  }

  static Future<void> createGifFolder() async {
    final directory = await getApplicationDocumentsDirectory();
    final gifDirectory = '${directory.path}/$kGifFolderDirectory';
    final directoryExists = await Directory(gifDirectory).exists();
    if (!directoryExists) {
      await Directory(gifDirectory).create(recursive: true);
    }
  }

  static Future<void> _initializeHiveBox() async {
    final directory = await getApplicationDocumentsDirectory();
    final hiveDirectory = '${directory.path}/$kHiveDirectory';
    final directoryExists = await Directory(hiveDirectory).exists();
    if (!directoryExists) {
      await Directory(hiveDirectory).create(recursive: true);
    }
    await Hive.initFlutter(hiveDirectory);
    Hive.registerAdapter(SignVideoDataAdapter());
    Hive.registerAdapter(SignContentDataAdapter());
    await Hive.openBox<SignVideoData>(kHiveUrlBoxName);
  }

  static bool get isInitialized => _instance._isInitialized;

  String get apiKey {
    if (!_isInitialized) {
      if (kDebugMode) {
        throw Exception('WeAccess has not been initialized. Please call WeAccess.init() before using the package.');
      }
    }
    return _apiKey;
  }

  static Future<void> getAppInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    _instance._appName = packageInfo.appName; // Application Name
    _instance._packageName = packageInfo.packageName; // Application Bundle ID
    _instance._version = packageInfo.version; // Version
    _instance._buildNumber = packageInfo.buildNumber; // Build code
  }
}
