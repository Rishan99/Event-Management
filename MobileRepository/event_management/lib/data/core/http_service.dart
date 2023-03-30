import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:event_management/core/api_url/api_url.dart';
import 'package:event_management/core/route/route.dart';
import 'package:event_management/core/utils/ui_helper.dart';
import 'package:event_management/core/utils/utils.dart';
import 'package:event_management/data/core/error_handler.dart';
import 'package:event_management/data/data.dart';
import 'package:event_management/services/service.dart';
import 'package:flutter/material.dart';

class HttpService {
  static BuildContext? context;

  final PreferenceService preferenceService;

  HttpService(this.preferenceService);

  final Dio _dio = Dio()
    ..interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        String headers = "";
        options.headers.forEach((key, value) {
          headers += "| $key: $value";
        });
        debugPrint('--------------------------------');
        debugPrint('Request Path ${options.path}');
        debugPrint('''[DIO] Request: ${options.method} ${options.uri.toString()}
        Options: ${(options.data is FormData) ? (options.data as FormData).fields : options.data}
        Headers:\n$headers''');
        debugPrint('--------------------------------');
        handler.next(options);
      },
      onError: (e, handler) {
        debugPrint('--------------------------------');
        debugPrint('Request Path ${e.requestOptions.path}');
        debugPrint("[DIO] Response [code ${e.response?.statusCode}]");
        debugPrint('--------------------------------');
        debugPrint((e.response?.data ?? e.message).toString());
        debugPrint('--------------------------------');
        if (e.response?.statusCode == 401) {
          _logoutUser();
          handler.resolve(e.response!);
        } else {
          handler.next(e);
        }
      },
      onResponse: (response, handler) {
        debugPrint('--------------------------------');
        debugPrint('Request Path ${response.requestOptions.path}');
        debugPrint("[DIO] Response [code ${response.statusCode}]");
        debugPrint('--------------------------------');
        debugPrint(response.data.toString());
        debugPrint('--------------------------------');
        if (response.statusCode == 401) {
          _logoutUser();
        }
        return handler.next(response);
      },
    ));

  init(BuildContext context1) {
    context = context1;
  }

  static _logoutUser() async {
    failureSnackBar(
      "Session Expired, Please Login",
    );

    locator<PreferenceService>().clearSession();
    // Navigator.of(context!).pushNamed(Routes.splashPage);
    Navigator.of(context!).pushNamedAndRemoveUntil(Routes.authenticationPage, (route) => false);
  }

  ///GET Request without Authentication header
  Future<dynamic> getRequestWithoutAuth(String url, {dynamic data}) async {
    _dio.options = BaseOptions(baseUrl: ApiUrl.baseUrl);
    late Response response;
    try {
      response = await _dio.get(ApiUrl.baseUrl + url, queryParameters: data);
    } catch (e) {
      ErrorHandler.handleDioError(e);
    }
    if (response.statusCode != 200) {
      throw (response.data.toString());
    }
    return response.data;
  }

  ///POST Request without Authentication header
  Future<dynamic> postRequestWithoutAuth(String url, {dynamic data}) async {
    _dio.options = BaseOptions(baseUrl: ApiUrl.baseUrl);
    late Response response;
    try {
      response = await _dio.post(ApiUrl.baseUrl + url, data: data);
    } catch (e) {
      ErrorHandler.handleDioError(e);
    }
    if (response.statusCode != 200) {
      throw (response.data.toString());
    }
    return response.data;
  }

  ///GET Request with Authentication header
  Future<dynamic> getData(String url, {Map<String, dynamic>? data}) async {
    String token = preferenceService.accessToken;

    _dio.options = BaseOptions(baseUrl: ApiUrl.baseUrl, headers: {'Authorization': 'Bearer $token'});
    late Response response;
    try {
      response = await _dio.get(ApiUrl.baseUrl + url, queryParameters: data);
    } catch (e) {
      ErrorHandler.handleDioError(e);
    }
    if (response.statusCode != 200) {
      throw (response.data.toString());
    }
    return response.data;
  }

  ///POST Request with UrlEncoded type
  Future<dynamic> postDataUrlEncoded(String url, {dynamic data}) async {
    String token = preferenceService.accessToken;
    _dio.options = BaseOptions(baseUrl: ApiUrl.baseUrl, headers: {'Authorization': 'Bearer $token'}, contentType: 'application/x-www-form-urlencoded');
    late Response response;
    try {
      response = await _dio.post(ApiUrl.baseUrl + url, data: data);
    } catch (e) {
      ErrorHandler.handleDioError(e);
    }
    if (response.statusCode != 200) {
      throw (response.data.toString());
    }
    return response.data;
  }

  ///POST Request with JSON Content-Type
  Future<dynamic> postDataJson(String url, {dynamic data}) async {
    String token = preferenceService.accessToken;
    _dio.options = BaseOptions(baseUrl: ApiUrl.baseUrl, headers: {'Authorization': 'Bearer $token'}, contentType: 'application/json');
    late Response response;
    try {
      response = await _dio.post(
        ApiUrl.baseUrl + url,
        data: jsonEncode(data),
      );
    } catch (e) {
      ErrorHandler.handleDioError(e);
    }
    if (response.statusCode != 200) {
      throw (response.data.toString());
    }
    return response.data;
  }

  ///POST Request with Multipart-Form Data Content-Type
  Future<dynamic> postDataFormData(String url, {required dynamic data}) async {
    String token = preferenceService.accessToken;
    _dio.options = BaseOptions(
      baseUrl: ApiUrl.baseUrl,
      headers: {'Authorization': 'Bearer $token'},
      contentType: 'multipart/form-data',
    );
    late Response response;
    try {
      response = await _dio.post(ApiUrl.baseUrl + url, data: FormData.fromMap(data));
    } catch (e) {
      ErrorHandler.handleDioError(e);
    }
    if (response.statusCode != 200) {
      throw (response.data.toString());
    }
    return response.data;
  }

  ///Download File
  Future<String> downloadFile(String url, String savePath) async {
    String token = preferenceService.accessToken;
    _dio.options = BaseOptions(
      baseUrl: ApiUrl.baseUrl,
      headers: {
        'Authorization': 'Bearer $token',
        "Connection": "Keep-Alive",
        "Keep-Alive": "timeout=50, max=1000",
      },
    );
    late Response response;
    try {
      response = await _dio
          .download(
            url,
            savePath,
            deleteOnError: true,
          )
          .timeout(const Duration(days: 3));
    } catch (e) {
      ErrorHandler.handleDioError(e);
    }
    if (response.statusCode != 200) {
      throw (response.data.toString());
    }
    return savePath;
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = ((X509Certificate cert, String host, int port) {
        return true;
      });
  }
}
