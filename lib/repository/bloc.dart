import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

abstract class BlocRepository<RequestObject, ResponseObject> {
  RequestObject? _requestObject;
  bool _isBlocHandling = false;
  ResponseObject? _store;

  // ignore: close_sinks
  final PublishSubject<ResponseObject?> _fetcher =
      PublishSubject<ResponseObject?>();
  Uuid _uuidGenerator = new Uuid();
  String _lastRequestUniqueId = "";
  Function(ResponseObject?)? _listener;

  PublishSubject<ResponseObject?> get fetcher => this._fetcher;

  Stream<ResponseObject?> get stream => _fetcher.stream;

  ResponseObject? get store => this._store;

  // String get lastRequestUniqueId => this._lastRequestUniqueId;

  bool get isBlocHandling => this._isBlocHandling;

  RequestObject? get requestObject => this._requestObject;

  void setStore(ResponseObject? store) => this._store = store;

  void clearRequestObject() => this._requestObject = null;

  void clearStore() {
    this._store = null;
    this.fetcher.sink.addError(-1);
  }

  Future prevProcess() async {
    this._lastRequestUniqueId = this._uuidGenerator.v4();
    await process(this._lastRequestUniqueId);
    this._isBlocHandling = false;
  }

  Future process(String lastRequestUniqueId);

  void call({RequestObject? requestObject, bool sinkNullObject = false}) {
    this._isBlocHandling = true;
    this._requestObject = requestObject;
    if (sinkNullObject) this.fetcher.sink.addError(-1);
    this.prevProcess();
  }

  void fetcherSink(ResponseObject? responseObject,
      {bool forceSink = false, required lastRequestUniqueId}) {
    // ignore: unnecessary_null_comparison
    if ((forceSink != null && forceSink) ||
        lastRequestUniqueId == this._lastRequestUniqueId) {
      this._store = responseObject;
      if (responseObject == null)
        this.fetcher.sink.addError(-1);
      else
        this.fetcher.sink.add(responseObject);
      if (this._listener != null) this._listener!(responseObject);
    } else {
//      print("this request is old request" + ResponseObject.toString());
    }
  }

  void setListener(Function(ResponseObject?) listener) =>
      this._listener = listener;

  dispose() {
    this._fetcher.close();
  }
}
