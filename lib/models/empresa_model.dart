class EmpresaModel {
  int id;
  String? file;
  String? nombre;
  String? rfc;
  String? marca;
  String? eslogan;
  String? logo;
  String? razonSocial;
  String? representanteLegal;
  String? fechaConstitucion;
  int? direccionId;
  String? url;
  String? curp;
  String? registroPatronal;
  String? regimenFiscal;
  String? ciec;
  String? perfilImpuestoCompra;
  String? perfilImpuestoVenta;
  String? clave;
  String? telefono;
  String? correo;

  EmpresaModel({
    required this.id,
    required this.file,
    required this.nombre,
    required this.rfc,
    required this.marca,
    required this.eslogan,
    required this.logo,
    required this.razonSocial,
    required this.representanteLegal,
    required this.fechaConstitucion,
    required this.direccionId,
    required this.url,
    required this.curp,
    required this.registroPatronal,
    required this.regimenFiscal,
    required this.ciec,
    required this.perfilImpuestoCompra,
    required this.perfilImpuestoVenta,
    required this.clave,
    required this.telefono,
    required this.correo,
  });

  EmpresaModel copyWith(
          {int? id,
          String? file,
          String? nombre,
          String? rfc,
          String? marca,
          String? eslogan,
          String? logo,
          String? razonSocial,
          String? representanteLegal,
          String? fechaConstitucion,
          int? direccionId,
          String? url,
          String? curp,
          String? registroPatronal,
          String? regimenFiscal,
          String? ciec,
          String? perfilImpuestoCompra,
          String? perfilImpuestoVenta,
          dynamic clave,
          String? telefono,
          String? correo}) =>
      EmpresaModel(
          id: id ?? this.id,
          file: file ?? this.file,
          nombre: nombre ?? this.nombre,
          rfc: rfc ?? this.rfc,
          marca: marca ?? this.marca,
          eslogan: eslogan ?? this.eslogan,
          logo: logo ?? this.logo,
          razonSocial: razonSocial ?? this.razonSocial,
          representanteLegal: representanteLegal ?? this.representanteLegal,
          fechaConstitucion: fechaConstitucion ?? this.fechaConstitucion,
          direccionId: direccionId ?? this.direccionId,
          url: url ?? this.url,
          curp: curp ?? this.curp,
          registroPatronal: registroPatronal ?? this.registroPatronal,
          regimenFiscal: regimenFiscal ?? this.regimenFiscal,
          ciec: ciec ?? this.ciec,
          perfilImpuestoCompra:
              perfilImpuestoCompra ?? this.perfilImpuestoCompra,
          perfilImpuestoVenta: perfilImpuestoVenta ?? this.perfilImpuestoVenta,
          clave: clave ?? this.clave,
          telefono: telefono ?? this.telefono,
          correo: correo ?? this.correo);

  factory EmpresaModel.fromJson(Map<String, dynamic> json) => EmpresaModel(
      id: json["id"],
      file: json["file"],
      nombre: json["nombre"],
      rfc: json["rfc"],
      marca: json["marca"],
      eslogan: json["eslogan"],
      logo: json["logo"],
      razonSocial: json["razon_social"],
      representanteLegal: json["representante_legal"],
      fechaConstitucion: json["fecha_constitucion"],
      direccionId: json["direccion_id"],
      url: json["url"],
      curp: json["curp"],
      registroPatronal: json["registro_patronal"],
      regimenFiscal: json["regimen_fiscal"],
      ciec: json["ciec"],
      perfilImpuestoCompra: json["perfil_impuesto_compra"].toString(),
      perfilImpuestoVenta: json["perfil_impuesto_venta"].toString(),
      clave: json["clave"],
      telefono: json["telefono"].toString(),
      correo: json["correo"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "file": file,
        "nombre": nombre,
        "rfc": rfc,
        "marca": marca,
        "eslogan": eslogan,
        "logo": logo,
        "razon_social": razonSocial,
        "representante_legal": representanteLegal,
        "fecha_constitucion": fechaConstitucion,
        "direccion_id": direccionId,
        "url": url,
        "curp": curp,
        "registro_patronal": registroPatronal,
        "regimen_fiscal": regimenFiscal,
        "ciec": ciec,
        "perfil_impuesto_compra": perfilImpuestoCompra,
        "perfil_impuesto_venta": perfilImpuestoVenta,
        "clave": clave,
        "telefono": telefono,
        "correo": correo
      };
}
