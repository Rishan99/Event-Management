class _AppException implements Exception {
  final String? message;
  _AppException({this.message});
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
