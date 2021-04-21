class DataResponseBM {
  final String id;
  final String name;

  DataResponseBM({required this.id, required this.name});

  factory DataResponseBM.fromJSON(dynamic json) {
    return DataResponseBM(
      id: json["id"],
      name: json["name"],
    );
  }
}
