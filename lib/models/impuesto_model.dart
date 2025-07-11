class ImpuestosModel {
  int id;
  String nombre;
  String tasaOCuota;

  ImpuestosModel(
      {required this.id, required this.nombre, required this.tasaOCuota});

  ImpuestosModel copyWith({int? id, String? nombre, String? tasaOCuota}) =>
      ImpuestosModel(
          id: id ?? this.id,
          nombre: nombre ?? this.nombre,
          tasaOCuota: tasaOCuota ?? this.tasaOCuota);

  factory ImpuestosModel.fromJson(Map<String, dynamic> json) => ImpuestosModel(
      id: json["id"], nombre: json["nombre"], tasaOCuota: json["tasa_o_cuota"]);

  Map<String, dynamic> toJson() =>
      {"id": id, "nombre": nombre, "tasa_o_cuota": tasaOCuota};
}
