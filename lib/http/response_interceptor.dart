import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mikuinfo/utils/toast_utils.dart';

class ResponseInterceptor extends Interceptor {
  @override
  void onError (DioException err, ErrorInterceptorHandler handler) {
    String errorMessage = "请检查网络喵";
    if(err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      errorMessage = "连接超时，请检查网络连接喵";
    }else if (err.type == DioExceptionType.receiveTimeout) {
      errorMessage = "服务器响应超时，请稍后再试喵";
    }else if (err.response?.statusCode == 404) {
      errorMessage = "请求资源不存在喵";
    }else if (err.type == DioExceptionType.unknown) {
      errorMessage = "不知道发生什么错误啦，重试一下喵";
    }

    debugPrint(errorMessage);
    ToastUtils.showErrorMsg(errorMessage);

    //显示错误信息
    return handler.next(err);
  }
}