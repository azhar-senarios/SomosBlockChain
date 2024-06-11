import '../../all_utills.dart';

abstract class ApiRequest {
  final String apiUrl;
  final Map<String, dynamic>? queryParams;

  late final Dio dio;

  static String? token;
  static bool isTokenStorage = true;
  ApiRequest({
    required this.apiUrl,
    this.queryParams,
  }) {
    if (isTokenStorage) {
      token = storage.authenticationToken;
    }
    dio = Dio()
      ..options = BaseOptions(
        sendTimeout: const Duration(seconds: 35),
        receiveTimeout: const Duration(seconds: 30),
        contentType: 'application/json',
      );

    if (token != null)
      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers[Keys.xAuthToken] = token;

          if (kDebugMode) {
            log(token ?? 'Error Fetching Token', name: 'User Token');
          }

          return handler.next(options);
        },
      ));
  }

  Map<String, dynamic> toJson();

  Future<Response> toCallback();
}
