class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  AuthException.unauthorizedAccess() : message = 'Unauthorized access';

  @override
  String toString() {
    return 'AuthException{message: $message}';
  }
}
