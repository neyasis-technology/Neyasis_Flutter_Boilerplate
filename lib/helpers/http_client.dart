import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constants/app.dart';
import '../constants/app_mode.dart';
import '../constants/http_call_type.dart';
import '../constants/http_client_api_url.dart';
import '../model/storage/user_information.dart';
import '../repository/http_response.dart';
import '../storage/shared_preferances.dart';
import 'alerts.dart';

class HttpClient {
  static bool _blockLogging = false;

  static HttpResponseRepository<T> _errorModel<T>() =>
      HttpResponseRepository<T>(
        response: null,
        hasError: true,
        errorMessage: "Üzgünüz, bir sorun oluştu.",
        statusCode: -1,
        errorCode: "",
      );

  static Future<Map<String, String>> generateHeaders(
      {required bool withAuth, int? page, int? pageSize}) async {
    Map<String, String> headers = {
      "X-Version-Code": "${Application.versionCode}",
      "X-Version-Name": "${Application.versionName}",
      "X-Page-Size": "${pageSize ?? 1000}",
      "X-Page": "${page ?? 1}",
    };

    if (withAuth) {
      UserInformation? userInformation =
          await AppSharedPreferences.getUserInformation();
      if (userInformation == null)
        throw ("Please set your user information object");
      headers.addAll({"Authorization": "Bearer ${userInformation.token}"});
    }
    return headers;
  }

  /*
  Http Error error codes 400
   */

  static Future<Response> _get({
    required Map<String, String> headers,
    required String url,
    CancelToken? cancelToken,
  }) async {
    return await Dio().get(
      url,
      options: Options(headers: headers),
      cancelToken: cancelToken,
    );
  }

  static Future<Response> _post({
    required Map<String, String> headers,
    required String url,
    required dynamic data,
    CancelToken? cancelToken,
  }) async {
    return await Dio().post(
      url,
      options: Options(headers: headers),
      cancelToken: cancelToken,
      data: data,
    );
  }

  static Future<Response> _delete({
    required Map<String, String> headers,
    required String url,
    required dynamic data,
    CancelToken? cancelToken,
  }) async {
    return await Dio().delete(
      url,
      options: Options(headers: headers),
      cancelToken: cancelToken,
      data: data,
    );
  }

  static Future<Response> _patch({
    required Map<String, String> headers,
    required String url,
    required dynamic data,
    CancelToken? cancelToken,
  }) async {
    return await Dio().patch(
      url,
      options: Options(headers: headers),
      cancelToken: cancelToken,
      data: data,
    );
  }

  static _printError(apiUrl, headers, data, DioError dioError) {
    if (Application.appMode == AppMode.production || _blockLogging) return;
    debugPrint("""
====================ERROR REQUEST====================
URL: $apiUrl
HEADERS: $headers
REQUEST-DATA: ${jsonEncode(data)}
RESPONSE-ERROR: $dioError
RESPONSE-DATA: ${dioError.response}
=======================================================
      """, wrapWidth: 1024);
  }

  static _printSuccess(apiUrl, headers, data, Response dioResponse) {
    if (Application.appMode == AppMode.production || _blockLogging) return;
    debugPrint("""
====================SUCCESS REQUEST====================
URL: $apiUrl
HEADERS: $headers
REQUEST-DATA: ${jsonEncode(data)}
RESPONSE: ${dioResponse.data}
=======================================================
      """, wrapWidth: 1024);
  }

  static Future<bool> _refreshToken() async {
    UserInformation? userInformation =
        await AppSharedPreferences.getUserInformation();
    if (userInformation == null) return false;
    HttpResponseRepository<dynamic> responseRepository =
        await HttpClient.call<dynamic>(
      type: HttpCallType.get,
      apiUrl: HttpClientApiUrl.refreshToken,
      withAuth: false,
      data: {
        "AccessToken": userInformation.token,
        "RefreshToken": userInformation.refreshToken
      },
      dynamicResponse: true,
    );
    if (responseRepository.hasError) {
      AppDialogs.showError(tr("global.authenticationFailed"), onPress: () {
        // ignore: todo
        //TODO::You should navigate login screen on this code block
        // Navigator.of(Application.context).pushAndRemoveUntil(
        //   MaterialPageRoute(builder: (_) => LoginScreen()),
        //       (route) => false,
        // );
      });
      return false;
    }
    // ignore: todo
    //TODO::You should change this code block if your refresh token body is different
    await AppSharedPreferences.setUserInformation(
        UserInformation.fromLoginResponse(responseRepository.response));
    return true;
  }

  static Future<HttpResponseRepository<T>> call<T>({
    required HttpCallType type,
    T Function(dynamic)? fromJSON,
    String? apiUrlString,
    HttpClientApiUrl? apiUrl,
    dynamic data,
    int? page,
    int? pageSize,
    bool dynamicResponse = false,
    bool withAuth = true,
    CancelToken? cancelToken,
  }) async {
    if (fromJSON == null && dynamicResponse == false)
      throw ("Please set fromJSON response");
    // ignore: unnecessary_null_comparison
    if (type == null) throw ("Please set HttpCallType");
    Map<String, String> headers = await generateHeaders(
        withAuth: withAuth, page: page, pageSize: pageSize);
    late Response dioResponse;
    String url = apiUrlString ?? apiUrl!.uri;
    String queryString = "";
    try {
      if (type == HttpCallType.get) {
        if (data != null) {
          queryString = _getQueryString(data);
          queryString = queryString.substring(1, queryString.length);
        }
        url = "$url?$queryString";
        dioResponse = await _get(
          url: url,
          cancelToken: cancelToken,
          headers: headers,
        );
      } else if (type == HttpCallType.patch) {
        dioResponse = await _patch(
          data: data,
          url: url,
          cancelToken: cancelToken,
          headers: headers,
        );
      } else if (type == HttpCallType.post) {
        dioResponse = await _post(
          data: data,
          url: url,
          cancelToken: cancelToken,
          headers: headers,
        );
      } else if (type == HttpCallType.delete) {
        dioResponse = await _delete(
          data: data,
          url: url,
          cancelToken: cancelToken,
          headers: headers,
        );
      }
      _printSuccess(url, headers, data, dioResponse);
      return HttpResponseRepository(
        response:
            dynamicResponse ? dioResponse.data : fromJSON!(dioResponse.data),
      );
    } on DioError catch (dioError) {
      _printError(url, headers, data, dioError);
      if (dioError.response!.statusCode == 401) {
        bool reCall = await _refreshToken();
        if (reCall) {
          return await call<T>(
            type: type,
            fromJSON: fromJSON,
            apiUrlString: apiUrlString,
            apiUrl: apiUrl,
            data: data,
            dynamicResponse: dynamicResponse,
            withAuth: withAuth,
            cancelToken: cancelToken,
          );
        }
        return _errorModel<T>();
      }
      if (dioError.response!.statusCode == 500) {
        return _errorModel<T>();
      }
      try {
        if (dioError.response!.data["error_message"] == null &&
            dioError.response!.data["statusMessage"] == null)
          return _errorModel<T>();
        return HttpResponseRepository(
          response: null,
          hasError: true,
          errorMessage: dioError.response!.data["error_message"] ??
              dioError.response!.data["statusMessage"],
          statusCode: dioError.response!.data["status_code"] ??
              dioError.response!.data["statusCode"],
          errorCode: dioError.response!.data["error_code"] ??
              dioError.response!.data["errorCode"],
        );
      } catch (err) {
        return _errorModel<T>();
      }
    } catch (err) {
      // print(err);
      return _errorModel<T>();
    }
  }

  static String _getQueryString(Map params,
      {String prefix: '&', bool inRecursion: false}) {
    String query = '';
    params.forEach((key, value) {
      if (inRecursion) {
        key = '[$key]';
      }
      if (value is List) {
        value.forEach((element) {
          query += '$prefix$key=${Uri.encodeComponent("$element")}';
        });
      } else if (value is String ||
          value is int ||
          value is double ||
          value is bool) {
        query += '$prefix$key=${Uri.encodeComponent(value)}';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query +=
              _getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
        });
      }
    });
    return query;
  }
}
