import 'package:neyasis_flutter_boilerplate/repository/bloc.dart';

class CounterBloc extends BlocRepository<int, int> {
  int _counter = 0;
  // ignore: unnecessary_getters_setters
  int get counter => _counter;
  // ignore: unnecessary_getters_setters
  set counter(int value) => _counter = value;

  @override
  Future process(String lastRequestUniqueId) async {
    this.fetcherSink(counter, lastRequestUniqueId: lastRequestUniqueId);
  }
}

CounterBloc counterBloc = CounterBloc();
