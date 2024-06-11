import 'package:somos_app/models/requests/fetch_coin_images_request.dart';
import 'package:somos_app/models/requests/fetch_recent_rates_request.dart';
import 'package:somos_app/models/response/fetch_coin_images_response.dart';
import 'package:somos_app/models/response/fetch_crypto_detail_response.dart';
import 'package:somos_app/models/response/fetch_recent_rates_response.dart';
import 'package:somos_app/models/response/fetch_selected_networkDetail_response.dart';

import '../../all_utills.dart';
import '../../models/requests/fetch_all_accounts_request.dart';
import '../../models/requests/fetch_all_network_request.dart';
import '../../models/requests/fetch_brain_tree_token.dart';
import '../../models/requests/fetch_signature_data.dart';
import '../../models/requests/get_tier_request.dart';
import '../../models/response/delete_account_response.dart';
import '../../models/response/fetch_all_accounts_response.dart';
import '../../models/response/fetch_all_network_response.dart';
import '../../models/response/fetch_brain_tree_response.dart';
import '../../models/response/fetch_response_request.dart';
import '../../models/response/get_tier_response.dart';
import '../../models/response/reveal_password_phrase_response.dart';
import '../../models/response/reveal_secret_key_response.dart';
import '../../models/response/send_crypto_response.dart';
import '../../models/response/stripe_create_customer_response.dart';
import '../../models/response/transcation_response.dart';
import '../../models/response/update_fcm_token_response.dart';

class HomeRepository extends Repository {
  Future<ApiResponse> fetchCurrencyPrice(ApiRequest request) {
    return super.executeAPI(
      request,
      FetchCurrencyPriceResponse.fromJson,
    );
  }

  Future<ApiResponse> fetchRecentRates() {
    return super.executeAPI(
      FetchRecentRatesRequest(),
      FetchRecentRatesResponse.fromJson,
    );
  }

  Future<ApiResponse> fetchCoinImages() {
    return super.executeAPI(
      FetchCoinImagesRequest(),
      FetchCoinImagesResponse.fromJson,
    );
  }

  Future<ApiResponse> fetchBrainTreeToken() {
    return super.executeAPI(
      FetchBrainTreeToken(),
      FetchBrainTreeResponse.fromJson,
    );
  }

  Future<ApiResponse> fetchCoinPricesInRange(ApiRequest request) {
    return super.executeAPI(request, FetchCoinRateByTimeFrameResponse.fromJson);
  }

  Future<ApiResponse> getTierResponse() {
    return super.executeAPI(GetTierRequest(), TierModelResponse.fromJson);
  }

  Future<ApiResponse> sendCrypto(ApiRequest apiRequest) {
    return super.executeAPI(apiRequest, SendCryptoResponse.fromJson);
  }

  Future<ApiResponse> stripeCreateCustomer(ApiRequest apiRequest) {
    return super.executeAPI(
      apiRequest,
      StripeCreateCustomerResponse.fromJson,
    );
  }

  Future<ApiResponse> fetchSelectedNetworkDetail(ApiRequest request) {
    return super.executeAPI(
      request,
      FetchSelectedNetworkDetailResponse.fromJson,
    );
  }

  Future<ApiResponse> fetchAllAccount() {
    return super.executeAPI(
      FetchAllAccountsRequest(),
      FetchAllAccountsResponse.fromJson,
    );
  }

  Future<ApiResponse> fetchTranscationHistory(ApiRequest request) {
    return super.executeAPI(
      request,
      FetchTranscationHistoryResponse.fromJson,
    );
  }

  Future<ApiResponse> fetchAllNetwork() {
    return super.executeAPI(
      FetchAllNetworkRequest(),
      FetchAllNetworkResponse.fromJson,
    );
  }

  Future<ApiResponse> fetchSignatureUrlData({ApiRequest? apiRequest}) {
    return super.executeAPI(
      apiRequest ?? FetchSignatureRequest(),
      FetchSignatureResponse.fromJson,
    );
  }

  Future<ApiResponse> removeAccount(ApiRequest request) {
    return super.executeAPI(
      request,
      DeleteAccountResponse.fromJson,
    );
  }

  Future<ApiResponse> revealPasswordPhrase(ApiRequest request) {
    return super.executeAPI(
      request,
      RevealPasswordPhraseResponse.fromJson,
    );
  }

  Future<ApiResponse> revealSecretKey(ApiRequest request) {
    return super.executeAPI(
      request,
      RevealSecretKeyResponse.fromJson,
    );
  }

  Future<ApiResponse> updateFCMToken(ApiRequest request) {
    return super.executeAPI(
      request,
      UpdateFCMTokenResponse.fromJson,
    );
  }
}
