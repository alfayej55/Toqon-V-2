//
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/foundation.dart' show kDebugMode;
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_connect/http/src/request/request.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
//
// import '../helpers/prefs_helpers.dart';
// import '../models/error_response.dart';
// import '../utils/app_constants.dart';
// import 'api_constants.dart';
//
// class ApiClient extends GetxService {
//   static final http.Client _client = http.Client();
//   static const String noInternetMessage = "No internet connection";
//   static const String timeoutMessage = "Request timed out";
//   static const String serverErrorMessage = "Server error, please try again";
//   static const int timeoutInSeconds = 30;
//
//   // ========================> GET <========================
//   static Future<Response> getData(
//       String uri, {
//         Map<String, dynamic>? query,
//         Map<String, String>? headers,
//       }) async {
//     final token = await _getBearerToken();
//     final mainHeaders = _getAuthHeaders(token);
//     try {
//       _logRequest('GET', uri, headers ?? mainHeaders);
//
//       final response = await _client
//           .get(
//         Uri.parse('${ApiConstants.baseUrl}$uri'),
//         headers: headers ?? mainHeaders,
//       ).timeout(Duration(seconds: timeoutInSeconds));
//       return _handleResponse(response, uri);
//     } on SocketException {
//       _logError('SocketException: No internet');
//       return Response(statusCode: -1, statusText: noInternetMessage);
//     } on TimeoutException {
//       _logError('TimeoutException');
//       return Response(statusCode: -2, statusText: timeoutMessage);
//     } catch (e, stackTrace) {
//       _logError('Unhandled error in GET $uri: $e\n$stackTrace');
//       return Response(
//         statusCode: 1,
//         statusText: e.toString(),
//         body: {'message': e.toString()},
//         bodyString: e.toString(),
//       );
//     }
//   }
//
//   // ========================> POST <========================
//   static Future<Response> postData(
//       String uri,
//       dynamic body, {
//         Map<String, String>? headers,
//       }) async {
//     final token = await _getBearerToken();
//     final mainHeaders = _getAuthHeaders(token);
//
//     try {
//       _logRequest('POST', uri, headers ?? mainHeaders, body: body);
//
//       final response = await _client.post(
//         Uri.parse('${ApiConstants.baseUrl}$uri'),
//         body: body,
//         headers: headers ?? mainHeaders,
//       ).timeout(Duration(seconds: timeoutInSeconds));
//       return _handleResponse(response, uri);
//     } on SocketException {
//       return Response(statusCode: -1, statusText: noInternetMessage);
//     } on TimeoutException {
//       return Response(statusCode: -2, statusText: timeoutMessage);
//     } catch (e, stackTrace) {
//       _logError('Unhandled error in GET $uri: $e\n$stackTrace');
//       return Response(
//         statusCode: 1,
//         statusText: e.toString(),
//         body: {'message': e.toString()},
//         bodyString: e.toString(),
//       );
//     }
//   }
//   // ========================> PATCH <========================
//   static Future<Response> patchData(
//       String uri,
//       dynamic body, {
//         Map<String, String>? headers,
//       }) async {
//     final token = await _getBearerToken();
//     final mainHeaders = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $token',
//     };
//
//     try {
//       _logRequest('PATCH', uri, headers ?? mainHeaders, body: body);
//       final response = await _client
//           .patch(
//         Uri.parse('${ApiConstants.baseUrl}$uri'),
//         body: jsonEncode(body),
//         headers: headers ?? mainHeaders,
//       ).timeout(Duration(seconds: timeoutInSeconds));
//
//       return _handleResponse(response, uri);
//     } on SocketException {
//       return Response(statusCode: -1, statusText: noInternetMessage);
//     } on TimeoutException {
//       return Response(statusCode: -2, statusText: timeoutMessage);
//     } catch (e, stackTrace) {
//       _logError('Unhandled error in GET $uri: $e\n$stackTrace');
//       return Response(
//         statusCode: 1,
//         statusText: e.toString(),
//         body: {'message': e.toString()},
//         bodyString: e.toString(),
//       );
//     }
//   }
//
//   // ========================> PUT <========================
//   static Future<Response> putData(
//       String uri,
//       dynamic body, {
//         Map<String, String>? headers,
//       }) async {
//     final token = await _getBearerToken();
//     final mainHeaders = _getAuthHeaders(token);
//     try {
//       _logRequest('PUT', uri, headers ?? mainHeaders, body: body);
//
//       final response = await _client
//           .put(
//         Uri.parse('${ApiConstants.baseUrl}$uri'),
//         body: body,
//         headers: headers ?? mainHeaders,
//       )
//           .timeout(Duration(seconds: timeoutInSeconds));
//       return _handleResponse(response, uri);
//     } on SocketException {
//       return Response(statusCode: -1, statusText: noInternetMessage);
//     } on TimeoutException {
//       return Response(statusCode: -2, statusText: timeoutMessage);
//     } catch (e, stackTrace) {
//       _logError('Unhandled error in GET $uri: $e\n$stackTrace');
//       return Response(
//         statusCode: 1,
//         statusText: e.toString(),
//         body: {'message': e.toString()},
//         bodyString: e.toString(),
//       );
//     }
//   }
//
//   // ========================> DELETE <========================
//   static Future<Response> deleteData(
//       String uri, {
//         Map<String, String>? headers,
//         dynamic body,
//       }) async {
//     final token = await _getBearerToken();
//     final mainHeaders = _getAuthHeaders(token);
//
//     try {
//       _logRequest('DELETE', uri, headers ?? mainHeaders, body: body);
//
//       final response = await _client
//           .delete(
//         Uri.parse('${ApiConstants.baseUrl}$uri'),
//         headers: headers ?? mainHeaders,
//         body: body is String ? body : (body != null ? jsonEncode(body) : null),
//       )
//           .timeout(Duration(seconds: timeoutInSeconds));
//
//       return _handleResponse(response, uri);
//     } on SocketException {
//       return Response(statusCode: -1, statusText: noInternetMessage);
//     } on TimeoutException {
//       return Response(statusCode: -2, statusText: timeoutMessage);
//     }catch (e, stackTrace) {
//       _logError('Unhandled error in GET $uri: $e\n$stackTrace');
//       return Response(
//         statusCode: 1,
//         statusText: e.toString(),
//         body: {'message': e.toString()},
//         bodyString: e.toString(),
//       );
//     }
//   }
//
//   // ========================> Multipart (POST) <========================
//   static Future<Response> postMultipartData(
//       String uri,
//       Map<String, String> fields, {
//         List<MultipartBody>? files,
//         Map<String, String>? headers,
//       }) async {
//     return _multipartRequest('POST', uri, fields, files, headers);
//   }
//
//   // ========================> Multipart (PUT) <========================
//   static Future<Response> putMultipartData(
//       String uri,
//       Map<String, String> fields, {
//         List<MultipartBody>? files,
//         Map<String, String>? headers,
//       }) async {
//
//     return _multipartRequest('PUT', uri, fields, files, headers);
//
//   }
//
//   // ========================> Multipart (PATCH) <========================
//   static Future<Response> patchMultipartData(
//       String uri,
//       Map<String, String> fields, {
//         List<MultipartBody>? files,
//         Map<String, String>? headers,
//       }) async {
//     return _multipartRequest('PATCH', uri, fields, files, headers);
//   }
//
//   // ========================> PRIVATE HELPERS <========================
//
//   static Future<String> _getBearerToken() async {
//     return await PrefsHelper.getString(AppConstants.bearerToken);
//   }
//
//   static Map<String, String> _getAuthHeaders(String token) {
//     return {
//       'Content-Type': 'application/x-www-form-urlencoded',
//       'Authorization': 'Bearer $token',
//     };
//   }
//
//   static void _logRequest(String method, String uri, Map<String, String> headers, {dynamic body}) {
//     if (kDebugMode) {
//       debugPrint('➡️ $method: $uri');
//       debugPrint('   Headers: $headers');
//       if (body != null) debugPrint('   Body: $body');
//     }
//   }
//
//   static void _logError(String msg) {
//     if (kDebugMode) debugPrint('❌ $msg');
//   }
//
//   static Response _handleResponse(http.Response response, String uri) {
//     String? decodedBody;
//     dynamic jsonBody;
//
//     // ✅ Safely decode JSON only if content-type says so
//     final contentType = response.headers['content-type']?.toLowerCase() ?? '';
//     if (contentType.contains('application/json') && response.body.isNotEmpty) {
//       try {
//         jsonBody = jsonDecode(response.body);
//         decodedBody = response.body;
//       } catch (e) {
//         _logError('JSON decode failed for $uri: $e');
//         jsonBody = {'error': 'Invalid server response'};
//       }
//     } else {
//       // Keep raw string for HTML/empty/plain text
//       decodedBody = response.body;
//     }
//
//     // ✅ Build base response
//     final request = response.request;
//     final baseResponse = Response(
//       body: jsonBody ?? decodedBody,
//       bodyString: response.body,
//       request: request != null
//           ? Request(
//         headers: request.headers,
//         method: request.method,
//         url: request.url,
//       )
//           : null,
//       headers: response.headers,
//       statusCode: response.statusCode,
//       statusText: response.reasonPhrase ?? 'Unknown',
//     );
//
//     // ✅ Handle non-2xx responses
//     if (response.statusCode < 200 || response.statusCode >= 300) {
//       String errorMsg = _extractErrorMessage(jsonBody, response.statusCode);
//
//       return Response(
//         statusCode: response.statusCode,
//         statusText: errorMsg,
//         body: jsonBody ?? decodedBody,
//         bodyString: response.body,
//         headers: response.headers,
//       );
//     }
//
//     _logResponse(uri, response.statusCode, jsonBody ?? decodedBody);
//     return baseResponse;
//   }
//
//   static String _extractErrorMessage(dynamic body, int statusCode) {
//     // Case 1: Valid JSON error
//     if (body is Map<String, dynamic>) {
//       try {
//         final error = ErrorResponse.fromJson(body);
//         return error.message ?? 'Server error';
//       } catch (_) {
//         // Fallback to common keys
//         return body['message']?.toString() ??
//             body['error']?.toString() ??
//             body['msg']?.toString() ??
//             'Request failed';
//       }
//     }
//
//     // Case 2: Non-JSON (e.g., HTML 502 page)
//     if (statusCode >= 500) return 'Server unavailable';
//     if (statusCode == 401) return 'Unauthorized';
//     if (statusCode == 403) return 'Access denied';
//     return 'Request failed';
//   }
//
//   static void _logResponse(String uri, int code, dynamic body) {
//     if (kDebugMode) {
//       debugPrint('✅ [$code] $uri\n${body is String ? body : jsonEncode(body)}');
//     }
//   }
//
//   // ========================> Multipart Helper <========================
//   static Future<Response> _multipartRequest(
//       String method,
//       String uri,
//       Map<String, String> fields,
//       List<MultipartBody>? files,
//       Map<String, String>? headers,
//       ) async {
//     final token = await _getBearerToken();
//     final request = http.MultipartRequest(method, Uri.parse('${ApiConstants.baseUrl}$uri'));
//     request.fields.addAll(fields);
//
//     // Add files (with crash protection)
//     if (files != null && files.isNotEmpty) {
//       for (var element in files) {
//         try {
//           final file = element.file;
//           final length = await file.length(); // async, safer than lengthSync()
//
//           MediaType? contentType;
//           final path = file.path.toLowerCase();
//
//           if (path.endsWith('.mp4')) {
//             contentType = MediaType('video', 'mp4');
//           } else if (path.endsWith('.png')) {
//             contentType = MediaType('image', 'png');
//           } else if (path.endsWith('.jpg') || path.endsWith('.jpeg')) {
//             contentType = MediaType('image', 'jpeg');
//           }
//
//           request.files.add(
//             http.MultipartFile(
//               element.key,
//               file.openRead(),
//               length,
//               filename: _getFileName(file.path),
//               contentType: contentType,
//             ),
//           );
//         } catch (e) {
//           _logError('Multipart file error: $e');
//           // Skip bad file, don’t crash entire request
//         }
//       }
//     }
//
//     request.headers.addAll(headers ?? {'Authorization': 'Bearer $token'});
//
//     try {
//       final streamedResponse = await request.send().timeout(Duration(seconds: timeoutInSeconds));
//       final responseBody = await streamedResponse.stream.bytesToString();
//
//       // Parse response
//       dynamic jsonBody;
//       try {
//         if (responseBody.isNotEmpty) jsonBody = jsonDecode(responseBody);
//       } catch (_) {}
//
//       return Response(
//         statusCode: streamedResponse.statusCode,
//         statusText: streamedResponse.reasonPhrase ?? 'Unknown',
//         body: jsonBody ?? responseBody,
//         bodyString: responseBody,
//       );
//     } on SocketException {
//       return Response(statusCode: -1, statusText: noInternetMessage);
//     } on TimeoutException {
//       return Response(statusCode: -2, statusText: timeoutMessage);
//     } catch (e) {
//       _logError('Multipart $method error $uri: $e');
//       return Response(statusCode: -3, statusText: 'Upload failed');
//     }
//   }
//
//   static String _getFileName(String path) {
//     return path.split('/').last;
//   }
// }
//
// // ✅ Keep your models (no change needed)
// class MultipartBody {
//   final String key;
//   final File file;
//   MultipartBody(this.key, this.file);
// }
//
// class MultipartListBody {
//   final String key;
//   final String value;
//   MultipartListBody(this.key, this.value);
// }