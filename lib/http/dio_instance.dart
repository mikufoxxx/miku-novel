import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
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
      sendTimeout: sendTimeout ?? _defaultTimeout,
      responseType: responseType,
      contentType: contentType,
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
        'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8',
        'Accept-Encoding': 'gzip, deflate, br',
        'Cache-Control': 'max-age=2592000',
        'DNT': '1',
        'Connection': 'keep-alive',
        'Upgrade-Insecure-Requests': '1',
        'Referer': 'https://www.wenkuchina.com/',
        'Sec-Ch-Ua': '"Chromium";v="140", "Not=A?Brand";v="24", "Microsoft Edge";v="140"',
        'Sec-Ch-Ua-Mobile': '?0',
        'Sec-Ch-Ua-Platform': '"Windows"',
      },
    );
    // 配置HTTPS证书验证（用于处理某些网站的SSL问题）
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    _dio.interceptors.add(ResponseInterceptor());
    _dio.interceptors.add(PrintLogInterceptor());
  }

  //get 获取json数据
  Future<Response> get(
      {required String path,
      Object? data,
      Options? options,
      Map<String, dynamic>? param,
      CancelToken? cancelToken,
      void Function(int, int)? onReceiveProgress}) async {
    return _dio.get(
      path,
      queryParameters: param,
      cancelToken: cancelToken,
      data: data,
      options: options ??
          Options(
            method: HttpMethods.get,
            receiveTimeout: _defaultTimeout,
            sendTimeout: _defaultTimeout,
          ),
    );
  }

  //getString 获取html数据
  Future<String> getString(
      {required String path,
      Object? data,
      Options? options,
      Map<String, dynamic>? param,
      CancelToken? cancelToken,
      void Function(int, int)? onReceiveProgress}) async {
    Response res = await _dio.get(
      path,
      queryParameters: param,
      cancelToken: cancelToken,
      data: data,
      options: options ??
          Options(
            method: HttpMethods.get,
            receiveTimeout: _defaultTimeout,
            sendTimeout: _defaultTimeout,
          ),
    );
    return res.data.toString();
  }

  //post 请求
  Future<Response> post(
      {required String path,
      Object? data,
      Options? options,
      Map<String, dynamic>? param,
      CancelToken? cancelToken,
      void Function(int, int)? onReceiveProgress}) async {
    return _dio.post(
      path,
      queryParameters: param,
      cancelToken: cancelToken,
      data: data,
      options: options ??
          Options(
            method: HttpMethods.post,
            receiveTimeout: _defaultTimeout,
            sendTimeout: _defaultTimeout,
          ),
    );
  }
}
