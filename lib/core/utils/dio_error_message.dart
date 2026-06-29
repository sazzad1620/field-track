import 'package:dio/dio.dart';

String dioErrorMessage(DioException e, {required String fallback}) {
  final data = e.response?.data;
  if (data is Map<String, dynamic>) {
    final error = data['error'];
    if (error is Map<String, dynamic>) {
      final message = error['message'];
      if (message is String && message.isNotEmpty) return message;
    }
    final message = data['message'];
    if (message is String && message.isNotEmpty) return message;
  }
  return fallback;
}
