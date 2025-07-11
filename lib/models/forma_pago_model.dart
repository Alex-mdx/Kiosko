class FormaPagoModel {
    int id;
    String? nombre;
    int? databaseId;
    int? bancarizado;
    int? depositable;
    int? mostrarPv;
    int? requiereReferencia;
    String? factorComision;
    String? codigoSat;
    String? cuentaContable;
    String? metodoPago;
    String? formaPago;
    String? moneda;
    String tipoCambioDefault;
    int? permitirCambio;
    int? cuentaBancariaId;
    int? credito;
    int? razonSocialId;

    FormaPagoModel({
        required this.id,
        required this.nombre,
        required this.databaseId,
        required this.bancarizado,
        required this.depositable,
        required this.mostrarPv,
        required this.requiereReferencia,
        required this.factorComision,
        required this.codigoSat,
        required this.cuentaContable,
        required this.metodoPago,
        required this.formaPago,
        required this.moneda,
        required this.tipoCambioDefault,
        required this.permitirCambio,
        required this.cuentaBancariaId,
        required this.credito,
        required this.razonSocialId,
    });

    FormaPagoModel copyWith({
        int? id,
        String? nombre,
        int? databaseId,
        int? bancarizado,
        int? depositable,
        int? mostrarPv,
        int? requiereReferencia,
        String? factorComision,
        String? codigoSat,
        String? cuentaContable,
        String? metodoPago,
        String? formaPago,
        String? moneda,
        String? tipoCambioDefault,
        int? permitirCambio,
        int? cuentaBancariaId,
        int? credito,
        int? razonSocialId,
    }) => 
        FormaPagoModel(
            id: id ?? this.id,
            nombre: nombre ?? this.nombre,
            databaseId: databaseId ?? this.databaseId,
            bancarizado: bancarizado ?? this.bancarizado,
            depositable: depositable ?? this.depositable,
            mostrarPv: mostrarPv ?? this.mostrarPv,
            requiereReferencia: requiereReferencia ?? this.requiereReferencia,
            factorComision: factorComision ?? this.factorComision,
            codigoSat: codigoSat ?? this.codigoSat,
            cuentaContable: cuentaContable ?? this.cuentaContable,
            metodoPago: metodoPago ?? this.metodoPago,
            formaPago: formaPago ?? this.formaPago,
            moneda: moneda ?? this.moneda,
            tipoCambioDefault: tipoCambioDefault ?? this.tipoCambioDefault,
            permitirCambio: permitirCambio ?? this.permitirCambio,
            cuentaBancariaId: cuentaBancariaId ?? this.cuentaBancariaId,
            credito: credito ?? this.credito,
            razonSocialId: razonSocialId ?? this.razonSocialId,
        );

    factory FormaPagoModel.fromJson(Map<String, dynamic> json) => FormaPagoModel(
        id: json["id"],
        nombre: json["nombre"],
        databaseId: json["database_id"],
        bancarizado: json["bancarizado"],
        depositable: json["depositable"],
        mostrarPv: json["mostrar_pv"],
        requiereReferencia: json["requiere_referencia"],
        factorComision: json["factor_comision"],
        codigoSat: json["codigo_sat"],
        cuentaContable: json["cuenta_contable"],
        metodoPago: json["metodo_pago"],
        formaPago: json["forma_pago"],
        moneda: json["moneda"],
        tipoCambioDefault: json["tipo_cambio_default"],
        permitirCambio: json["permitir_cambio"],
        cuentaBancariaId: json["cuenta_bancaria_id"],
        credito: json["credito"],
        razonSocialId: json["razon_social_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "database_id": databaseId,
        "bancarizado": bancarizado,
        "depositable": depositable,
        "mostrar_pv": mostrarPv,
        "requiere_referencia": requiereReferencia,
        "factor_comision": factorComision,
        "codigo_sat": codigoSat,
        "cuenta_contable": cuentaContable,
        "metodo_pago": metodoPago,
        "forma_pago": formaPago,
        "moneda": moneda,
        "tipo_cambio_default": tipoCambioDefault,
        "permitir_cambio": permitirCambio,
        "cuenta_bancaria_id": cuentaBancariaId,
        "credito": credito,
        "razon_social_id": razonSocialId,
    };
}
