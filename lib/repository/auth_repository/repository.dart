import '../../all_utills.dart';

abstract class Repository {
  Future<ApiResponse> executeAPI(
    ApiRequest request,
    Function jsonParser,
  ) async {
    String message, name;
    StackTrace? apiStackTrace;
    ErrorType errorType = ErrorType.known;

    if (kDebugMode) {
      log(
        request.toJson().toString(),
        name: 'Execute API (${request.runtimeType} Request)',
      );
    }

    try {
      var response = await request.toCallback();

      final data = response.data;

      if (kDebugMode) {
        log(
          data.toString(),
          name: 'Execute API (${data.runtimeType} Response)',
        );
      }

      if (data['status'] == false) {
        log(
          data['body']['message'],
          name: 'API ERROR (KNOWN)',
          time: DateTime.now(),
        );
        throw ApiError(
          data['body']?['message'] ?? 'Something went wrong',
          ErrorType.known,
        );
      }

      return jsonParser(response.data);

      // TODO handle all the possible error scenarios
    } on SocketException catch (e, stackTrace) {
      name = 'Execute API (Socket Exception)';
      message = 'Please connect to internet';
      apiStackTrace = stackTrace;
      errorType = ErrorType.internet;
    } on FormatException catch (e, stackTrace) {
      name = 'Execute API (Format Exception) ${request.runtimeType.toString()}';
      message = 'Issue with JSON Formatting';
      apiStackTrace = stackTrace;
      errorType = ErrorType.format;
    } on TimeoutException catch (e, stackTrace) {
      name = 'Execute API (Timeout Exception)';
      message = 'Timeout occurred';
      apiStackTrace = stackTrace;
      errorType = ErrorType.timeout;
    } on Exception catch (e) {
      final updatedError = ErrorHandler.handle(e).failure;
      message =
          updatedError.message.isNotEmpty ? updatedError.message : e.toString();
      name = updatedError.message.isNotEmpty
          ? updatedError.message
          : 'Execute API (General Exception) ${request.runtimeType}';
      apiStackTrace = null;
      errorType = ErrorType.unknown;
    } catch (e, stackTrace) {
      // TODO work on this message fetching strategy
      // TODO add the firebase crashlytics functionality here
      final updatedError = ErrorHandler.handle(e).failure;
      var dartException = updatedError.message.isNotEmpty;
      message = dartException ? updatedError.message : e.toString();
      name = dartException
          ? updatedError.message
          : 'Execute API (General Exception) ${request.runtimeType}';
      apiStackTrace = dartException ? null : stackTrace;
      errorType = ErrorType.unknown;
    }

    log(
      message,
      name: name,
      time: DateTime.now(),
      stackTrace: apiStackTrace,
    );
    throw ApiError(
      message,
      errorType,
      stackTrace: apiStackTrace,
      reason: name,
    );
  }
}
