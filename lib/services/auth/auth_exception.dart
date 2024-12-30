//Login Exceptions
class InvalidCredentialsAuthException implements Exception {}

//Register Exceptions
class WeakPasswordAuthException implements Exception {}

class EmailInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

//Generic Exceptions
class ChannelErrorAuthException implements Exception {}

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
