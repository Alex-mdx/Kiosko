import 'dart:convert';

import 'catagolo_general_model.dart';
import 'chip_model.dart';
import 'configuracion_model.dart';

class AtributosModel {
  int id;
  int productoId;
  int catalogoGeneralId;
  List<ConfiguracionModel> configuracion;
  CatalogoGeneralModel catalogoGeneral;
  List<ChipModel> chips;

  AtributosModel(
      {required this.id,
      required this.productoId,
      required this.catalogoGeneralId,
      required this.configuracion,
      required this.catalogoGeneral,
      required this.chips});

  AtributosModel copyWith(
          {int? id,
          int? productoId,
          int? catalogoGeneralId,
          List<ConfiguracionModel>? configuracion,
          CatalogoGeneralModel? catalogoGeneral,
          List<ChipModel>? chips}) =>
      AtributosModel(
          id: id ?? this.id,
          productoId: productoId ?? this.productoId,
          catalogoGeneralId: catalogoGeneralId ?? this.catalogoGeneralId,
          configuracion: configuracion ?? this.configuracion,
          catalogoGeneral: catalogoGeneral ?? this.catalogoGeneral,
          chips: chips ?? this.chips);

  factory AtributosModel.fromJson(Map<String, dynamic> json) => AtributosModel(
      id: json["id"],
      productoId: json["producto_id"],
      catalogoGeneralId: json["catalogo_general_id"],
      configuracion: creadorConfiguracion(
          json["configuracion"].toString()),
      catalogoGeneral: CatalogoGeneralModel.fromJson(jsonDecode(json["catalogo_general"])),
      chips: creadorChip(json["chips"]));

  Map<String, dynamic> toJson() => {
        "id": id,
        "producto_id": productoId,
        "catalogo_general_id": catalogoGeneralId,
        "configuracion":
            jsonEncode(configuracion.map((r) => r.toJson()).toList()),
        "catalogo_general": jsonEncode(catalogoGeneral),
        "chips": jsonEncode(chips.map((r) => r.toJson()).toList()),
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

List<ChipModel> creadorChip(String json) {
  List<ChipModel> object = [];
  final jsonData = jsonDecode(json);
  for (var element in jsonData  ) {
    object.add(ChipModel.fromJson(element));
  }
  return object;
}