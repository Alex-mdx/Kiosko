class ProductoDemoModel {
  int id;
  String concepto;
  double cantidad;
  double descuento;
  double precio;
  double total;

  ProductoDemoModel(
      {required this.id,
      required this.concepto,
      required this.cantidad,
      required this.descuento,
      required this.precio,
      required this.total});

  ProductoDemoModel copyWith(
          {int? id,
          String? concepto,
          double? cantidad,
          double? descuento,
          double? precio,
          double? total}) =>
      ProductoDemoModel(
          id: id ?? this.id,
          concepto: concepto ?? this.concepto,
          cantidad: cantidad ?? this.cantidad,
          descuento: descuento ?? this.descuento,
          precio: precio ?? this.precio,
          total: total ?? this.total);

  factory ProductoDemoModel.fromJson(Map<String, dynamic> json) =>
      ProductoDemoModel(
          id: int.parse(json["id"]),
          concepto: json["concepto"],
          cantidad: double.parse(json["cantidad"] ?? "0"),
          descuento: double.parse(json["descuento"] ?? "0"),
          precio: double.parse(json["precio"] ?? "0"),
          total: double.parse(json["total"] ?? "0"));

  Map<String, dynamic> toJson() => {
        "id": id,
        "concepto": concepto,
        "cantidad": cantidad,
        "descuento": descuento,
        "precio": precio,
        "total": total
      };
}
