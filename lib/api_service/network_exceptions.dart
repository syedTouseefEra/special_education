

import 'dart:async';
import 'dart:io';

class NetworkExceptions {
  static Exception getApiException(dynamic error) {
    if (error is SocketException) {
      return const SocketException("No internet connection");
    } else if (error is FormatException) {
      return const FormatException("Invalid response format");
    } else if (error is TimeoutException) {
      return TimeoutException("Request timed out");
    } else {
      return Exception("Unexpected error: $error");
    }
  }
}