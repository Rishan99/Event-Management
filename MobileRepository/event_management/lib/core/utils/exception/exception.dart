class AppException implements Exception {
  final String? message;
  AppException({this.message});

  @override
  String toString() {
    return (message ?? "Error").toString();
  }
}

class NoInternetException extends AppException {
  NoInternetException({super.message});
}

class SessionExpiredException extends AppException {
  SessionExpiredException({super.message});
}

class ForbiddenException extends AppException {
  ForbiddenException({super.message});
}
