import 'dart:convert';

import '../utils/funcion_parser.dart';
import 'venta_detalle_model.dart';
import 'venta_pago_model.dart';

class VentaModel {
  int? id;
  String? folio;
  int? sincronizado;
  int? consecutivo;
  int apiKeyId;
  int? contactoId;
  int? vendedorId;
  int? userId;
  int? empresaId;
  int? almacenId;
  int? sucursalId;
  String? moneda;
  int? cuentaBancariaId;
  String? metodoPago;
  int? razonSocialId;
  String? fecha;
  String? serie;
  double? total;
  double? comision;
  double? tipoCambio;
  int? formaPagoId;
  int? cerrado;
  String? notas;
  String? transaccion;
  String? fechaApertura;
  String? fechaCierre;
  int? status;
  String? errorVenta;
  List<Detalles> detalles;
  List<PagoModel> pagos;

  VentaModel(
      {this.id,
      this.folio,
      required this.sincronizado,
      required this.consecutivo,
      required this.apiKeyId,
      required this.contactoId,
      required this.vendedorId,
      required this.userId,
      required this.empresaId,
      required this.almacenId,
      required this.sucursalId,
      required this.moneda,
      required this.cuentaBancariaId,
      required this.metodoPago,
      required this.razonSocialId,
      required this.fecha,
      required this.serie,
      required this.total,
      required this.comision,
      required this.tipoCambio,
      required this.formaPagoId,
      required this.cerrado,
      this.notas,
      required this.transaccion,
      required this.fechaApertura,
      required this.fechaCierre,
      this.status,
      this.errorVenta,
      required this.detalles,
      required this.pagos});

  VentaModel copyWith(
          {int? id,
          String? folio,
          int? sincronizado,
          int? consecutivo,
          int? apiKeyId,
          int? contactoId,
          int? vendedorId,
          int? userId,
          int? empresaId,
          int? almacenId,
          int? sucursalId,
          String? moneda,
          int? cuentaBancariaId,
          String? metodoPago,
          int? razonSocialId,
          String? fecha,
          String? serie,
          double? total,
          double? comision,
          double? tipoCambio,
          int? formaPagoId,
          int? cerrado,
          String? notas,
          String? transaccion,
          String? fechaApertura,
          String? fechaCierre,
          int? status,
          String? errorVenta,
          List<Detalles>? detalles,
          List<PagoModel>? pagos}) =>
      VentaModel(
          id: id ?? this.id,
          folio: folio ?? this.folio,
          sincronizado: sincronizado ?? this.sincronizado,
          consecutivo: consecutivo ?? this.consecutivo,
          apiKeyId: apiKeyId ?? this.apiKeyId,
          contactoId: contactoId ?? this.contactoId,
          vendedorId: vendedorId ?? this.vendedorId,
          userId: userId ?? this.userId,
          empresaId: empresaId ?? this.empresaId,
          almacenId: almacenId ?? this.almacenId,
          sucursalId: sucursalId ?? this.sucursalId,
          moneda: moneda ?? this.moneda,
          cuentaBancariaId: cuentaBancariaId ?? this.cuentaBancariaId,
          metodoPago: metodoPago ?? this.metodoPago,
          razonSocialId: razonSocialId ?? this.razonSocialId,
          fecha: fecha ?? this.fecha,
          serie: serie ?? this.serie,
          total: total ?? this.total,
          comision: comision ?? this.comision,
          tipoCambio: tipoCambio ?? this.tipoCambio,
          formaPagoId: formaPagoId ?? this.formaPagoId,
          cerrado: cerrado ?? this.cerrado,
          notas: notas ?? this.notas,
          transaccion: transaccion ?? this.transaccion,
          fechaApertura: fechaApertura ?? this.fechaApertura,
          fechaCierre: fechaCierre ?? this.fechaCierre,
          status: status ?? this.status,
          errorVenta: errorVenta ?? this.errorVenta,
          detalles: detalles ?? this.detalles,
          pagos: pagos ?? this.pagos);

  factory VentaModel.fromJson(Map<String, dynamic> json) => VentaModel(
      id: json["id"],
      folio: json["folio"],
      sincronizado: json["sincronizado"],
      consecutivo: json["consecutivo"],
      apiKeyId: json["api_key_id"],
      contactoId: json["contacto_id"],
      vendedorId: json["vendedor_id"],
      userId: json["user_id"],
      empresaId: json["empresa_id"],
      almacenId: json["almacen_id"],
      sucursalId: json["sucursal_id"],
      moneda: json["moneda"],
      cuentaBancariaId: json["cuenta_bancaria_id"],
      metodoPago: json["metodo_pago"],
      razonSocialId: json["razon_social_id"],
      fecha: json["fecha"],
      serie: json["serie"],
      total: double.parse(json["total"].toString()),
      comision: double.parse(json["comision"].toString()),
      tipoCambio: double.parse(json["tipo_cambio"].toString()),
      formaPagoId: json["forma_pago_id"],
      cerrado: json["cerrado"],
      notas: json["notas"],
      transaccion: json["transaccion"],
      fechaApertura: json["fecha_apertura"],
      fechaCierre: json["fecha_cierre"],
      status: Parser.toInt(json["status"]),
      errorVenta: json["error_venta"],
      detalles: detalleModelado(json["detalles"].toString()),
      pagos: pagoModelado(json["pagos"].toString()));

  Map<String, dynamic> toJson() => {
        "id": id,
        "folio": folio,
        "sincronizado": sincronizado,
        "consecutivo": consecutivo,
        "api_key_id": apiKeyId,
        "contacto_id": contactoId,
        "vendedor_id": vendedorId,
        "user_id": userId,
        "empresa_id": empresaId,
        "almacen_id": almacenId,
        "sucursal_id": sucursalId,
        "moneda": moneda,
        "cuenta_bancaria_id": cuentaBancariaId,
        "metodo_pago": metodoPago,
        "razon_social_id": razonSocialId,
        "fecha": fecha,
        "serie": serie,
        "total": total,
        "comision": comision,
        "tipo_cambio": tipoCambio,
        "forma_pago_id": formaPagoId,
        "cerrado": cerrado,
        "notas": notas,
        "transaccion": transaccion,
        "fecha_apertura": fechaApertura,
        "fecha_cierre": fechaCierre,
        "status": status,
        "error_venta": errorVenta,
        "detalles": List<dynamic>.from(detalles.map((x) => x.toJson())),
        "pagos": List<dynamic>.from(pagos.map((x) => x.toJson()))
      };
  static List<Detalles> detalleModelado(String texto) {
    final mapa = jsonDecode(texto);
    List<Detalles> detalleTemp = [];
    for (var element in mapa) {
      detalleTemp.add(Detalles.fromJson(element));
    }
    return detalleTemp;
  }

  static List<PagoModel> pagoModelado(String texto) {
    final mapa = jsonDecode(texto);
    List<PagoModel> pagoTemp = [];
    for (var element in mapa) {
      pagoTemp.add(PagoModel.fromJson(element));
    }
    return pagoTemp;
  }
}
