class FamiliaProducto {
  int id;
  String nombre;

  FamiliaProducto({required this.id, required this.nombre});

  FamiliaProducto copyWith({int? id, String? nombre}) =>
      FamiliaProducto(id: id ?? this.id, nombre: nombre ?? this.nombre);

  factory FamiliaProducto.fromJson(Map<String, dynamic> json) =>
      FamiliaProducto(id: json["id"], nombre: json["nombre"]);

  Map<String, dynamic> toJson() => {"id": id, "nombre": nombre};
}
