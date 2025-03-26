class MPagoIntentModel {
  double amount;
  String deviceId;
  String id;
  String paymentMode;

  MPagoIntentModel(
      {required this.amount,
      required this.deviceId,
      required this.id,
      required this.paymentMode});

  MPagoIntentModel copyWith(
          {double? amount,
          String? deviceId,
          String? id,
          String? paymentMode}) =>
      MPagoIntentModel(
          amount: amount ?? this.amount,
          deviceId: deviceId ?? this.deviceId,
          id: id ?? this.id,
          paymentMode: paymentMode ?? this.paymentMode);

  factory MPagoIntentModel.fromJson(Map<String, dynamic> json) =>
      MPagoIntentModel(
          amount: double.parse(json["amount"].toString()),
          deviceId: json["device_id"].toString(),
          id: json["id"].toString(),
          paymentMode: json["payment_mode"].toString());

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "device_id": deviceId,
        "id": id,
        "payment_mode": paymentMode
      };
}
