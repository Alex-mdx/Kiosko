class CatalogoGeneralModel {
  int id;
  String nombre;
  int tipo;

  CatalogoGeneralModel({required this.id, required this.nombre, required this.tipo});

  CatalogoGeneralModel copyWith({int? id, String? nombre, int? tipo}) =>
      CatalogoGeneralModel(
          id: id ?? this.id,
          nombre: nombre ?? this.nombre,
          tipo: tipo ?? this.tipo);

  factory CatalogoGeneralModel.fromJson(Map<String, dynamic> json) =>
      CatalogoGeneralModel(
          id: json["id"], nombre: json["nombre"], tipo: json["tipo"]);

  Map<String, dynamic> toJson() => {"id": id, "nombre": nombre, "tipo": tipo};
}