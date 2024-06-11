import '../../all_utills.dart';

class AuthRepository extends Repository {
  Future<ApiResponse> createPassword(ApiRequest request) {
    return super.executeAPI(request, CreatePasswordResponse.fromJson);
  }

  Future<ApiResponse> verifyPasswordPhrase(ApiRequest request) {
    return super.executeAPI(request, VerifyPasswordPhaseResponse.fromJson);
  }

  Future<ApiResponse> importWallet(ApiRequest request) {
    return super.executeAPI(request, ImportWalletResponse.fromJson);
  }

  Future<ApiResponse> verifyPassword(ApiRequest request) {
    return super.executeAPI(request, VerifyPasswordResponse.fromJson);
  }

  Future<ApiResponse> resetPassword(ApiRequest request) {
    return super.executeAPI(request, ResetPasswordResponse.fromJson);
  }
}
