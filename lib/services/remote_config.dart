import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigManager {
  RemoteConfigManager._internal();

  static final RemoteConfigManager instance = RemoteConfigManager._internal();

  factory RemoteConfigManager() => instance;

  final _remoteConfig = FirebaseRemoteConfig.instance;
  bool _isDev = true;
   bool _isLive = false;
   bool _isShowBuyer = true;

  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(minutes: 1),
    ));
    await _remoteConfig.setDefaults(<String, dynamic>{'isDev': _isDev});
    await _remoteConfig.setDefaults(<String, dynamic>{'isLive': _isLive});
    await _remoteConfig.setDefaults(<String, dynamic>{'isShowBuyer': _isShowBuyer});
    await _remoteConfig.fetchAndActivate();
    _isDev = _remoteConfig.getBool('isDev');
    _isLive = _remoteConfig.getBool('isLive');
    _isShowBuyer = _remoteConfig.getBool('isShowBuyer');
  }

  static Future<void> fetchAndActivate() async {
    await instance.initialize();
  }

  bool get isDev => _isDev;
  bool get isLive => _isLive;
  bool get showBuyer => _isShowBuyer;
}
