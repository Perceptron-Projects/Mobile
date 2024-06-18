import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http_interceptor/http_interceptor.dart';

class LoggingInterceptor implements InterceptorContract {


  @override
  Future<bool> shouldInterceptRequest() async {
   if(kDebugMode) return true;
   return false;
  }

  @override
  Future<bool> shouldInterceptResponse() async {
    if(kDebugMode) return true;
    return false;
  }

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    debugPrint('Request : ---->\n${request.toString()}');
    debugPrint('Request Data: ---->\n${request.url.data}');
    debugPrint('Request Header -----> \n${request.headers.toString()}');
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({required BaseResponse response}) async {
    log('Response Status --------> ${response.statusCode}');
    debugPrint('Response Url : ---->\n${response.request.toString()}');
    if(response is Response){
      log('Response body : ---->\n${response.body.toString()}');
    }
   return response;
  }
}
