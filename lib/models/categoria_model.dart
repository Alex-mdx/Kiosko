class CategoriaModel {
  int id;
  String nombre;
  int databaseId;
  int press;
  int numerable;

  CategoriaModel(
      {required this.id,
      required this.nombre,
      required this.databaseId,
      required this.press,
      required this.numerable});

  CategoriaModel copyWith(
          {int? id,
          String? nombre,
          int? databaseId,
          int? press,
          int? numerable}) =>
      CategoriaModel(
          id: id ?? this.id,
          nombre: nombre ?? this.nombre,
          databaseId: databaseId ?? this.databaseId,
          press: press ?? this.press,
          numerable: numerable ?? this.numerable);

  factory CategoriaModel.fromJson(Map<String, dynamic> json) => CategoriaModel(
      id: json["id"],
      nombre: json["nombre"],
      databaseId: json["database_id"],
      press: json["press"] ?? 0,
      numerable: json["numerable"] ?? 0);

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "database_id": databaseId,
        "press": press,
        "numerable": numerable
      };
}
