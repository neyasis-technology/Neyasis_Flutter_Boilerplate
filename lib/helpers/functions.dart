import 'dart:convert';

class AppFunctions {
  static List<List<T>> partitationArray<T>(List<T> valuesList, int size) {
    List<List<T>> valuesListPartitation = [];
    var len = valuesList.length;
    for (var i = 0; i < len; i += size) {
      var end = (i + size < len) ? i + size : len;
      valuesListPartitation.add(valuesList.sublist(i, end));
    }
    return valuesListPartitation;
  }

  static Map<String, dynamic> jwtParser(String token) {
    final parts = token.split('.');
    if (parts.length != 3) throw Exception('invalid token');
    String output = parts[1].replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }
    final payload = utf8.decode(base64Url.decode(output));
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }
    return payloadMap;
  }
}
