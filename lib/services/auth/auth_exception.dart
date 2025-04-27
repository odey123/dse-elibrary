// register exceptions
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// login exceptions
class UserNotFoundAuthException implements Exception {}

class UserMismatchAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

class UserDisabledAuthException implements Exception {}

class TooManyRequestAuthException implements Exception {}

class InvalidCredentialAuthException implements Exception {}

// network
class NetworkRequestFailedAuthException implements Exception {}

// generic exceptions
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
