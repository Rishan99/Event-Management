import 'package:dio/dio.dart';
import 'package:event_management/core/utils/utils.dart';

class ErrorHandler {
  ErrorHandler._();
  static handleDioError(dynamic errors) {
    if (errors.runtimeType == DioError) {
      DioError error = errors;
      switch (error.type) {
        case DioErrorType.connectionTimeout:
          throw AppException(message: 'Connection Timeout');
        case DioErrorType.sendTimeout:
          throw AppException(message: 'Request Timeout');
        case DioErrorType.receiveTimeout:
          throw AppException(message: 'Response Timeout');
        case DioErrorType.badResponse:
          if (error.response!.statusCode == 401) {
            throw SessionExpiredException(message: "Session has expired");
          } else {
            throw AppException(message: error.response!.data?.toString() ?? "Error, Please try again");
          }
        case DioErrorType.cancel:
          throw AppException(message: 'Connection was canceled');
        case DioErrorType.connectionError:
          if ((error.message ?? '').toLowerCase().contains('socketexception')) {
            throw NoInternetException(message: "No internet connection or server offline");
          } else {
            throw AppException(message: error.message.toString());
          }
        default:
          throw AppException(message: error.message ?? '');
      }
    }
    throw AppException(message: errors.toString());
  }
}
