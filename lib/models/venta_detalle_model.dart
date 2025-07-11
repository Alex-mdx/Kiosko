import 'dart:convert';

import 'impuesto_model.dart';

class Detalles {
  int? almacenId;
  int? categoriaId;
  int? productoId;
  int? tipoProductoId;
  String? concepto;
  int? listaComisionId;
  double? comision;
  String? notas;
  double? cantidad;
  String? precio;
  String? precioBase;
  double? descuentoImporte;
  String? costo;
  String? importeCosto;
  String? subTotal;
  String? impuesto;
  double? retencion;
  double? total;
  int? unidadId;
  int? lineaId;
  int? press;
  int? grupoProductoId;
  int? productoEquivalenteId;
  List<SerieModel> serie;
  List<ImpuestosModel> impuestos;
  List<int> modificador;

  Detalles(
      {required this.almacenId,
      required this.categoriaId,
      required this.productoId,
      required this.tipoProductoId,
      required this.concepto,
      required this.listaComisionId,
      required this.comision,
      required this.notas,
      required this.cantidad,
      required this.precio,
      required this.precioBase,
      required this.descuentoImporte,
      required this.costo,
      required this.importeCosto,
      required this.subTotal,
      required this.impuesto,
      required this.retencion,
      required this.total,
      required this.unidadId,
      required this.lineaId,
      this.press,
      required this.impuestos,
      required this.productoEquivalenteId,
      required this.serie,
      required this.grupoProductoId,
      required this.modificador});

  Detalles copyWith(
          {int? almacenId,
          int? categoriaId,
          int? productoId,
          int? tipoProductoId,
          String? concepto,
          int? listaComisionId,
          double? comision,
          String? notas,
          double? cantidad,
          String? precio,
          String? precioBase,
          double? descuentoImporte,
          String? costo,
          String? importeCosto,
          String? subTotal,
          String? impuesto,
          double? retencion,
          double? total,
          int? unidadId,
          int? lineaId,
          int? press,
          int? productoEquivalenteId,
          List<ImpuestosModel>? impuestos,
          List<SerieModel>? serie,
          int? grupoProductoId,
          List<int>? modificador}) =>
      Detalles(
          almacenId: almacenId ?? this.almacenId,
          categoriaId: categoriaId ?? this.categoriaId,
          productoId: productoId ?? this.productoId,
          tipoProductoId: tipoProductoId ?? this.tipoProductoId,
          concepto: concepto ?? this.concepto,
          listaComisionId: listaComisionId ?? this.listaComisionId,
          comision: comision ?? this.comision,
          notas: notas ?? this.notas,
          cantidad: cantidad ?? this.cantidad,
          precio: precio ?? this.precio,
          precioBase: precioBase ?? this.precioBase,
          descuentoImporte: descuentoImporte ?? this.descuentoImporte,
          costo: costo ?? this.costo,
          importeCosto: importeCosto ?? this.importeCosto,
          subTotal: subTotal ?? this.subTotal,
          impuesto: impuesto ?? this.impuesto,
          retencion: retencion ?? this.retencion,
          total: total ?? this.total,
          unidadId: unidadId ?? this.unidadId,
          lineaId: lineaId ?? this.lineaId,
          press: press ?? this.press,
          impuestos: impuestos ?? this.impuestos,
          productoEquivalenteId:
              productoEquivalenteId ?? this.productoEquivalenteId,
          serie: serie ?? this.serie,
          grupoProductoId: grupoProductoId ?? this.grupoProductoId,
          modificador: modificador ?? this.modificador);

  factory Detalles.fromJson(Map<String, dynamic> json) => Detalles(
      almacenId: json["almacen_id"],
      categoriaId: json["categoria_id"],
      productoId: json["producto_id"],
      tipoProductoId: json["tipo_producto_id"],
      concepto: json["concepto"],
      listaComisionId: json["lista_comision_id"],
      comision: json["comision"],
      notas: json["notas"],
      cantidad: json["cantidad"],
      precio: json["precio"],
      precioBase: json["precio_base"],
      descuentoImporte: json["descuento_importe"],
      costo: json["costo"],
      importeCosto: json["importe_costo"],
      subTotal: json["sub_total"],
      impuesto: json["impuesto"],
      retencion: json["retencion"],
      total: json["total"],
      unidadId: json["unidad_id"],
      lineaId: json["linea_id"],
      press: json["press"],
      grupoProductoId: json["grupo_producto_id"],
      serie: json["serie"].toString() == "null"
          ? []
          : creadorSerie(json["serie"].toString()),
      productoEquivalenteId: json["producto_equivalente_id"],
      impuestos: json["impuestos"] == null
          ? []
          : creadorImpuesto(json["impuestos"].toString()),
      modificador: json["modificador"] == null
          ? []
          : List<int>.from(
              jsonDecode(json["modificador"].toString()).map((x) => x)));

  Map<String, dynamic> toJson() => {
        "almacen_id": almacenId,
        "categoria_id": categoriaId,
        "producto_id": productoId,
        "tipo_producto_id": tipoProductoId,
        "concepto": concepto,
        "lista_comision_id": listaComisionId,
        "comision": comision,
        "notas": notas,
        "cantidad": cantidad,
        "precio": precio,
        "precio_base": precioBase,
        "descuento_importe": descuentoImporte,
        "costo": costo,
        "importe_costo": importeCosto,
        "sub_total": subTotal,
        "impuesto": impuesto,
        "retencion": retencion,
        "total": total,
        "unidad_id": unidadId,
        "linea_id": lineaId,
        "press": press,
        "grupo_producto_id": grupoProductoId,
        "producto_equivalente_id": productoEquivalenteId,
        "serie": jsonEncode(serie.map((e) => e.toJson()).toList()),
        "impuestos": jsonEncode(impuestos.map((r) => r.toJson()).toList()),
        "modificador": jsonEncode(modificador)
      };
}

List<ImpuestosModel> creadorImpuesto(String json) {
  List<ImpuestosModel> object = [];
  try {
    final jsonData = jsonDecode(json);
    for (var element in jsonData) {
      object.add(ImpuestosModel.fromJson(element));
    }
    return object;
  } catch (e) {
    return [];
  }
}

List<SerieModel> creadorSerie(String json) {
  List<SerieModel> object = [];
  try {
    final jsonData = jsonDecode(json);
    for (var element in jsonData) {
      object.add(SerieModel.fromJson(element));
    }
    return object;
  } catch (e) {
    return [];
  }
}

class SerieModel {
  String? serie;
  String? lote;

  SerieModel({required this.serie, required this.lote});

  SerieModel copyWith({String? serie, String? lote}) =>
      SerieModel(serie: serie ?? this.serie, lote: lote ?? this.lote);

  factory SerieModel.fromJson(Map<String, dynamic> json) =>
      SerieModel(serie: json["serie"], lote: json["lote"]);

  Map<String, dynamic> toJson() => {"serie": serie, "lote": lote};
}
