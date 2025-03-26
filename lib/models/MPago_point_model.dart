class MPagoPointModel {
  String id;
  int posId;
  int storeId;
  String externalPosId;
  String operatingMode;

  MPagoPointModel(
      {required this.id,
      required this.posId,
      required this.storeId,
      required this.externalPosId,
      required this.operatingMode});

  MPagoPointModel copyWith({
    String? id,
    int? posId,
    int? storeId,
    String? externalPosId,
    String? operatingMode,
  }) =>
      MPagoPointModel(
          id: id ?? this.id,
          posId: posId ?? this.posId,
          storeId: storeId ?? this.storeId,
          externalPosId: externalPosId ?? this.externalPosId,
          operatingMode: operatingMode ?? this.operatingMode);

  factory MPagoPointModel.fromJson(Map<String, dynamic> json) =>
      MPagoPointModel(
          id: json["id"].toString(),
          posId: int.parse(json["pos_id"].toString()),
          storeId: int.parse(json["store_id"].toString()),
          externalPosId: json["external_pos_id"].toString(),
          operatingMode: json["operating_mode"].toString());

  Map<String, dynamic> toJson() => {
        "id": id,
        "pos_id": posId,
        "store_id": storeId,
        "external_pos_id": externalPosId,
        "operating_mode": operatingMode
      };
}
