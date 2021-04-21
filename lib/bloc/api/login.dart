import 'package:flutter/material.dart';
import 'package:neyasis_flutter_boilerplate/constants/http_call_type.dart';
import 'package:neyasis_flutter_boilerplate/constants/http_client_api_url.dart';
import 'package:neyasis_flutter_boilerplate/helpers/alerts.dart';
import 'package:neyasis_flutter_boilerplate/helpers/http_client.dart';
import 'package:neyasis_flutter_boilerplate/model/bloc/api/login/request.dart';
import 'package:neyasis_flutter_boilerplate/model/bloc/api/login/response.dart';
import 'package:neyasis_flutter_boilerplate/model/storage/user_information.dart';
import 'package:neyasis_flutter_boilerplate/repository/bloc.dart';
import 'package:neyasis_flutter_boilerplate/repository/http_response.dart';
import 'package:neyasis_flutter_boilerplate/storage/shared_preferances.dart';

class LoginBloc extends BlocRepository<LoginRequestBM, LoginResponseBM> {
  @override
  Future process(String lastRequestUniqueId) async {
    HttpResponseRepository<LoginResponseBM> responseRepository = await HttpClient.call<LoginResponseBM>(
      type: HttpCallType.post,
      apiUrl: HttpClientApiUrl.login,
      data: {
        "username": this.requestObject!.username,
        "password": this.requestObject!.password,
      },
      withAuth: false,
      fromJSON: (json) => LoginResponseBM.fromJSON(json),
    );
    if (responseRepository.hasError) {
      AppDialogs.showError(responseRepository.errorMessage);
      return this.fetcherSink(null, lastRequestUniqueId: lastRequestUniqueId);
    }
    await AppSharedPreferences.setUserInformation(UserInformation.fromLoginResponse(responseRepository.response!));
    this.fetcherSink(responseRepository.response, lastRequestUniqueId: null, forceSink: true);
  }
}

LoginBloc loginBloc = LoginBloc();
