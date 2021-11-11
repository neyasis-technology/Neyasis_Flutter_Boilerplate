import '../../constants/http_call_type.dart';
import '../../constants/http_client_api_url.dart';
import '../../helpers/alerts.dart';
import '../../helpers/http_client.dart';
import '../../model/bloc/api/login/request.dart';
import '../../model/bloc/api/login/response.dart';
import '../../model/storage/user_information.dart';
import '../../repository/bloc.dart';
import '../../repository/http_response.dart';
import '../../storage/shared_preferances.dart';

class LoginBloc extends BlocRepository<LoginRequestBM, LoginResponseBM> {
  @override
  Future process(String lastRequestUniqueId) async {
    HttpResponseRepository<LoginResponseBM> responseRepository =
        await HttpClient.call<LoginResponseBM>(
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
    await AppSharedPreferences.setUserInformation(
        UserInformation.fromLoginResponse(responseRepository.response!));
    this.fetcherSink(responseRepository.response,
        lastRequestUniqueId: null, forceSink: true);
  }
}

LoginBloc loginBloc = LoginBloc();
