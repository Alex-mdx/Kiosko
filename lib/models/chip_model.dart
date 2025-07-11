class ChipModel {
  int id;
  String nombre;
  int catalogoGeneralId;
  String valor;
  String? color;

  ChipModel(
      {required this.id,
      required this.nombre,
      required this.catalogoGeneralId,
      required this.valor,
      required this.color});

  ChipModel copyWith(
          {int? id,
          String? nombre,
          int? catalogoGeneralId,
          String? valor,
          String? color}) =>
      ChipModel(
          id: id ?? this.id,
          nombre: nombre ?? this.nombre,
          catalogoGeneralId: catalogoGeneralId ?? this.catalogoGeneralId,
          valor: valor ?? this.valor,
          color: color ?? this.color);

  factory ChipModel.fromJson(Map<String, dynamic> json) => ChipModel(
      id: json["id"],
      nombre: json["nombre"],
      catalogoGeneralId: json["catalogo_general_id"],
      valor: json["valor"].toString(),
      color: json["color"].toString());

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "catalogo_general_id": catalogoGeneralId,
        "valor": valor,
        "color": color
      };
}
