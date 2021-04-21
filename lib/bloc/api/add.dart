import 'package:flutter/material.dart';
import 'package:neyasis_flutter_boilerplate/bloc/api/list.dart';
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

class AddBloc extends BlocRepository<String, Null> {
  @override
  Future process(String lastRequestUniqueId) async {
    HttpResponseRepository<dynamic> responseRepository = await HttpClient.call<dynamic>(
      type: HttpCallType.post,
      apiUrl: HttpClientApiUrl.data,
      data: {"name": this.requestObject!},
      withAuth: false,
      dynamicResponse: true,
    );
    await Future.delayed(Duration(seconds: 1));
    if (responseRepository.hasError) {
      AppDialogs.showError(responseRepository.errorMessage);
      return this.fetcherSink(null, lastRequestUniqueId: lastRequestUniqueId);
    }
    listBloc.call(sinkNullObject: true);
    this.fetcherSink(null, lastRequestUniqueId: lastRequestUniqueId);
  }
}

AddBloc addBloc = AddBloc();
