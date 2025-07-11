import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosko/utils/main_provider.dart';

import '../models/producto_model.dart';
import '../models/venta_detalle_model.dart';

class GeneradorCompras {
  static Future<void> agregarCarrito(
      MainProvider provider,
      ProductoModel productoIndex,
      String? newPrecio,
      List<SerieModel> series,
      String notas,
      List<int> modificadores) async {
    bool coincidencia = false;

    double impuestoAplicado = productoIndex.impuestos.isEmpty
        ? 1
        : ((double.parse(productoIndex.impuestos.firstOrNull?.tasaOCuota ??
                            "0") >
                        0
                    ? double.parse(
                        productoIndex.impuestos.firstOrNull?.tasaOCuota ?? "0")
                    : 1) +
                100) /
            100;
    print("impuesto: $impuestoAplicado");
    double? precioBase = newPrecio != null
        ? newPrecio == "0"
            ? 0
            : double.parse(newPrecio) / impuestoAplicado
        : null;
    for (var i = 0; i < provider.listaDetalle.length; i++) {
      if (provider.listaDetalle[i].productoId == productoIndex.id) {
        double cantidadTemp = series.isNotEmpty
            ? double.parse(series.length.toString())
            : provider.listaDetalle[i].cantidad! + 1;

        double precio = double.parse(newPrecio ??
            productoIndex.precio ??
            "0");
        if (tienenMismosElementos(
            provider.listaDetalle[i].modificador, modificadores)) {
          Detalles ventaDetalle = provider.listaDetalle[i].copyWith(
              comision: 0,
              cantidad: cantidadTemp,
              precio: precio.toStringAsFixed(4),
              serie: series,
              subTotal: ((double.parse(newPrecio != null ? precioBase.toString() : productoIndex.precioBase ?? "0") * cantidadTemp) *
                      (1 - (provider.listaDetalle[i].descuentoImporte! / 100)))
                  .toStringAsFixed(4),
              impuesto: (newPrecio != null
                      ? ((precio * cantidadTemp) - (precioBase! * cantidadTemp))
                      : ((double.parse(provider.listaDetalle[i].precio ?? "0") *
                                  cantidadTemp) -
                              (double.parse(provider.listaDetalle[i].precioBase ?? "0") *
                                  cantidadTemp)) *
                          (1 - (provider.listaDetalle[i].descuentoImporte! / 100)))
                  .toStringAsFixed(4),
              total: (((precio * cantidadTemp) * (1 - (provider.listaDetalle[i].descuentoImporte! / 100)))));
          log('${ventaDetalle.toJson()}');
          provider.listaDetalle[i] = ventaDetalle;
          coincidencia = true;
        }
      }
    }
    if (coincidencia == false) {
      
      double precio = double.parse(
          newPrecio ?? productoIndex.precio ?? "0");
      Detalles ventaDetalle = Detalles(
          almacenId: provider.user?.almacenId,
          categoriaId: productoIndex.categoriaId,
          productoId: productoIndex.id,
          tipoProductoId: productoIndex.tipoProducto,
          grupoProductoId: productoIndex.grupoProductoId,
          concepto: productoIndex.descripcion,
          listaComisionId:null,
          comision: 0,
          notas: notas,
          cantidad:
              series.isNotEmpty ? double.parse(series.length.toString()) : 1,
          precio: precio.toStringAsFixed(4),
          precioBase: (newPrecio != null
                  ? precioBase!
                  : double.parse(productoIndex.precioBase!))
              .toStringAsFixed(4),
          descuentoImporte: 0,
          costo: productoIndex.costoEstandar,
          importeCosto: productoIndex.ultimoCosto,
          subTotal: ((newPrecio != null
                  ? precioBase!
                  : double.parse(productoIndex.precioBase!)*(series.isNotEmpty ? double.parse(series.length.toString()) : 1)))
              .toStringAsFixed(4),
          impuesto: ((newPrecio != null
                  ? (precioBase! * impuestoAplicado) - precioBase
                  : precio - double.parse(productoIndex.precioBase ?? "0")) * (series.isNotEmpty ? double.parse(series.length.toString()) : 1))
              .toStringAsFixed(4),
          retencion: 0,
          total: precio *
              (series.isNotEmpty ? double.parse(series.length.toString()) : 1),
          unidadId: productoIndex.unidadId,
          lineaId: productoIndex.lineaId,
          press: 0,
          serie: series,productoEquivalenteId: productoIndex.productoEquivalencia?.id,
          impuestos: productoIndex.impuestos,
          modificador: modificadores);
      log('${ventaDetalle.toJson()}');
      provider.listaDetalle.add(ventaDetalle);
    }
    provider.totalSumatoria();
  }

  static Future<void> verificarCarrito(MainProvider provider,
      ProductoModel producto, BuildContext context) async {
    int? indiceCompra;
    bool variaModGlobal =
        (producto.variantes.isNotEmpty || producto.modificadores.isNotEmpty);
    bool serieGlobal = (producto.controlarSerie == 1 ||
        producto.productoEquivalencia?.controlarSerie == 1);
    /* if (variaModGlobal || serieGlobal) {
      if (variaModGlobal) {
        await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => DialogProductoDetalle(producto: producto));
        indiceCompra = provider.listaDetalle
            .indexWhere((element) => element.productoId == producto.id);
      }
      if (serieGlobal) {
        provider.prioridadBarcode = 1;
        await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => SDialogSeries(
                provider: provider,
                producto: producto,
                indexSerie: indiceCompra));
      }
    } else { */
      await GeneradorCompras.agregarCarrito(
          provider, producto, null, [], "", []);
    //}
  }

  static bool tienenMismosElementos(List<int> lista1, List<int> lista2) {
    if (lista1.length != lista2.length) return false;

    // Creamos copias para no modificar las listas originales
    final lista1Ordenada = List<int>.from(lista1)..sort();
    final lista2Ordenada = List<int>.from(lista2)..sort();

    return lista1Ordenada.toString() == lista2Ordenada.toString();
  }
}
