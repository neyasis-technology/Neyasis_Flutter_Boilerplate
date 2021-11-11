import '../../constants/http_call_type.dart';
import '../../constants/http_client_api_url.dart';
import '../../helpers/alerts.dart';
import '../../helpers/http_client.dart';
import '../../repository/bloc.dart';
import '../../repository/http_response.dart';
import 'list.dart';

class AddBloc extends BlocRepository<String, Null> {
  @override
  Future process(String lastRequestUniqueId) async {
    HttpResponseRepository<dynamic> responseRepository =
        await HttpClient.call<dynamic>(
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
