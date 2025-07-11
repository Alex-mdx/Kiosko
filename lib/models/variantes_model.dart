import 'dart:convert';

import 'configuracion_model.dart';

class VariantesModel {
  int id;
  int? productoId;
  List<ConfiguracionModel> configuracion;
  String? foto;
  String? precio;
  String? costo;
  String? codigoBarra;
  String nombre;

  VariantesModel(
      {required this.id,
      required this.productoId,
      required this.configuracion,
      required this.foto,
      required this.precio,
      required this.costo,
      required this.codigoBarra,
      required this.nombre});

  VariantesModel copyWith(
          {int? id,
          int? productoId,
          List<ConfiguracionModel>? configuracion,
          String? foto,
          String? precio,
          String? costo,
          String? codigoBarra,
          String? nombre}) =>
      VariantesModel(
          id: id ?? this.id,
          productoId: productoId ?? this.productoId,
          configuracion: configuracion ?? this.configuracion,
          foto: foto ?? this.foto,
          precio: precio ?? this.precio,
          costo: costo ?? this.costo,
          codigoBarra: codigoBarra ?? this.codigoBarra,
          nombre: nombre ?? this.nombre);

  factory VariantesModel.fromJson(Map<String, dynamic> json) => VariantesModel(
      id: json["id"],
      productoId: json["producto_id"],
      configuracion: creadorConfiguracion(json["configuracion"].toString()),
      foto: json["foto"],
      precio: json["precio"],
      costo: json["costo"],
      codigoBarra: json["codigo_barra"],
      nombre: json["nombre"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "producto_id": productoId,
        "configuracion":
            jsonEncode(configuracion.map((r) => r.toJson()).toList()),
        "foto": foto,
        "precio": precio,
        "costo": costo,
        "codigo_barra": codigoBarra,
        "nombre": nombre
      };
}

List<ConfiguracionModel> creadorConfiguracion(String json) {
  List<ConfiguracionModel> object = [];
  final jsonData = jsonDecode(json);
  for (var element in jsonData) {
    object.add(ConfiguracionModel.fromJson(element));
  }
  return object;
}