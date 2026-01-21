import 'package:flutter/material.dart';

class ErrorHandler {
  static void handle(BuildContext context, dynamic error, {VoidCallback? onRetry}) {
    String message = 'An unexpected error occurred';

    if (error is NetworkException) {
      message = error.message;
    } else if (error is UnauthorizedException) {
      message = 'Please login again';
      _handleLogout(context);
      return;
    } else if (error is ValidationException) {
      message = error.message;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: onRetry != null
            ? SnackBarAction(label: 'Retry', onPressed: onRetry)
            : null,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  static void _handleLogout(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class UnauthorizedException implements Exception {}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
}

