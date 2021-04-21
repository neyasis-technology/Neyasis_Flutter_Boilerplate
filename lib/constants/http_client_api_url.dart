import 'package:neyasis_flutter_boilerplate/constants/app.dart';

enum HttpClientApiUrl {
  login,
  refreshToken,
  data
}

extension HttpClientApiUrlExtension on HttpClientApiUrl {
  String get uri {
    switch (this) {
      case HttpClientApiUrl.data:
        return "${Application.apiBaseUrl}/data";
      case HttpClientApiUrl.login:
        return "${Application.apiBaseUrl}/login";
      case HttpClientApiUrl.refreshToken:
        //TODO::You should set refresh token url.
        return "${Application.apiBaseUrl}/__REFRESH_TOKEN_URL_NULL__";
      default:
        return '';
    }
  }
}
