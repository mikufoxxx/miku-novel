import 'package:dio/dio.dart';
import 'package:mikuinfo/utils/log_utils.dart';

class PrintLogInterceptor extends InterceptorsWrapper {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    //打印请求信息，方便调试
    LogUtils.println("\nonRequest------------->");
    options.headers.forEach((key, value){
      LogUtils.println("headers: key=$key  value=${value.toString()}");
    });
    LogUtils.println("path: ${options.uri}");
    LogUtils.println("method: ${options.method}");
    LogUtils.println("data: ${options.data}");
    LogUtils.println("para: ${options.queryParameters.toString()}");
    LogUtils.println("<------------onRequest\n");
    super.onRequest(options, handler);
  }
}