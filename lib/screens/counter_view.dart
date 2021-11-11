import 'package:flutter/material.dart';
import 'package:neyasis_flutter_boilerplate/bloc/api/counter_bloc.dart';

class CounterView extends StatelessWidget {
  const CounterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter View'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counterBloc.call(
              requestObject: counterBloc.counter++, sinkNullObject: true);
        },
        child: Icon(Icons.add),
      ),
      body: Center(
        child: StreamBuilder(
            stream: counterBloc.stream,
            builder: (context, snapshot) {
              return Text(counterBloc.store?.toString() ?? '0');
            }),
      ),
    );
  }
}
