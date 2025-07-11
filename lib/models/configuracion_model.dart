class ConfiguracionModel {
  int? catalogoGeneralId;
  int? catalogoGeneralDetalleId;

  ConfiguracionModel(
      {required this.catalogoGeneralId,
      required this.catalogoGeneralDetalleId});

  ConfiguracionModel copyWith(
          {int? catalogoGeneralId, int? catalogoGeneralDetalleId}) =>
      ConfiguracionModel(
          catalogoGeneralId: catalogoGeneralId ?? this.catalogoGeneralId,
          catalogoGeneralDetalleId:
              catalogoGeneralDetalleId ?? this.catalogoGeneralDetalleId);

  factory ConfiguracionModel.fromJson(Map<String, dynamic> json) => ConfiguracionModel(
      catalogoGeneralId: json["catalogo_general_id"],
      catalogoGeneralDetalleId: json["catalogo_general_detalle_id"]);

  Map<String, dynamic> toJson() => {
        "catalogo_general_id": catalogoGeneralId,
        "catalogo_general_detalle_id": catalogoGeneralDetalleId
      };
}
