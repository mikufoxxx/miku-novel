import 'package:dio/dio.dart';
import 'package:mikuinfo/http/http_methods.dart';
import 'package:mikuinfo/http/print_log_interceptor.dart';
import 'package:mikuinfo/http/response_interceptor.dart';

class DioInstance {
  static DioInstance? _instance;

  DioInstance._();

  static DioInstance instance() {
    return _instance ??= DioInstance._();
  }

  final Dio _dio = Dio();
  final _defaultTimeout = const Duration(seconds: 30);

  void initDio({
    String? httpMethod = HttpMethods.get,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    ResponseType? responseType = ResponseType.json,
    String? contentType,

}) {
    _dio.options = BaseOptions(
      method: httpMethod,
      connectTimeout: connectTimeout ?? _defaultTimeout,
      receiveTimeout: receiveTimeout ?? _defaultTimeout,
      sendTimeout: sendTimeout?? _defaultTimeout,
      responseType: responseType,
      contentType: contentType,
    );
    _dio.interceptors.add(ResponseInterceptor());
    _dio.interceptors.add(PrintLogInterceptor());
  }

  //get 获取json数据
  Future<Response> get({
    required String path,
    Object? data,
    Options? options,
    Map<String, dynamic>? param,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress
  }) async {
    return _dio.get(path,
      queryParameters: param,
      cancelToken: cancelToken,
      data: data,
      options: options ?? Options(
        method: HttpMethods.get,
        receiveTimeout: _defaultTimeout,
        sendTimeout: _defaultTimeout,
      ),
    );
  }

  //getString 获取html数据
  Future<String> getString({
    required String path,
    Object? data,
    Options? options,
    Map<String, dynamic>? param,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress
  }) async {
    Response res = await _dio.get(path,
      queryParameters: param,
      cancelToken: cancelToken,
      data: data,
      options: options ?? Options(
        method: HttpMethods.get,
        receiveTimeout: _defaultTimeout,
        sendTimeout: _defaultTimeout,
      ),
    );
    return res.data.toString();
  }

  //post 请求
  Future<Response> post({
    required String path,
    Object? data,
    Options? options,
    Map<String, dynamic>? param,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress
  }) async {
    return _dio.post(path,
      queryParameters: param,
      cancelToken: cancelToken,
      data: data,
      options: options ?? Options(
        method: HttpMethods.post,
        receiveTimeout: _defaultTimeout,
        sendTimeout: _defaultTimeout,
      ),
    );
  }

}