class MPagoPayIntentModel {
  String id;
  String state;
  double amount;
  String deviceId;

  MPagoPayIntentModel(
      {required this.id,
      required this.state,
      required this.amount,
      required this.deviceId});

  MPagoPayIntentModel copyWith(
          {String? id,
          String? state,
          double? amount,
          String? deviceId}) =>
      MPagoPayIntentModel(
          id: id ?? this.id,
          state: state ?? this.state,
          amount: amount ?? this.amount,
          deviceId: deviceId ?? this.deviceId);

  factory MPagoPayIntentModel.fromJson(Map<String, dynamic> json) =>
      MPagoPayIntentModel(
          id: json["id"],
          state: json["state"],
          amount: json["amount"].toDouble(),
          deviceId: json["device_id"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "state": state,
        "amount": amount,
        "device_id": deviceId
      };
}
