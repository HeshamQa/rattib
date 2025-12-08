import 'package:dio/dio.dart';
import 'package:rattib/core/constants/api_constants.dart';
import 'package:rattib/core/network/api_response.dart';

/// API Client
/// Handles all HTTP requests using Dio
class ApiClient {
  late final Dio _dio;
  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors for logging and error handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add authentication token if available
          // final token = _getStoredToken();
          // if (token != null) {
          //   options.headers['Authorization'] = 'Bearer $token';
          // }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          return handler.next(error);
        },
      ),
    );
  }

  /// GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    } catch (e) {
      return ApiResponse.error(
        message: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    } catch (e) {
      return ApiResponse.error(
        message: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    } catch (e) {
      return ApiResponse.error(
        message: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        queryParameters: queryParameters,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    } catch (e) {
      return ApiResponse.error(
        message: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// Handle successful response
  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(dynamic)? fromJson,
  ) {
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      final data = response.data;

      // If response is already in our expected format
      if (data is Map<String, dynamic>) {
        return ApiResponse.fromJson(data, fromJson);
      }

      // Otherwise wrap the data
      return ApiResponse.success(
        data: fromJson != null ? fromJson(data) : data as T,
        statusCode: response.statusCode,
      );
    }

    return ApiResponse.error(
      message: 'Request failed with status: ${response.statusCode}',
      statusCode: response.statusCode,
    );
  }

  /// Handle errors
  ApiResponse<T> _handleError<T>(DioException error) {
    String errorMessage;
    int? statusCode;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Connection timeout. Please check your internet connection.';
        break;
      case DioExceptionType.badResponse:
        statusCode = error.response?.statusCode;
        final data = error.response?.data;
        if (data is Map<String, dynamic> && data['message'] != null) {
          errorMessage = data['message'];
        } else {
          errorMessage = 'Server error. Please try again later.';
        }
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request cancelled.';
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'Network error. Please check your connection.';
        break;
      default:
        errorMessage = 'Something went wrong. Please try again.';
    }

    return ApiResponse.error(
      message: errorMessage,
      statusCode: statusCode,
    );
  }
}
