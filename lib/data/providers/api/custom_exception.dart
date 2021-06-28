class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorizedException extends CustomException {
  UnauthorizedException([message]) : super(message, "Unauthorized: ");
}

class ForbiddenException extends CustomException {
  ForbiddenException([message]) : super(message, "Forbidden Request: ");
}

class NotFoundException extends CustomException {
  NotFoundException([message]) : super(message, "Not Found: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}

class InternalServerException extends CustomException {
  InternalServerException([String message])
      : super(message, "Internal Server Error: ");
}

class ServiceUnavailableException extends CustomException {
  ServiceUnavailableException([String message])
      : super(message, "Service Unavailable: ");
}
