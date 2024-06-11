abstract class IStorage {
  Future<void> init();
  dynamic read(String key);
  Future<void> write(String key, String value);
  Future<void> writeBool(String key, bool value);
  Future<bool> clear(String key);
  Future<bool> setTermConditionRead(bool read);
  bool get isTermRead;
  Future<bool> setPlanScreenRead(bool read);
  bool get planScreenRead;
  Future<bool> clearAll();
  Future<bool> setBiometric(bool biometric);
  Future<bool> setWallet(bool isWalletCreated);
  bool get walletCreated;
  bool get isBiometric;
  Future<bool> setUserAuthToken(String authToken);
  String? get authenticationToken;
  int get dialogueCount;
}
