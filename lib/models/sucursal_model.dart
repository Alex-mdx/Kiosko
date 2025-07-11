class SucursalModel {
  int id;
  String? nombre;
  int? empresaId;
  int? direccionId;

  SucursalModel(
      {required this.id,
      required this.nombre,
      required this.empresaId,
      required this.direccionId});

  SucursalModel copyWith(
          {int? id,
          String? nombre,
          int? empresaId,
          int? direccionId}) =>
      SucursalModel(
          id: id ?? this.id,
          nombre: nombre ?? this.nombre,
          empresaId: empresaId ?? this.empresaId,
          direccionId: direccionId ?? this.direccionId);

  factory SucursalModel.fromJson(Map<String, dynamic> json) => SucursalModel(
      id: json["id"],
      nombre: json["nombre"],
      empresaId: json["empresa_id"],
      direccionId: json["direccion_id"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "empresa_id": empresaId,
        "direccion_id": direccionId
      };
}
