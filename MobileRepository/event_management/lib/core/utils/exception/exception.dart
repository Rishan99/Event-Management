class _AppException implements Exception {
  final String? message;
  _AppException({this.message});

  @override
  String toString() {
    return (message ?? "Error").toString();
  }
}

class NoInternetException extends _AppException {
  NoInternetException({super.message});
}

class SessionExpiredException extends _AppException {
  SessionExpiredException({super.message});
}

class ForbiddenException extends _AppException {
  ForbiddenException({super.message});
}
