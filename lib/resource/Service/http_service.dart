import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ams/resource/Service/error_response.dart';
import 'package:ams/resource/Service/header_interceptor.dart';
import 'package:ams/resource/Service/logging_interceptor.dart';
import 'package:ams/resource/Service/network_error.dart';
import 'package:ams/resource/Service/request_error.dart';
import 'package:ams/resource/Service/unauthenticated_error_response.dart';
import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';

class HttpService {
  final Client _client = InterceptedClient.build(interceptors: [
    HeaderInterceptor(),
    LoggingInterceptor(),
  ]);

  final bool isHttps = true;
  final String _version = "/api";

  final String _baseUrl = 'zfzjhgyz6k.execute-api.us-east-1.amazonaws.com';

  static final HttpService _httpService = HttpService._constructor();

  factory HttpService() => _httpService;
  final String _networkErrorMsg = 'Please check your internet connection';

  HttpService._constructor();

  Future<dynamic> get(String path,
      {Map<String, String>? queryParams, Map<String, String>? headers}) async {
    debugPrint("Get request called");
    try {
      final response = await _client.get(
        _getUrl(path, queryParams),
        headers: headers,
      );

      if (response.statusCode == 200) {
        var decodedBody = jsonDecode(response.body);
        debugPrint("Response success : body type : ${decodedBody.runtimeType}");
        // Map<String, dynamic> map = jsonDecode(response.body);
        return decodedBody;
      } else {
        debugPrint("Error code : ${response.statusCode}");
        debugPrint("Error Body : ${response.body}");
        debugPrint("Error Body is Empty : ${response.body.isEmpty}");
        if (response.body.isEmpty) {
          throw ErrorResponse(
              status: response.statusCode,
              message: getErrorMessage(response.statusCode));
        } else {
          Map<String, dynamic> map = jsonDecode(response.body);

          if (response.statusCode == 401) {
            throw UnAuthenticatedErrorResponse.fromJson(map);
          } else {
            throw ErrorResponse.fromJson(map);
          }
        }
      }
    } on SocketException catch (e) {
      debugPrint("Socket exception $e");
      throw NetworkError(_networkErrorMsg);
    } on ErrorResponse catch (e) {
      debugPrint("on ErrorResponse catch $e");
      rethrow;
    } on UnAuthenticatedErrorResponse catch (e) {
      debugPrint("on UnAuthenticatedErrorResponse catch $e");
      rethrow;
    } catch (e) {
      debugPrint("on Catch $e");
      throw RequestError(handleError(e.toString()));
    }
  }

  Future<List<dynamic>> getList(String path,
      {Map<String, String>? queryParams, Map<String, String>? headers}) async {
    debugPrint("GetList request called");
    try {
      final response = await _client.get(
        _getUrl(path, queryParams),
        headers: headers,
      );

      if (response.statusCode == 200) {
        var decodedBody = jsonDecode(response.body);
        debugPrint("Response success : body type : ${decodedBody.runtimeType}");

        // Map<String, dynamic> map = jsonDecode(response.body);
        return decodedBody;
      } else {
        debugPrint("Error code : ${response.statusCode}");
        debugPrint("Error Body : ${response.body}");
        debugPrint("Error Body is Empty : ${response.body.isEmpty}");
        if (response.body.isEmpty) {
          throw ErrorResponse(
              status: response.statusCode,
              message: getErrorMessage(response.statusCode));
        } else {
          Map<String, dynamic> map = jsonDecode(response.body);
          throw ErrorResponse.fromJson(map);
        }
      }
    } on SocketException catch (e) {
      debugPrint("$e");
      throw NetworkError("Socket Exception");
    } on ErrorResponse catch (e) {
      debugPrint("on ErrorResponse catch $e");
      rethrow;
    } catch (e) {
      debugPrint("on Catch $e");
      throw RequestError(handleError(e.toString()));
    }
  }

  Future<Map<String, dynamic>> getListAsMap(String path,
      {Map<String, String>? queryParams, Map<String, String>? headers}) async {
    debugPrint("Get request called");
    try {
      final response = await _client.get(
        _getUrl(path, queryParams),
        headers: headers,
      );

      List<dynamic> listResponse = jsonDecode(response.body);

      Map<String, dynamic> map = {
        "first": true,
        "empty": true,
        "totalElements": 0,
        "totalPages": 0,
        "last": true,
        "size": 0,
        "number": 0,
        "numberOfElements": 0,
        "content": listResponse
      };

      if (response.statusCode == 200) {
        return map;
      } else {
        throw ErrorResponse.fromJson(map);
      }
    } on SocketException catch (e) {
      debugPrint("$e");
      throw NetworkError("Socket Exception");
    } on ErrorResponse catch (e) {
      debugPrint("on ErrorResponse catch $e");
      rethrow;
    } catch (e) {
      debugPrint("on Catch $e");
      throw RequestError(handleError(e.toString()));
    }
  }

  Future<dynamic> getObject(String path,
      {Map<String, String>? queryParams, Map<String, String>? headers}) async {
    debugPrint("Get request called");
    try {
      final response = await _client.get(
        _getUrl(path, queryParams),
        headers: headers,
      );

      dynamic listResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return listResponse;
      } else {
        throw ErrorResponse.fromJson({
          "error": "Bad Request",
          "message": "Bad Request",
          "status": response.statusCode
        });
      }
    } on SocketException catch (e) {
      debugPrint("$e");
      throw NetworkError("Socket Exception");
    } on ErrorResponse catch (e) {
      debugPrint("on ErrorResponse catch $e");
      rethrow;
    } catch (e) {
      debugPrint("on Catch $e");
      throw RequestError(handleError(e.toString()));
    }
  }

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    debugPrint("Post request called");
    try {
      final response = await _client.post(_getUrl(path, queryParams),
          headers: headers, body: body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        var decodedBody = jsonDecode(response.body);
        return decodedBody;
      } else {
        Map<String, dynamic> map = jsonDecode(response.body);
        throw ErrorResponse.fromJson(map);
      }
    } on SocketException catch (e) {
      debugPrint("$e");
      throw NetworkError("Socket Exception");
    } on ErrorResponse catch (e) {
      debugPrint("on ErrorResponse catch $e");
      rethrow;
    } catch (e) {
      debugPrint("on Catch $e");
      throw RequestError(handleError(e.toString()));
    }
  }

  Future<Map<String, dynamic>> postFormData(
      String path, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    debugPrint("Post request called");
    try {
      final response = await _client.post(
        _getUrl(path),
        headers: headers,
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        var decodedBody = jsonDecode(response.body);
        return decodedBody;
      } else {
        Map<String, dynamic> map = jsonDecode(response.body);
        throw ErrorResponse.fromJson(map);
      }
    } on SocketException catch (e) {
      debugPrint("$e");
      throw NetworkError("Socket Exception");
    } on ErrorResponse catch (e) {
      debugPrint("on ErrorResponse catch $e");
throw ErrorResponse(message:e.toString(), status: 500);
    } catch (e) {
      debugPrint("on Catch $e");
      throw RequestError(handleError(e.toString()));
    }
  }

  Future<Map<String, dynamic>> delete(String path,
      {Map<String, String>? headers}) async {
    debugPrint("Delete request called");
    try {
      final response = await _client.delete(_getUrl(path), headers: headers);

      if (response.statusCode == 200) {
        var decodedBody = jsonDecode(response.body);
        return decodedBody;
      } else {
        Map<String, dynamic> map = jsonDecode(response.body);
        throw ErrorResponse.fromJson(map);
      }
    } on SocketException catch (e) {
      debugPrint("$e");
      throw NetworkError("Socket Exception");
    } on ErrorResponse catch (e) {
      debugPrint("on ErrorResponse catch $e");
      rethrow;
    } catch (e) {
      debugPrint("on Catch $e");
      throw RequestError(handleError(e.toString()));
    }
  }

  Future<String> put(String path, String body,
      {Map<String, String>? headers}) async {
    debugPrint("Update request called");
    try {
      final response =
          await _client.put(_getUrl(path), headers: headers, body: body);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        Map<String, dynamic> map = jsonDecode(response.body);
        throw ErrorResponse.fromJson(map);
      }
    } on SocketException catch (e) {
      debugPrint("$e");
      throw NetworkError("Socket Exception");
    } on ErrorResponse catch (e) {
      debugPrint("on ErrorResponse catch $e");
      rethrow;
    } catch (e) {
      debugPrint("on Catch $e");
      throw RequestError(handleError(e.toString()));
    }
  }

  Future<String> patch(String path, {Map<String, String>? headers}) async {
    debugPrint("Patch request called");
    try {
      final response = await _client.patch(_getUrl(path), headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        Map<String, dynamic> map = jsonDecode(response.body);
        throw ErrorResponse.fromJson(map);
      }
    } on SocketException catch (e) {
      debugPrint("$e");
      throw NetworkError("Socket Exception");
    } on ErrorResponse catch (e) {
      debugPrint("on ErrorResponse catch $e");
      rethrow;
    } catch (e) {
      debugPrint("on Catch $e");
      throw RequestError(handleError(e.toString()));
    }
  }

  // Future<HttpClientResponse> uploadWithSync(XFile xFile, String uploadUrl,
  //     StreamTransformer<Uint8List, List<int>> streamTransformer,
  //     {Map<String, String>? headers}) async {
  //   debugPrint("uploadWithSync request called");

  //   try {
  //     HttpClient client = HttpClient();
  //     final stream = xFile.openRead();
  //     int length = await xFile.length();
  //     final request = await client.putUrl(Uri.parse(uploadUrl));
  //     request.contentLength = length;
  //     Stream<List<int>> progressStream = stream.transform(
  //       streamTransformer,
  //     );
  //     await request.addStream(progressStream);
  //     final closedResponse = await request.close();
  //     return closedResponse;
  //   } on SocketException catch (e) {
  //     debugPrint("$e");
  //     throw NetworkError("Socket Exception");
  //   } on ErrorResponse catch (e) {
  //     debugPrint("on ErrorResponse catch $e");
  //     rethrow;
  //   } catch (e) {
  //     debugPrint("on Catch $e");
  //     throw RequestError(e.toString());
  //   }
  // }

  // Future<ApiResponse<String>> uploadWithSyncV2(XFile xFile, String uploadUrl,
  //     {Map<String, String>? headers}) async {
  //   debugPrint("uploadWithSyncV2 request called");
  //   try {
  //     int length = await xFile.length();
  //     var putUri = Uri.parse(uploadUrl);
  //     var request = Request("PUT", putUri);
  //     Uint8List bytes = await xFile.readAsBytes();
  //     request.bodyBytes = bytes;

  //     var response = await request.send();

  //     debugPrint("after response call");
  //     if (response.statusCode == 200) {
  //       return ApiResponse.success("Success");
  //     } else {
  //       return ApiResponse.error(response.statusCode, "Status not ok");
  //     }
  //   } on SocketException catch (e) {
  //     debugPrint("$e");
  //     return ApiResponse.error(0, "Socket Exception");
  //   } on ErrorResponse catch (e) {
  //     debugPrint("on ErrorResponse catch $e");
  //     return ApiResponse.error(0, "ErrorResponse catch $e");
  //   } catch (e) {
  //     debugPrint("on Catch $e");
  //     return ApiResponse.error(0, "Request error $e");
  //   }
  // }

  Uri _getUrl(String path, [Map<String, String>? queryParameters]) {
    if (isHttps) {
      return Uri.https(_baseUrl, _getPath(path), queryParameters);
    } else {
      return Uri.http(_baseUrl, _getPath(path), queryParameters);
    }
  }

  String _getPath(String path) {
    return '$_version$path';
  }

  String getErrorMessage(int code) {
    switch (code) {
      case 403:
        {
          return "Unauthorized to access the api";
        }
      default:
        {
          return "Error message unknown check the code";
        }
    }
  }

  String handleError(String error) {
    if (error.contains('Operation timed out')) return _networkErrorMsg;
    if (error.contains('No route to host')) return _networkErrorMsg;
    if (error.contains('ClientException')) {
      return 'Your network connection is unstable. Please try again.';
    }
    return error;
  }
}
