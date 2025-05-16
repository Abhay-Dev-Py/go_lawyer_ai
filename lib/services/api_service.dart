import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ApiService extends GetxService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://golawyer-abhayrdev.pythonanywhere.com';

  ApiService() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Future<Map<String, dynamic>> askLegalQuestion(String query) async {
    try {
      final response = await _dio.post(
        '/ask',
        data: {'query': query},
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw 'Failed to get response from server';
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'An unexpected error occurred';
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out';
      case DioExceptionType.badResponse:
        return 'Server returned an error: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request was cancelled';
      default:
        return 'Network error occurred';
    }
  }
}
