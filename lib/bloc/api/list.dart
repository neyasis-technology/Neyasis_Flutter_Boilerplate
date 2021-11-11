import '../../constants/http_call_type.dart';
import '../../constants/http_client_api_url.dart';
import '../../helpers/alerts.dart';
import '../../helpers/http_client.dart';
import '../../model/bloc/api/data/response.dart';
import '../../repository/bloc.dart';
import '../../repository/http_response.dart';

class ListBloc extends BlocRepository<Null, List<DataResponseBM>> {
  @override
  Future process(String lastRequestUniqueId) async {
    HttpResponseRepository<List<DataResponseBM>> responseRepository =
        await HttpClient.call<List<DataResponseBM>>(
      type: HttpCallType.get,
      apiUrl: HttpClientApiUrl.data,
      withAuth: false,
      fromJSON: (list) => list
          .map((element) => DataResponseBM.fromJSON(element))
          .toList()
          .cast<DataResponseBM>(),
    );
    if (responseRepository.hasError) {
      AppDialogs.showError(responseRepository.errorMessage);
      return this.fetcherSink(null, lastRequestUniqueId: lastRequestUniqueId);
    }
    this.fetcherSink(responseRepository.response,
        lastRequestUniqueId: null, forceSink: true);
  }
}

ListBloc listBloc = ListBloc();
