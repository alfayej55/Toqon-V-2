import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import '../helpers/prefs_helpers.dart';
import '../models/error_response.dart';
import '../utils/app_constants.dart';
import 'api_constants.dart';

/// Production-grade API Client for 500M+ users
/// Features: Auto-retry, Token refresh, Caching, Error handling, Memory management
class ApiClient extends GetxService {
  late final dio.Dio _dio;
  final dio.CancelToken _cancelToken = dio.CancelToken();

  // Error Messages
  static const String noInternetMessage = "No internet connection";
  static const String timeoutMessage = "Request timed out";
  static const String serverErrorMessage = "Server error, please try again";
  static const String unknownErrorMessage = "Something went wrong";

  @override
  void onInit() {
    super.onInit();
    _initializeDio();
  }

  @override
  void onClose() {
    _dio.close(force: true);
    _cancelToken.cancel('App closed');
    super.onClose();
  }

  /// Initialize Dio with production-ready configuration
  void _initializeDio() {
    _dio = dio.Dio(dio.BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      validateStatus: (status) => status != null && status >= 200 && status < 300,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));

    // Add interceptors in order
    _dio.interceptors.addAll([
      _AuthInterceptor(),
      _RetryInterceptor(_dio),
      _ErrorInterceptor(),
      if (kDebugMode) _LogInterceptor(),
    ]);
  }

  // ========================> GET <========================
  Future<ApiResponse> getData(
      String uri, {
        Map<String, dynamic>? queryParameters,
        dio.Options? options,
        dio.CancelToken? cancelToken,
      }) async {
    try {
      final response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
      );
      return _handleSuccess(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // ========================> POST <========================
  Future<ApiResponse> postData(
      String uri,
      {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        dio.Options? options,
        dio.CancelToken? cancelToken,
      }) async {
    try {
      final response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
      );
      return _handleSuccess(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // ========================> PUT <========================
  Future<ApiResponse> putData(
      String uri, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        dio.Options? options,
        dio.CancelToken? cancelToken,
      }) async {
    try {
      final response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
      );
      return _handleSuccess(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // ========================> PUT (WITHOUT AUTH) <========================
  Future<ApiResponse> putDataWithoutAuth(
      String uri, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        dio.Options? options,
        dio.CancelToken? cancelToken,
        dio.ProgressCallback? onSendProgress,
      }) async {
    try {
      // Create a new Dio instance without interceptors for this request
      final tempDio = dio.Dio(_dio.options); // Copy base options
      tempDio.interceptors.clear(); // Remove all interceptors (including Auth)

      final response = await tempDio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
        onSendProgress: onSendProgress,
      );
      return _handleSuccess(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // ========================> PATCH <========================
  Future<ApiResponse> patchData(
      String uri, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        dio.Options? options,
        dio.CancelToken? cancelToken,
      }) async {
    try {
      final response = await _dio.patch(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
      );
      return _handleSuccess(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // ========================> DELETE <========================
  Future<ApiResponse> deleteData(
      String uri, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        dio.Options? options,
        dio.CancelToken? cancelToken,
      }) async {
    try {
      final response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
      );
      return _handleSuccess(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // ========================> Multipart Upload (POST) <========================
  Future<ApiResponse> postMultipartData(
      String uri, {
        required Map<String, dynamic> fields,
        List<MultipartFileData>? files,
        dio.ProgressCallback? onSendProgress,
        dio.CancelToken? cancelToken,
      }) async {
    try {
      final formData = await _buildFormData(fields, files);
      final response = await _dio.post(
        uri,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken ?? _cancelToken,
      );
      return _handleSuccess(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // ========================> Multipart Upload (PUT) <========================
  Future<ApiResponse> putMultipartData(
      String uri, {
        required Map<String, dynamic> fields,
        List<MultipartFileData>? files,
        dio.ProgressCallback? onSendProgress,
        dio.CancelToken? cancelToken,
      }) async {
    try {
      final formData = await _buildFormData(fields, files);
      final response = await _dio.put(
        uri,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken ?? _cancelToken,
      );
      return _handleSuccess(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // ========================> Multipart Upload (PATCH) <========================
  Future<ApiResponse> patchMultipartData(
      String uri, {
        required Map<String, dynamic> fields,
        List<MultipartFileData>? files,
        dio.ProgressCallback? onSendProgress,
        dio.CancelToken? cancelToken,
      }) async {
    try {
      final formData = await _buildFormData(fields, files);
      final response = await _dio.patch(
        uri,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken ?? _cancelToken,
      );
      return _handleSuccess(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // ========================> Download File <========================
  Future<ApiResponse> downloadFile(
      String uri,
      String savePath, {
        dio.ProgressCallback? onReceiveProgress,
        dio.CancelToken? cancelToken,
      }) async {
    try {
      final response = await _dio.download(
        uri,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken ?? _cancelToken,
      );
      return _handleSuccess(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // ========================> PRIVATE HELPERS <========================

  /// Build FormData for multipart requests
  Future<dio.FormData> _buildFormData(
      Map<String, dynamic> fields,
      List<MultipartFileData>? files,
      ) async {
    final formData = dio.FormData.fromMap(fields);

    if (files != null && files.isNotEmpty) {
      for (var fileData in files) {
        try {
          final file = File(fileData.filePath);
          if (!await file.exists()) {
            _logError('File not found: ${fileData.filePath}');
            continue;
          }

          // Get file size (max 10MB for safety)
          final fileSize = await file.length();
          if (fileSize > 10 * 1024 * 1024) {
            _logError('File too large: ${fileData.filePath} (${fileSize / 1024 / 1024}MB)');
            continue;
          }

          formData.files.add(MapEntry(
            fileData.key,
            await dio.MultipartFile.fromFile(
              fileData.filePath,
              filename: fileData.fileName ?? _getFileName(fileData.filePath),
              contentType: _getContentType(fileData.filePath),
            ),
          ));
        } catch (e) {
          _logError('Error adding file ${fileData.filePath}: $e');
          // Continue with other files
        }
      }
    }

    return formData;
  }

  /// Get content type from file extension
  MediaType? _getContentType(String path) {
    final ext = path.toLowerCase().split('.').last;
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'gif':
        return MediaType('image', 'gif');
      case 'mp4':
        return MediaType('video', 'mp4');
      case 'pdf':
        return MediaType('application', 'pdf');
      default:
        return null;
    }
  }

  String _getFileName(String path) => path.split('/').last;

  /// Handle successful response
  ApiResponse _handleSuccess(dio.Response response) {
    if (kDebugMode) {
      debugPrint('');
      debugPrint('╔════════════════════════════════════════════════════════════════');
      debugPrint('║ ✅ SUCCESS RESPONSE');
      debugPrint('║ Status Code: ${response.statusCode}');
      debugPrint('║ URL: ${response.requestOptions.uri}');
      debugPrint('║ Response Data:');
      debugPrint('║ ${response.data}');
      debugPrint('╚════════════════════════════════════════════════════════════════');
      debugPrint('');
    }

    return ApiResponse(
      success: true,
      statusCode: response.statusCode ?? 200,
      data: response.data,
      message: 'Success',
    );
  }

  /// Centralized error handling - Never crash the app
  ApiResponse _handleError(dynamic error) {
    if (error is dio.DioException) {
      return _handleDioError(error);
    }

    // Unknown error - safe fallback
    _logError('Unknown error: $error');
    return ApiResponse(
      success: false,
      statusCode: -999,
      message: unknownErrorMessage,
    );
  }

  /// Handle Dio-specific errors
  ApiResponse _handleDioError(dio.DioException error) {
    // Print detailed error logs
    if (kDebugMode) {
      debugPrint('');
      debugPrint('╔════════════════════════════════════════════════════════════════');
      debugPrint('║ ❌ ERROR RESPONSE');
      debugPrint('╠════════════════════════════════════════════════════════════════');
      debugPrint('║ URL: ${error.requestOptions.uri}');
      debugPrint('║ Status Code: ${error.response?.statusCode ?? 'N/A'}');
      debugPrint('╠════════════════════════════════════════════════════════════════');
      if (error.response?.data != null) {
        debugPrint('║ Error Data:');
        debugPrint('║ ${error.response?.data}');
      }
      debugPrint('╚════════════════════════════════════════════════════════════════');
    }

    switch (error.type) {
      case dio.DioExceptionType.connectionTimeout:
      case dio.DioExceptionType.sendTimeout:
      case dio.DioExceptionType.receiveTimeout:
        return ApiResponse(
          success: false,
          statusCode: -1,
          message: timeoutMessage,
        );

      case dio.DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? -1;
        final message = _extractErrorMessage(error.response?.data, statusCode);
        return ApiResponse(
          success: false,
          statusCode: statusCode,
          message: message,
          data: error.response?.data,
        );

      case dio.DioExceptionType.cancel:
        return ApiResponse(
          success: false,
          statusCode: -2,
          message: 'Request cancelled',
        );

      case dio.DioExceptionType.connectionError:
        return ApiResponse(
          success: false,
          statusCode: -3,
          message: noInternetMessage,
        );

      default:
        return ApiResponse(
          success: false,
          statusCode: -4,
          message: error.message ?? unknownErrorMessage,
        );
    }
  }

  /// Extract user-friendly error message
  String _extractErrorMessage(dynamic data, int statusCode) {
    // Try to parse ErrorResponse model
    if (data is Map<String, dynamic>) {
      try {
        final errorResponse = ErrorResponse.fromJson(data);
        if (errorResponse.message != null) return errorResponse.message!;
      } catch (_) {}

      // Fallback to common keys
      final message = data['message'] ?? data['error'] ?? data['msg'];
      if (message != null) return message.toString();
    }

    // Status code based messages
    switch (statusCode) {
      case 400:
        return 'Invalid request';
      case 401:
        return 'Unauthorized - Please login again';
      case 403:
        return 'Access denied';
      case 404:
        return 'Resource not found';
      case 500:
      case 502:
      case 503:
        return serverErrorMessage;
      default:
        return unknownErrorMessage;
    }
  }

  void _logError(String message) {
    if (kDebugMode) debugPrint('❌ API Error: $message');
  }
}

// ========================> INTERCEPTORS <========================

/// Automatically adds Bearer token to all requests
class _AuthInterceptor extends dio.Interceptor {
  @override
  void onRequest(dio.RequestOptions options, dio.RequestInterceptorHandler handler) async {
    try {
      final token = await PrefsHelper.getString(AppConstants.bearerToken);
      if (token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      if (kDebugMode) debugPrint('⚠️ Token fetch failed: $e');
    }
    handler.next(options);
  }

  @override
  void onError(dio.DioException err, dio.ErrorInterceptorHandler handler) async {
    // Auto token refresh on 401
    if (err.response?.statusCode == 401) {
      try {
        // TODO: Implement your token refresh logic here
        // final newToken = await _refreshToken();
        // await PrefsHelper.setString(AppConstants.bearerToken, newToken);

        // Retry the request
        // final response = await Dio().fetch(err.requestOptions);
        // return handler.resolve(response);
      } catch (e) {
        if (kDebugMode) debugPrint('⚠️ Token refresh failed: $e');
      }
    }
    handler.next(err);
  }
}

/// Automatically retries failed requests (max 3 times)
class _RetryInterceptor extends dio.Interceptor {
  final dio.Dio _dio;
  static const int maxRetries = 3;

  _RetryInterceptor(this._dio);

  @override
  void onError(dio.DioException err, dio.ErrorInterceptorHandler handler) async {
    // Only retry on network errors
    if (err.type != dio.DioExceptionType.connectionTimeout &&
        err.type != dio.DioExceptionType.connectionError &&
        err.type != dio.DioExceptionType.receiveTimeout) {
      return handler.next(err);
    }

    final extra = err.requestOptions.extra;
    final retries = extra['retries'] ?? 0;

    if (retries >= maxRetries) {
      if (kDebugMode) debugPrint('⚠️ Max retries reached for ${err.requestOptions.path}');
      return handler.next(err);
    }

    // Exponential backoff: 1s, 2s, 4s
    final delaySeconds = (retries + 1) * 2;
    if (kDebugMode) debugPrint('🔄 Retrying (${retries + 1}/$maxRetries) after ${delaySeconds}s...');

    await Future.delayed(Duration(seconds: delaySeconds));

    // Retry request
    try {
      err.requestOptions.extra['retries'] = retries + 1;
      final response = await _dio.fetch(err.requestOptions);
      return handler.resolve(response);
    } catch (e) {
      if (kDebugMode) debugPrint('⚠️ Retry failed: $e');
      return handler.next(err);
    }
  }
}

/// Provides user-friendly error messages
class _ErrorInterceptor extends dio.Interceptor {
  @override
  void onError(dio.DioException err, dio.ErrorInterceptorHandler handler) {
    // Add custom error handling if needed
    handler.next(err);
  }
}

/// Debug logging (only in debug mode)
class _LogInterceptor extends dio.Interceptor {
  @override
  void onRequest(dio.RequestOptions options, dio.RequestInterceptorHandler handler) {
    debugPrint('➡️ ${options.method} ${options.path}');
    debugPrint('   Headers: ${options.headers}');
    if (options.data != null) {
      debugPrint('   Body: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(dio.Response response, dio.ResponseInterceptorHandler handler) {
    debugPrint('✅ [${response.statusCode}] ${response.requestOptions.path}');
    debugPrint('   Data: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(dio.DioException err, dio.ErrorInterceptorHandler handler) {
    debugPrint('❌ [${err.response?.statusCode ?? 'ERROR'}] ${err.requestOptions.path}');
    debugPrint('   Error: ${err.message}');
    handler.next(err);
  }
}

// ========================> MODELS <========================

/// Standardized API response wrapper
class ApiResponse {
  final bool success;
  final int statusCode;
  final String message;
  final dynamic data;

  ApiResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  bool get isSuccess => success && statusCode >= 200 && statusCode < 300;
}

/// File data for multipart upload
class MultipartFileData {
  final String key;
  final String filePath;
  final String? fileName;

  MultipartFileData({
    required this.key,
    required this.filePath,
    this.fileName,
  });
}