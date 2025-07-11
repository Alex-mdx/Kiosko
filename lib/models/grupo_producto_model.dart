class GrupoProductoModel {
  int? id;
  String? nombre;

  GrupoProductoModel({required this.id, required this.nombre});

  GrupoProductoModel copyWith({int? id, String? nombre}) =>
      GrupoProductoModel(id: id ?? this.id, nombre: nombre ?? this.nombre);

  factory GrupoProductoModel.fromJson(Map<String, dynamic> json) =>
      GrupoProductoModel(id: json["id"], nombre: json["nombre"]);

  Map<String, dynamic> toJson() => {"id": id, "nombre": nombre};
}
