class MPagoPayIntentModel {
  String id;
  String state;
  double amount;
  String deviceId;
    Payment payment;

  MPagoPayIntentModel(
      {required this.id,
      required this.state,
      required this.amount,
      required this.deviceId,
        required this.payment});

  MPagoPayIntentModel copyWith(
          {String? id, String? state, double? amount, String? deviceId,Payment? payment}) =>
      MPagoPayIntentModel(
          id: id ?? this.id,
          state: state ?? this.state,
          amount: amount ?? this.amount,
          deviceId: deviceId ?? this.deviceId, payment: payment ?? this.payment);

  factory MPagoPayIntentModel.fromJson(Map<String, dynamic> json) =>
      MPagoPayIntentModel(
          id: json["id"],
          state: json["state"],
          amount: json["amount"].toDouble(),
          deviceId: json["device_id"],payment: Payment.fromJson(json["payment"] ?? {}));

  Map<String, dynamic> toJson() =>
      {"id": id, "state": state, "amount": amount, "device_id": deviceId,"payment": payment.toJson()};
}

class Payment {
  String? id;
  String? type;

  Payment({required this.id, required this.type});

  Payment copyWith({String? id, String? type}) =>
      Payment(id: id ?? this.id, type: type ?? this.type);

  factory Payment.fromJson(Map<String, dynamic> json) =>
      Payment(id: json["id"], type: json["type"]);

  Map<String, dynamic> toJson() => {"id": id, "type": type};
}
