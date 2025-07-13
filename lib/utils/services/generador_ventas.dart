import 'dart:developer';

import 'package:get/get.dart';

import '../../models/categoria_model.dart';
import '../../models/cortes_model.dart';
import '../../models/venta_model.dart';

class GeneradorVentas {
  static List<VentaCorteModel> ventaCorte({required List<VentaModel> ventas}) {
    List<VentaCorteModel> ventaCorte = [];
    for (var i = 0; i < ventas.length; i++) {
      if (ventas[i].folio != null) {
        if ((ventas[i].detalles) != []) {
          for (var elemento in ventas[i].detalles) {
            if (ventaCorte.isEmpty) {
              var tempVenta = VentaCorteModel(
                  descripcion: elemento.concepto!,
                  precio: double.parse(elemento.precio!),
                  cantidad: elemento.cantidad!,
                  descuento: elemento.descuentoImporte!,
                  total: elemento.total!);
              ventaCorte.add(tempVenta);
            } else {
              var index = ventaCorte.indexWhere(
                  (element) => element.descripcion == elemento.concepto);
              if (index != -1) {
                var tempModel = ventaCorte[index].copyWith(
                    cantidad: ventaCorte[index].cantidad + (elemento.cantidad!),
                    total: ventaCorte[index].total + (elemento.total!));
                ventaCorte[index] = tempModel;
              } else {
                var tempVenta = VentaCorteModel(
                    descripcion: elemento.concepto!,
                    precio: double.parse(elemento.precio!),
                    cantidad: elemento.cantidad!,
                    descuento: elemento.descuentoImporte!,
                    total: elemento.total!);
                ventaCorte.add(tempVenta);
              }
            }
          }
        }
      }
    }
    return ventaCorte;
  }

  static List<PagosCorteModel> pagoCorte({required List<VentaModel> ventas}) {
    List<PagosCorteModel> pagoCorte = [];
    for (var i = 0; i < ventas.length; i++) {
      if (ventas[i].folio != null) {
        if ((ventas[i].pagos) != []) {
          for (var elemento in ventas[i].pagos) {
            if (pagoCorte.isEmpty) {
              var pagoTemp = PagosCorteModel(
                  nombre: elemento.nombre!,
                  importe: double.parse(elemento.importe!) - elemento.cambio!);
              pagoCorte.add(pagoTemp);
            } else {
              var index = pagoCorte
                  .indexWhere((element) => element.nombre == elemento.nombre);
              if (index != -1) {
                var pagoTemp = pagoCorte[index].copyWith(
                    importe: pagoCorte[index].importe +
                        (double.parse(elemento.importe!) - elemento.cambio!));
                pagoCorte[index] = pagoTemp;
              } else {
                var pagoTemp = PagosCorteModel(
                    nombre: elemento.nombre!,
                    importe:
                        double.parse(elemento.importe!) - elemento.cambio!);
                pagoCorte.add(pagoTemp);
              }
            }
          }
        }
      }
    }
    return pagoCorte;
  }

  ///Devuelve el total de la venta, y el total de la venta solo contando el efectivo
  static List<double> corteET({required List<VentaModel> ventas}) {
    var importePago = 0.0;
    var importeEfectivo = 0.0;
    for (var i = 0; i < ventas.length; i++) {
      if (ventas[i].folio != null) {
        if ((ventas[i].pagos) != []) {
          for (var elemento in ventas[i].pagos) {
            importePago += (double.parse(elemento.importe!) - elemento.cambio!);
            if (elemento.codigoSat == "01") {
              importeEfectivo +=
                  (double.parse(elemento.importe!) - elemento.cambio!);
            }
          }
        }
      }
    }
    return [importeEfectivo, importePago];
  }

  static List<GrupoCorteModel> grupoCorte({required List<VentaModel> ventas}) {
    List<GrupoCorteModel> grupoCorte = [];
    for (var i = 0; i < ventas.length; i++) {
      if (ventas[i].folio != null) {
        for (var elemento in ventas[i].detalles) {
          if (elemento.grupoProductoId != null) {
            if (grupoCorte.isEmpty) {
              var grupoTemp = GrupoCorteModel(
                  id: elemento.grupoProductoId!,
                  cantidad: elemento.cantidad!.toInt());
              grupoCorte.add(grupoTemp);
            } else {
              int indeccion = grupoCorte.indexWhere(
                  (element) => element.id == elemento.grupoProductoId);
              if (indeccion != -1) {
                var tempgrupo = grupoCorte[indeccion].copyWith(
                    cantidad: grupoCorte[indeccion].cantidad +
                        elemento.cantidad!.toInt());
                grupoCorte[indeccion] = tempgrupo;
              } else {
                var grupoTemp = GrupoCorteModel(
                    id: elemento.grupoProductoId!,
                    cantidad: elemento.cantidad!.toInt());
                grupoCorte.add(grupoTemp);
              }
            }
          }
        }
      }
    }
    return grupoCorte;
  }

  /* static List<ComisionCorteModel> comisionCorte(
      {required List<VentaModel> ventas,
      required List<ComisionModel> comision}) {
    List<ComisionCorteModel> comisionCorte = [];
    var listaComision = comision;
    for (var i = 0; i < ventas.length; i++) {
      if (ventas[i].folio != null) {
        if ((ventas[i].detalles) != []) {
          for (var elemento in ventas[i].detalles) {
            if (elemento.listaComisionId != null) {
              if (comisionCorte.isEmpty) {
                var tempComision = ComisionCorteModel(
                    nombre: listaComision
                            .firstWhere((element) =>
                                element.id == elemento.listaComisionId)
                            .nombre ??
                        'Comision Desconocida',
                    monto: elemento.comision!);
                comisionCorte.add(tempComision);
              } else {
                var index = comisionCorte.indexWhere((element) =>
                    element.nombre ==
                    (listaComision
                            .firstWhereOrNull(
                                (c) => c.id == elemento.listaComisionId)
                            ?.nombre ??
                        'Comision Desconocida'));
                if (index != -1) {
                  var comisionModel = comisionCorte[index].copyWith(
                      monto: comisionCorte[index].monto + elemento.comision!);
                  comisionCorte[index] = comisionModel;
                } else {
                  var tempComision = ComisionCorteModel(
                      nombre: listaComision
                              .firstWhere((element) =>
                                  element.id == elemento.listaComisionId)
                              .nombre ??
                          'Comision Desconocida',
                      monto: elemento.comision!);
                  comisionCorte.add(tempComision);
                }
              }
            }
          }
        }
      }
    }
    return comisionCorte;
  } */

  ///Devuelve el importe total de las ventas, la comision total cobrada y el total de las personas contadas por boleto
  static List<double> sumatoriasICP(
      {required List<VentaModel> ventas,
      required List<CategoriaModel> categoria}) {
    double personas = 0.0;
    double importe = 0.0;
    double comisionTotal = 0.0;
    for (var i = 0; i < ventas.length; i++) {
      if (ventas[i].folio != null) {
        if ((ventas[i].detalles) != []) {
          for (var elemento in ventas[i].detalles) {
            if (categoria.any((element) => element.numerable == 1)) {
              for (var element
                  in categoria.where((element) => element.numerable == 1)) {
                if (element.id == elemento.categoriaId) {
                  personas += elemento.cantidad!;
                }
              }
            } else {
              personas += elemento.cantidad!;
            }
            importe += elemento.total!;
            comisionTotal += elemento.comision!;
          }
        }
      }
    }
    return [importe, comisionTotal, personas];
  }

  /* static List<BilleteCorteModel> billetajeCorte(
      {required List<BilletajeModel> moneda}) {
    List<BilleteCorteModel> billetaje = [];
    final newBillete =
        moneda.where((element) => double.parse(element.monto.toString()) > 0);
    for (var billete in newBillete.toSet()) {
      log("${billete.toJson()}");

      if (billetaje.isEmpty) {
        var tempBillete = BilleteCorteModel(
            monto: "\$${billete.nombre!} x ${billete.monto}",
            importe:
                double.parse(billete.nombre!) * (billete.monto)!.toDouble());
        billetaje.add(tempBillete);
      } else {
        final index = billetaje.indexWhere((element) =>
            element.monto == "\$${billete.nombre!} x ${billete.monto}");
        if (index != -1) {
          var tempModel = billetaje[index].copyWith(
              importe: billetaje[index].importe +
                  (double.parse(billete.nombre!) *
                      (billete.monto)!.toDouble()));
          billetaje[index] = tempModel;
        } else {
          var tempBillete = BilleteCorteModel(
              monto: "\$${billete.nombre!} x ${billete.monto}",
              importe:
                  double.parse(billete.nombre!) * (billete.monto)!.toDouble());
          billetaje.add(tempBillete);
        }
      }
    }
    return billetaje;
  }
 */
  /* static double corteTotal({required List<BilletajeModel> moneda}) {
    double corte = 0.0;
    final newBillete =
        moneda.where((element) => double.parse(element.monto.toString()) > 0);
    for (var billete in newBillete.toSet()) {
      corte += double.parse(billete.nombre!) * (billete.monto)!.toDouble();
    }
    return corte;
  } */

  static List<DateTime> fechas({required List<VentaModel> ventas}) {
    DateTime fechaIni = DateTime(9999, 00, 00);
    DateTime fechaFin = DateTime(0000, 00, 00);
    for (var i = 0; i < ventas.length; i++) {
      if (ventas[i].folio != null) {
        if (fechaIni.isAfter(DateTime.parse(ventas[i].fechaApertura!))) {
          fechaIni = DateTime.parse(ventas[i].fechaApertura!);
        }
        if (fechaFin.isBefore(DateTime.parse(ventas[i].fechaCierre!))) {
          fechaFin = DateTime.parse(ventas[i].fechaCierre!);
        }
      }
    }
    return [fechaIni, fechaFin];
  }
}
