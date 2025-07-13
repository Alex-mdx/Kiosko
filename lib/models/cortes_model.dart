class VentaCorteModel {
  String descripcion;
  double precio;
  double cantidad;
  double descuento;
  double total;

  VentaCorteModel({
    required this.descripcion,
    required this.precio,
    required this.cantidad,
    required this.descuento,
    required this.total,
  });

  VentaCorteModel copyWith({
    String? descripcion,
    double? precio,
    double? cantidad,
    double? descuento,
    double? total,
  }) =>
      VentaCorteModel(
          descripcion: descripcion ?? this.descripcion,
          precio: precio ?? this.precio,
          cantidad: cantidad ?? this.cantidad,
          descuento: descuento ?? this.descuento,
          total: total ?? this.total);

  factory VentaCorteModel.fromJson(Map<String, dynamic> json) =>
      VentaCorteModel(
          descripcion: json["descripcion"],
          precio: double.parse(json["precio"]),
          cantidad: double.parse(json["cantidad"]),
          descuento: double.parse(json["descuento"]),
          total: double.parse(json["total"]));

  Map<String, dynamic> toJson() => {
        "descripcion": descripcion,
        "precio": precio,
        "cantidad": cantidad,
        "descuento": descuento,
        "total": total
      };
}

class ComisionCorteModel {
  String nombre;
  double monto;

  ComisionCorteModel({required this.nombre, required this.monto});

  ComisionCorteModel copyWith({String? nombre, double? monto}) =>
      ComisionCorteModel(
          nombre: nombre ?? this.nombre, monto: monto ?? this.monto);

  factory ComisionCorteModel.fromJson(Map<String, dynamic> json) =>
      ComisionCorteModel(
          nombre: json["nombre"], monto: double.parse(json["monto"]));

  Map<String, dynamic> toJson() => {"nombre": nombre, "monto": monto};
}

class GrupoCorteModel {
  int id;
  int cantidad;

  GrupoCorteModel({required this.id, required this.cantidad});

  GrupoCorteModel copyWith({int? id, int? cantidad}) =>
      GrupoCorteModel(id: id ?? this.id, cantidad: cantidad ?? this.cantidad);

  factory GrupoCorteModel.fromJson(Map<String, dynamic> json) =>
      GrupoCorteModel(id: json["id"], cantidad: json["cantidad"]);

  Map<String, dynamic> toJson() => {"id": id, "cantidad": cantidad};
}

class PagosCorteModel {
  String nombre;
  double importe;

  PagosCorteModel({required this.nombre, required this.importe});

  PagosCorteModel copyWith({String? nombre, double? importe}) =>
      PagosCorteModel(
          nombre: nombre ?? this.nombre, importe: importe ?? this.importe);

  factory PagosCorteModel.fromJson(Map<String, dynamic> json) =>
      PagosCorteModel(
          nombre: json["nombre"], importe: double.parse(json["importe"]));

  Map<String, dynamic> toJson() => {"nombre": nombre, "importe": importe};
}

class BilleteCorteModel {
  String monto;
  double importe;

  BilleteCorteModel({required this.monto, required this.importe});

  BilleteCorteModel copyWith({String? monto, double? importe}) =>
      BilleteCorteModel(
          monto: monto ?? this.monto, importe: importe ?? this.importe);

  factory BilleteCorteModel.fromJson(Map<String, dynamic> json) =>
      BilleteCorteModel(
          monto: json["monto"], importe: double.parse(json["importe"]));

  Map<String, dynamic> toJson() => {"monto": monto, "importe": importe};
}
