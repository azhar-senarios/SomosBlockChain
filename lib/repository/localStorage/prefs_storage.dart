import '../../all_utills.dart';

class PrefsStorage implements IStorage {
  static late SharedPreferences _prefs;

  static const authUser = 'authUser';
  static const bioMetricKey = 'biometricUser';
  static const walletCreatedKey = 'walletCreatedKey';
  static const dialogueCountKey = 'dialogue-count';
  static const termConditionKey = 'termConditionKey';
  static const pricePlanKey = 'pricePlanKey';

  @override
  Future<void> init() async => _prefs = await SharedPreferences.getInstance();

  @override
  dynamic read(String key) {
    if (kDebugMode) {
      log(key, name: 'Local Storage Read: $key', time: DateTime.now());
    }

    return _prefs.get(key);
  }

  @override
  Future<void> write(String key, String value) async {
    if (kDebugMode) {
      log(value, name: 'Local Storage Write: $key', time: DateTime.now());
    }

    await _prefs.setString(key, value);
  }

  @override
  Future<void> writeBool(String key, bool value) async {
    if (kDebugMode) {
      log(value.toString(),
          name: 'Local Storage Write: $key', time: DateTime.now());
    }

    await _prefs.setBool(key, value);
  }

  @override
  Future<bool> clear(String key) async {
    if (kDebugMode) {
      log(key, name: 'Local Storage Clear: $key', time: DateTime.now());
    }

    return await _prefs.remove(key);
  }

  @override
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }

  @override
  Future<bool> setUserAuthToken(String tokenUser) async {
    if (kDebugMode) {
      log(
        tokenUser,
        name: 'Local Storage Write: $authUser',
        time: DateTime.now(),
      );
    }

    return await _prefs.setString(authUser, tokenUser);
  }

  @override
  String? get authenticationToken => _prefs.getString(authUser);

  @override
  Future<bool> setBiometric(bool biometric) async {
    return await _prefs.setBool(bioMetricKey, biometric);
  }

  @override
  bool get isBiometric => _prefs.getBool(bioMetricKey) ?? false;

  @override
  Future<bool> setWallet(bool isWalletCreated) async {
    return await _prefs.setBool(walletCreatedKey, isWalletCreated);
  }

  @override
  bool get walletCreated => _prefs.getBool(walletCreatedKey) ?? false;

  @override
  int get dialogueCount => _prefs.get(dialogueCountKey) == null
      ? 0
      : int.parse(_prefs.get(dialogueCountKey).toString());

  @override
  bool get isTermRead => _prefs.getBool(termConditionKey) ?? false;

  @override
  bool get planScreenRead => _prefs.getBool(pricePlanKey) ?? false;

  @override
  Future<bool> setPlanScreenRead(bool priceRead) async {
    return await _prefs.setBool(pricePlanKey, priceRead);
  }

  @override
  Future<bool> setTermConditionRead(bool termRead) async {
    return await _prefs.setBool(termConditionKey, termRead);
  }
}
