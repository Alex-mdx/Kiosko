import '../utils/funcion_parser.dart';

class RazonSocialModel {
    int id;
    int? contactoId;
    int? razonSocialId;
    String? rfc;
    String? razonSocial;
    String? representanteLegal;
    String? fechaInicio;
    int? direccionId;
    String? regimenFiscal;
    String? regimenCapital;
    int? databaseId;
    int? personaMoral;
    String? metodoPago;
    String? usoCfdi;
    String? taxId;
    int? formaPagoId;

    RazonSocialModel({
        required this.id,
        required this.contactoId,
        required this.razonSocialId,
        required this.rfc,
        required this.razonSocial,
        required this.representanteLegal,
        required this.fechaInicio,
        required this.direccionId,
        required this.regimenFiscal,
        required this.regimenCapital,
        required this.databaseId,
        required this.personaMoral,
        required this.metodoPago,
        required this.usoCfdi,
        required this.taxId,
        required this.formaPagoId,
    });

    RazonSocialModel copyWith({
        int? id,
        int? contactoId,
        int? razonSocialId,
        String? rfc,
        String? razonSocial,
        String? representanteLegal,
        String? fechaInicio,
        int? direccionId,
        String? regimenFiscal,
        String? regimenCapital,
        int? databaseId,
        int? personaMoral,
        String? metodoPago,
        String? usoCfdi,
        String? taxId,
        int? formaPagoId,
    }) => 
        RazonSocialModel(
            id: id ?? this.id,
            contactoId: contactoId ?? this.contactoId,
            razonSocialId: razonSocialId ?? this.razonSocialId,
            rfc: rfc ?? this.rfc,
            razonSocial: razonSocial ?? this.razonSocial,
            representanteLegal: representanteLegal ?? this.representanteLegal,
            fechaInicio: fechaInicio ?? this.fechaInicio,
            direccionId: direccionId ?? this.direccionId,
            regimenFiscal: regimenFiscal ?? this.regimenFiscal,
            regimenCapital: regimenCapital ?? this.regimenCapital,
            databaseId: databaseId ?? this.databaseId,
            personaMoral: personaMoral ?? this.personaMoral,
            metodoPago: metodoPago ?? this.metodoPago,
            usoCfdi: usoCfdi ?? this.usoCfdi,
            taxId: taxId ?? this.taxId,
            formaPagoId: formaPagoId ?? this.formaPagoId,
        );

    factory RazonSocialModel.fromJson(Map<String, dynamic> json) => RazonSocialModel(
        id: json["id"],
        contactoId: json["contacto_id"],
        razonSocialId: json["razon_social_id"],
        rfc: json["rfc"],
        razonSocial: json["razon_social"],
        representanteLegal: json["representante_legal"],
        fechaInicio: json["fecha_inicio"],
        direccionId: json["direccion_id"],
        regimenFiscal: json["regimen_fiscal"],
        regimenCapital: json["regimen_capital"],
        databaseId: json["database_id"],
        personaMoral: Parser.toInt(json["persona_moral"]),
        metodoPago: json["metodo_pago"],
        usoCfdi: json["uso_cfdi"],
        taxId: json["tax_id"],
        formaPagoId: json["forma_pago_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "contacto_id": contactoId,
        "razon_social_id": razonSocialId,
        "rfc": rfc,
        "razon_social": razonSocial,
        "representante_legal": representanteLegal,
        "fecha_inicio": fechaInicio,
        "direccion_id": direccionId,
        "regimen_fiscal": regimenFiscal,
        "regimen_capital": regimenCapital,
        "database_id": databaseId,
        "persona_moral": personaMoral,
        "metodo_pago": metodoPago,
        "uso_cfdi": usoCfdi,
        "tax_id": taxId,
        "forma_pago_id": formaPagoId,
    };
}
