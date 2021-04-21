class LoginResponseBM {
  final String token;
  final String refreshToken;

  LoginResponseBM({required this.token, required this.refreshToken});

  factory LoginResponseBM.fromJSON(dynamic response) {
    return LoginResponseBM(
      refreshToken: response["refreshToken"],
      token: response["token"],
    );
  }
}
