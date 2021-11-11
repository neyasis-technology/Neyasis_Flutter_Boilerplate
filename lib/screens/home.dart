import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../bloc/api/add.dart';
import '../bloc/api/list.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  TextEditingController controller = TextEditingController();

  void onAddClick() {
    addBloc.call(requestObject: controller.value.text, sinkNullObject: true);
    controller.text = "";
  }

  Widget get input => TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: tr("homeScreen.addingInformation"),
        ),
      );

  Widget get button => MaterialButton(
        minWidth: double.infinity,
        onPressed: onAddClick,
        child: StreamBuilder(
          stream: addBloc.stream,
          builder: (_, __) {
            if (addBloc.isBlocHandling)
              return SpinKitCircle(color: Colors.white, size: 25);
            return Text(tr("homeScreen.add"));
          },
        ),
        textColor: Colors.white,
        color: Colors.blue,
      );

  Widget get list => ListView.builder(
        itemCount: listBloc.store!.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Text("${listBloc.store![index].id} - "),
              Text(listBloc.store![index].name)
            ],
          );
        },
      );

  Widget get loading => SpinKitCircle(color: Colors.black, size: 80);

  Widget get body => Expanded(
        flex: 1,
        child: StreamBuilder(
          stream: listBloc.stream,
          builder: (_, __) {
            if (listBloc.isBlocHandling) return loading;
            if (listBloc.store == null) return Container();
            return list;
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr("homeScreen.title"))),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(children: [input, button, body]),
      ),
    );
  }
}
