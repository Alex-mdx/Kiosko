class PagoModel {
  int? id;
  String? nombre;
  int? databaseId;
  String? factorComision;
  String? codigoSat;
  String? cuentaContable;
  String? metodoPago;
  String? formaPago;
  String? moneda;
  int? permitirCambio;
  String? importe;
  String? referencia;
  double? cambio;
  double? tipoCambio;
  int? cuentaBancariaId;
  int? formaPagoId;
  int press;

  PagoModel({
    required this.id,
    required this.nombre,
    required this.databaseId,
    required this.factorComision,
    required this.codigoSat,
    required this.cuentaContable,
    required this.metodoPago,
    required this.formaPago,
    required this.moneda,
    required this.permitirCambio,
    required this.importe,
    required this.referencia,
    required this.cambio,
    required this.tipoCambio,
    required this.cuentaBancariaId,
    required this.formaPagoId,
    required this.press,
  });

  PagoModel copyWith({
    int? id,
    String? nombre,
    int? databaseId,
    String? factorComision,
    String? codigoSat,
    String? cuentaContable,
    String? metodoPago,
    String? formaPago,
    String? moneda,
    int? permitirCambio,
    String? importe,
    String? referencia,
    double? cambio,
    double? tipoCambio,
    int? cuentaBancariaId,
    int? formaPagoId,
    int? press,
  }) =>
      PagoModel(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        databaseId: databaseId ?? this.databaseId,
        factorComision: factorComision ?? this.factorComision,
        codigoSat: codigoSat ?? this.codigoSat,
        cuentaContable: cuentaContable ?? this.cuentaContable,
        metodoPago: metodoPago ?? this.metodoPago,
        formaPago: formaPago ?? this.formaPago,
        moneda: moneda ?? this.moneda,
        permitirCambio: permitirCambio ?? this.permitirCambio,
        importe: importe ?? this.importe,
        referencia: referencia ?? this.referencia,
        cambio: cambio ?? this.cambio,
        tipoCambio: tipoCambio ?? this.tipoCambio,
        cuentaBancariaId: cuentaBancariaId ?? this.cuentaBancariaId,
        formaPagoId: formaPagoId ?? this.formaPagoId,
        press: press ?? this.press
      );

  factory PagoModel.fromJson(Map<String, dynamic> json) => PagoModel(
        id: json["id"],
        nombre: json["nombre"],
        databaseId: json["database_id"],
        factorComision: json["factor_comision"],
        codigoSat: json["codigo_sat"],
        cuentaContable: json["cuenta_contable"],
        metodoPago: json["metodo_pago"],
        formaPago: json["forma_pago"],
        moneda: json["moneda"],
        permitirCambio: json["permitir_cambio"],
        importe: json["importe"],
        referencia: json["referencia"],
        cambio: json["cambio"]?.toDouble(),
        tipoCambio: json["tipo_cambio"]?.toDouble(),
        cuentaBancariaId: json["cuenta_bancaria_id"],
        formaPagoId: json["forma_pago_id"],
        press: json["press"] ?? 0
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "database_id": databaseId,
        "factor_comision": factorComision,
        "codigo_sat": codigoSat,
        "cuenta_contable": cuentaContable,
        "metodo_pago": metodoPago,
        "forma_pago": formaPago,
        "moneda": moneda,
        "permitir_cambio": permitirCambio,
        "importe": importe,
        "referencia": referencia,
        "cambio": cambio,
        "tipo_cambio": tipoCambio,
        "cuenta_bancaria_id": cuentaBancariaId,
        "forma_pago_id": formaPagoId,
        "press": press
      };
}
