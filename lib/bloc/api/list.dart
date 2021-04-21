import 'package:flutter/material.dart';
import 'package:neyasis_flutter_boilerplate/constants/http_call_type.dart';
import 'package:neyasis_flutter_boilerplate/constants/http_client_api_url.dart';
import 'package:neyasis_flutter_boilerplate/helpers/alerts.dart';
import 'package:neyasis_flutter_boilerplate/helpers/http_client.dart';
import 'package:neyasis_flutter_boilerplate/model/bloc/api/data/response.dart';
import 'package:neyasis_flutter_boilerplate/model/bloc/api/login/request.dart';
import 'package:neyasis_flutter_boilerplate/model/bloc/api/login/response.dart';
import 'package:neyasis_flutter_boilerplate/model/storage/user_information.dart';
import 'package:neyasis_flutter_boilerplate/repository/bloc.dart';
import 'package:neyasis_flutter_boilerplate/repository/http_response.dart';
import 'package:neyasis_flutter_boilerplate/storage/shared_preferances.dart';

class ListBloc extends BlocRepository<Null, List<DataResponseBM>> {
  @override
  Future process(String lastRequestUniqueId) async {
    HttpResponseRepository<List<DataResponseBM>> responseRepository = await HttpClient.call<List<DataResponseBM>>(
      type: HttpCallType.get,
      apiUrl: HttpClientApiUrl.data,
      withAuth: false,
      fromJSON: (list) => list.map((element) => DataResponseBM.fromJSON(element)).toList().cast<DataResponseBM>(),
    );
    if (responseRepository.hasError) {
      AppDialogs.showError(responseRepository.errorMessage);
      return this.fetcherSink(null, lastRequestUniqueId: lastRequestUniqueId);
    }
    this.fetcherSink(responseRepository.response, lastRequestUniqueId: null, forceSink: true);
  }
}

ListBloc listBloc = ListBloc();
