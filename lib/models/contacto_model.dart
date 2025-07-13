import 'dart:convert';

import 'razon_social_model.dart';

class ContactosModelo {
  int id;
  String? nombre;
  int? direccionId;
  int? databaseId;
  int? listaPrecioClienteId;
  int? listaPrecioProveedorId;
  String? apellidoPaterno;
  String? apellidoMaterno;
  int? personaMoral;
  int? cliente;
  int? proveedor;
  int? deudor;
  int? acreedor;
  int? empleado;
  int? vendedor;
  int? cajero;
  int? tecnico;
  String? nombreCompleto;
  int? userId;
  String? impuestoPerfilProveedor;
  int? socio;
  int? diasCreditoCliente;
  int? diasCreditoProveedor;
  int? listaDescuentoClienteId;
  int? permisionario;
  int? chofer;
  String? codigo;
  int? tipoComisionId;
  int? listaComisionId;
  List<RazonSocialModel> razonesSociales;

  ContactosModelo(
      {required this.id,
      required this.nombre,
      required this.direccionId,
      required this.databaseId,
      required this.listaPrecioClienteId,
      required this.listaPrecioProveedorId,
      required this.apellidoPaterno,
      required this.apellidoMaterno,
      required this.personaMoral,
      required this.cliente,
      required this.proveedor,
      required this.deudor,
      required this.acreedor,
      required this.empleado,
      required this.vendedor,
      required this.cajero,
      required this.tecnico,
      required this.nombreCompleto,
      required this.userId,
      required this.impuestoPerfilProveedor,
      required this.socio,
      required this.diasCreditoCliente,
      required this.diasCreditoProveedor,
      required this.listaDescuentoClienteId,
      required this.permisionario,
      required this.chofer,
      required this.codigo,
      required this.tipoComisionId,
      required this.listaComisionId,
      required this.razonesSociales});

  ContactosModelo copyWith(
          {int? id,
          String? nombre,
          int? direccionId,
          int? databaseId,
          dynamic listaPrecioClienteId,
          dynamic listaPrecioProveedorId,
          String? apellidoPaterno,
          String? apellidoMaterno,
          int? personaMoral,
          int? cliente,
          int? proveedor,
          int? deudor,
          int? acreedor,
          int? empleado,
          int? vendedor,
          int? cajero,
          int? tecnico,
          String? nombreCompleto,
          int? userId,
          dynamic impuestoPerfilProveedor,
          int? socio,
          int? diasCreditoCliente,
          int? diasCreditoProveedor,
          dynamic listaDescuentoClienteId,
          int? permisionario,
          int? chofer,
          String? codigo,
          int? tipoComisionId,
          int? listaComisionId,
          List<RazonSocialModel>? razonesSociales}) =>
      ContactosModelo(
          id: id ?? this.id,
          nombre: nombre ?? this.nombre,
          direccionId: direccionId ?? this.direccionId,
          databaseId: databaseId ?? this.databaseId,
          listaPrecioClienteId:
              listaPrecioClienteId ?? this.listaPrecioClienteId,
          listaPrecioProveedorId:
              listaPrecioProveedorId ?? this.listaPrecioProveedorId,
          apellidoPaterno: apellidoPaterno ?? this.apellidoPaterno,
          apellidoMaterno: apellidoMaterno ?? this.apellidoMaterno,
          personaMoral: personaMoral ?? this.personaMoral,
          cliente: cliente ?? this.cliente,
          proveedor: proveedor ?? this.proveedor,
          deudor: deudor ?? this.deudor,
          acreedor: acreedor ?? this.acreedor,
          empleado: empleado ?? this.empleado,
          vendedor: vendedor ?? this.vendedor,
          cajero: cajero ?? this.cajero,
          tecnico: tecnico ?? this.tecnico,
          nombreCompleto: nombreCompleto ?? this.nombreCompleto,
          userId: userId ?? this.userId,
          impuestoPerfilProveedor:
              impuestoPerfilProveedor ?? this.impuestoPerfilProveedor,
          socio: socio ?? this.socio,
          diasCreditoCliente: diasCreditoCliente ?? this.diasCreditoCliente,
          diasCreditoProveedor:
              diasCreditoProveedor ?? this.diasCreditoProveedor,
          listaDescuentoClienteId:
              listaDescuentoClienteId ?? this.listaDescuentoClienteId,
          permisionario: permisionario ?? this.permisionario,
          chofer: chofer ?? this.chofer,
          codigo: codigo,
          tipoComisionId: tipoComisionId ?? this.tipoComisionId,
          listaComisionId: listaComisionId ?? this.listaComisionId,
          razonesSociales: razonesSociales ?? this.razonesSociales);

  factory ContactosModelo.fromJson(Map<String, dynamic> json) =>
      ContactosModelo(
          id: json["id"],
          nombre: json["nombre"],
          direccionId: json["direccion_id"],
          databaseId: json["database_id"],
          listaPrecioClienteId: json["lista_precio_cliente_id"],
          listaPrecioProveedorId: json["lista_precio_proveedor_id"],
          apellidoPaterno: json["apellido_paterno"],
          apellidoMaterno: json["apellido_materno"],
          personaMoral: json["persona_moral"],
          cliente: json["cliente"],
          proveedor: json["proveedor"],
          deudor: json["deudor"],
          acreedor: json["acreedor"],
          empleado: json["empleado"],
          vendedor: json["vendedor"],
          cajero: json["cajero"],
          tecnico: json["tecnico"],
          nombreCompleto: json["nombre_completo"],
          userId: json["user_id"],
          impuestoPerfilProveedor: json["impuesto_perfil_proveedor"],
          socio: json["socio"],
          diasCreditoCliente: json["dias_credito_cliente"],
          diasCreditoProveedor: json["dias_credito_proveedor"],
          listaDescuentoClienteId: json["lista_descuento_cliente_id"],
          permisionario: json["permisionario"],
          chofer: json["chofer"],
          codigo: json["codigo"],
          tipoComisionId: json["tipo_comision_id"],
          listaComisionId: json["lista_comision_id"],
          razonesSociales:
              creadorRutaRazonSocial(json["razones_sociales"] ?? "[]"));

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "direccion_id": direccionId,
        "database_id": databaseId,
        "lista_precio_cliente_id": listaPrecioClienteId,
        "lista_precio_proveedor_id": listaPrecioProveedorId,
        "apellido_paterno": apellidoPaterno,
        "apellido_materno": apellidoMaterno,
        "persona_moral": personaMoral,
        "cliente": cliente,
        "proveedor": proveedor,
        "deudor": deudor,
        "acreedor": acreedor,
        "empleado": empleado,
        "vendedor": vendedor,
        "cajero": cajero,
        "tecnico": tecnico,
        "nombre_completo": nombreCompleto,
        "user_id": userId,
        "impuesto_perfil_proveedor": impuestoPerfilProveedor,
        "socio": socio,
        "dias_credito_cliente": diasCreditoCliente,
        "dias_credito_proveedor": diasCreditoProveedor,
        "lista_descuento_cliente_id": listaDescuentoClienteId,
        "permisionario": permisionario,
        "chofer": chofer,
        "codigo": codigo,
        "tipo_comision_id": tipoComisionId,
        "lista_comision_id": listaComisionId,
        "razones_sociales":
            jsonEncode(razonesSociales.map((r) => r.toJson()).toList()),
      };
}

List<RazonSocialModel> creadorRutaRazonSocial(String json) {
  List<RazonSocialModel> object = [];
  final jsonData = jsonDecode(json);
  for (var element in jsonData) {
    object.add(RazonSocialModel.fromJson(element));
  }
  return object;
}
