import 'dart:convert';

class UsuarioModel {
  int id;
  String? uuid;
  String? nombre;
  int? consecutivo;
  int? databaseId;
  int? userId;
  String? usuario;
  String? user;
  String? password;
  String? token;
  int? almacenId;
  List<int> almacenes;
  int? sucursalId;
  int? empresaId;
  int? clienteId;
  int? vendedorId;
  int? razonSocialId;
  String? moneda;
  String? serieVenta;
  String? serieCobro;
  int? contactoId;
  int? cuentaBancariaId;
  int? empleadoNominaId;
  String? empleadoNomina;

  UsuarioModel(
      {required this.id,
      required this.uuid,
      required this.nombre,
      required this.consecutivo,
      required this.databaseId,
      required this.userId,
      required this.usuario,
      required this.user,
      required this.password,
      required this.token,
      required this.almacenId,
      required this.almacenes,
      required this.sucursalId,
      required this.empresaId,
      required this.clienteId,
      required this.vendedorId,
      required this.razonSocialId,
      required this.moneda,
      required this.serieVenta,
      required this.serieCobro,
      required this.contactoId,
      required this.cuentaBancariaId,
      required this.empleadoNominaId,
      required this.empleadoNomina});

  UsuarioModel copyWith(
          {int? id,
          String? uuid,
          String? nombre,
          int? consecutivo,
          double? corte,
          int? databaseId,
          int? userId,
          String? usuario,
          String? user,
          String? password,
          String? token,
          int? almacenId,
          List<int>? almacenes,
          int? sucursalId,
          int? empresaId,
          int? clienteId,
          int? vendedorId,
          int? razonSocialId,
          String? moneda,
          String? serieVenta,
          String? serieCobro,
          int? contactoId,
          int? cuentaBancariaId,
          int? empleadoNominaId,
          String? empleadoNomina}) =>
      UsuarioModel(
          id: id ?? this.id,
          uuid: uuid ?? this.uuid,
          nombre: nombre ?? this.nombre,
          consecutivo: consecutivo ?? this.consecutivo,
          databaseId: databaseId ?? this.databaseId,
          userId: userId ?? this.userId,
          usuario: usuario ?? this.usuario,
          user: user ?? this.user,
          password: password ?? this.password,
          token: token ?? this.token,
          almacenId: almacenId ?? this.almacenId,
          almacenes: almacenes ?? this.almacenes,
          sucursalId: sucursalId ?? this.sucursalId,
          empresaId: empresaId ?? this.empresaId,
          clienteId: clienteId ?? this.clienteId,
          vendedorId: vendedorId ?? this.vendedorId,
          razonSocialId: razonSocialId ?? this.razonSocialId,
          moneda: moneda ?? this.moneda,
          serieVenta: serieVenta ?? this.serieVenta,
          serieCobro: serieCobro ?? this.serieCobro,
          contactoId: contactoId ?? this.contactoId,
          cuentaBancariaId: cuentaBancariaId ?? this.cuentaBancariaId,
          empleadoNominaId: empleadoNominaId ?? this.empleadoNominaId,
          empleadoNomina: empleadoNomina ?? this.empleadoNomina);

  factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
      id: json["id"],
      uuid: json["uuid"],
      nombre: json["nombre"],
      consecutivo: json["consecutivo"],
      databaseId: json["database_id"],
      userId: json["user_id"],
      usuario: json["usuario"],
      user: json["user"],
      password: json["password"],
      token: json["token"],
      almacenId: json["almacen_id"],
      almacenes: json["almacenes"] == null
          ? []
          : List<int>.from(
              jsonDecode(json["almacenes"].toString()).map((x) => x)),
      sucursalId: json["sucursal_id"],
      empresaId: json["empresa_id"],
      clienteId: json["cliente_id"],
      vendedorId: json["vendedor_id"],
      razonSocialId: json["razon_social_id"],
      moneda: json["moneda"],
      serieVenta: json["serie_venta"],
      serieCobro: json["serie_cobro"],
      contactoId: json["contacto_id"],
      cuentaBancariaId: json["cuenta_bancaria_id"],
      empleadoNominaId: json["empleado_nomina_id"],
      empleadoNomina: json["empleado_nomina"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "nombre": nombre,
        "consecutivo": consecutivo,
        "database_id": databaseId,
        "user_id": userId,
        "usuario": usuario,
        "user": user,
        "password": password,
        "token": token,
        "almacen_id": almacenId,
        "almacenes": List<dynamic>.from(almacenes.map((x) => x)),
        "sucursal_id": sucursalId,
        "empresa_id": empresaId,
        "cliente_id": clienteId,
        "vendedor_id": vendedorId,
        "razon_social_id": razonSocialId,
        "moneda": moneda,
        "serie_venta": serieVenta,
        "serie_cobro": serieCobro,
        "contacto_id": contactoId,
        "cuenta_bancaria_id": cuentaBancariaId,
        "empleado_nomina_id": empleadoNominaId,
        "empleado_nomina": empleadoNomina
      };
}
