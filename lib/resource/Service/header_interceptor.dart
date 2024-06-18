import 'dart:io';

import 'package:http_interceptor/http_interceptor.dart';

class HeaderInterceptor implements InterceptorContract {

  @override
  Future<bool> shouldInterceptRequest() async {
    return true;
  }

  @override
  Future<bool> shouldInterceptResponse() async {
    return false;
  }

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    try {
      if(!request.headers.containsKey(HttpHeaders.contentTypeHeader)){
        request.headers[HttpHeaders.contentTypeHeader] = "application/json";
      }
     // request.headers[HttpHeaders.authorizationHeader]= 'Bearer $token';

     // request.headers['project'] = _project;
     // request.headers['app-version'] = _appVersion;
    } catch (e) {
      print(e);
    }
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse(
      {required BaseResponse response}) async {
    return response;
  }
}
