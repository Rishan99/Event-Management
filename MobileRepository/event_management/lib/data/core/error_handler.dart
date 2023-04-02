import 'package:dio/dio.dart';
import 'package:event_management/core/utils/utils.dart';

class ErrorHandler {
  ErrorHandler._();
  static handleDioError(dynamic errors) {
    if (errors.runtimeType == DioError) {
      DioError error = errors;
      switch (error.type) {
        case DioErrorType.connectionTimeout:
          throw Exception('Connection Timeout');
        case DioErrorType.sendTimeout:
          throw Exception('Request Timeout');
        case DioErrorType.receiveTimeout:
          throw Exception('Response Timeout');
        case DioErrorType.badResponse:
          if (error.response!.statusCode == 401) {
            throw SessionExpiredException(message: "Session has expired");
          } else {
            throw Exception(error.response!.data ?? "Error, Please try again");
          }
        case DioErrorType.cancel:
          throw Exception('Connection was canceled');
        case DioErrorType.connectionError:
          if ((error.message ?? '').toLowerCase().contains('socketexception')) {
            throw NoInternetException(message: "No internet connection or server offline");
          } else {
            throw Exception(error.message.toString());
          }
        default:
          throw Exception(error.message ?? '');
      }
    }
    throw Exception(errors.toString());
  }
}
