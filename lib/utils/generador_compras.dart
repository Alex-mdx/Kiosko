import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kiosko/controllers/user_controller.dart';
import 'package:kiosko/models/venta_pago_model.dart';
import 'package:kiosko/utils/main_provider.dart';
import 'package:kiosko/utils/textos.dart';
import 'package:oktoast/oktoast.dart';

import '../controllers/corte_cobro_propio_controller.dart';
import '../controllers/operacion_controller.dart';
import '../models/producto_model.dart';
import '../models/usuario_model.dart';
import '../models/venta_detalle_model.dart';
import '../models/venta_model.dart';

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

        double precio = double.parse(newPrecio ?? productoIndex.precio ?? "0");
        if (tienenMismosElementos(
            provider.listaDetalle[i].modificador, modificadores)) {
          Detalles ventaDetalle = provider.listaDetalle[i].copyWith(
              comision: 0,
              cantidad: cantidadTemp,
              precio: precio.toStringAsFixed(4),
              serie: series,
              subTotal: ((double.parse(newPrecio != null ? precioBase.toString() : productoIndex.precioBase ?? "0") *
                          cantidadTemp) *
                      (1 - (provider.listaDetalle[i].descuentoImporte! / 100)))
                  .toStringAsFixed(4),
              impuesto: (newPrecio != null
                      ? ((precio * cantidadTemp) - (precioBase! * cantidadTemp))
                      : ((double.parse(provider.listaDetalle[i].precio ?? "0") *
                                  cantidadTemp) -
                              (double.parse(
                                      provider.listaDetalle[i].precioBase ?? "0") *
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
      double precio = double.parse(newPrecio ?? productoIndex.precio ?? "0");
      Detalles ventaDetalle = Detalles(
          almacenId: provider.user?.almacenId,
          categoriaId: productoIndex.categoriaId,
          productoId: productoIndex.id,
          tipoProductoId: productoIndex.tipoProducto,
          grupoProductoId: productoIndex.grupoProductoId,
          concepto: productoIndex.descripcion,
          listaComisionId: null,
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
                  : double.parse(productoIndex.precioBase!) *
                      (series.isNotEmpty
                          ? double.parse(series.length.toString())
                          : 1)))
              .toStringAsFixed(4),
          impuesto: ((newPrecio != null
                      ? (precioBase! * impuestoAplicado) - precioBase
                      : precio -
                          double.parse(productoIndex.precioBase ?? "0")) *
                  (series.isNotEmpty ? double.parse(series.length.toString()) : 1))
              .toStringAsFixed(4),
          retencion: 0,
          total: precio * (series.isNotEmpty ? double.parse(series.length.toString()) : 1),
          unidadId: productoIndex.unidadId,
          lineaId: productoIndex.lineaId,
          press: 0,
          serie: series,
          productoEquivalenteId: productoIndex.productoEquivalencia?.id,
          impuestos: productoIndex.impuestos,
          modificador: modificadores);
      log('${ventaDetalle.toJson()}');
      provider.listaDetalle.add(ventaDetalle);
    }
    
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
    await GeneradorCompras.agregarCarrito(provider, producto, null, [], "", []);
    //}
  }

  static bool tienenMismosElementos(List<int> lista1, List<int> lista2) {
    if (lista1.length != lista2.length) return false;

    // Creamos copias para no modificar las listas originales
    final lista1Ordenada = List<int>.from(lista1)..sort();
    final lista2Ordenada = List<int>.from(lista2)..sort();

    return lista1Ordenada.toString() == lista2Ordenada.toString();
  }

  static Future<VentaModel> pagar(MainProvider provider, PagoModel pago) async {
    final now = DateTime.now();
    final fechaAMD = Textos.FechaYMD(fecha: now);
    final fechaActual = Textos.FechaYMDHMS(fecha: now);

    VentaModel vender = provider.cortePropio!.copyWith(
        consecutivo: provider.user!.consecutivo,
        contactoId: provider.user?.clienteId,
        razonSocialId: provider.user!.razonSocialId,
        vendedorId: provider.user?.vendedorId,
        fecha: fechaAMD,
        cuentaBancariaId: provider.user!.cuentaBancariaId,
        cerrado: 0,
        serie:
            'C${provider.user!.cuentaBancariaId}${provider.user!.serieVenta}',
        total: (double.parse(
                (provider.cortePropio?.total ?? 0).toStringAsFixed(2)) +
            double.parse(provider.totalSumatoria().toStringAsFixed(2))),
        comision: 0,
        fechaCierre: fechaActual,
        detalles: provider.listaDetalle,
        pagos: [pago]);
    VentaModel ventaTemp = vender;
    if (provider.internet) {
      ventaTemp = await SqlOperaciones.pagoVenta(vender);
    } else {
      ventaTemp = vender.copyWith(
          cerrado: 1,
          status: 0,
          errorVenta: "Sin internet o sin opcion de venta con internet");
      showToastWidget(const DialogCompra(response: ""),
          duration: const Duration(seconds: 4),
          position: const ToastPosition(align: Alignment.center),
          dismissOtherToast: true);
    }
    log("${ventaTemp.toJson()}");
    //if (ventaTemp.status == 0) {// Si hay un error de servicios efectuara los pagos
      await SQLHelperCortePropio.updateLastUser(ventaTemp);
      UsuarioModel user =
          provider.user!.copyWith(consecutivo: provider.user!.consecutivo! + 1);
      await UserController.updateUser(user);
      provider.user = user;
      VentaModel ventaNuevo = VentaModel(
          apiKeyId: provider.user!.id,
          consecutivo: provider.user!.consecutivo,
          sincronizado: 0,
          contactoId: provider.user!.clienteId,
          vendedorId: provider.user!.vendedorId,
          userId: provider.user!.userId,
          empresaId: provider.user!.empresaId,
          almacenId: provider.user!.almacenId,
          sucursalId: provider.user!.sucursalId,
          moneda: provider.user!.moneda,
          cuentaBancariaId: provider.user!.cuentaBancariaId,
          metodoPago: null,
          razonSocialId: provider.user!.razonSocialId,
          fecha: null,
          serie:
              'C${provider.user!.cuentaBancariaId}${provider.user!.serieVenta}',
          total: 0,
          comision: 0,
          tipoCambio: 0,
          formaPagoId: null,
          cerrado: 0,
          fechaApertura: fechaActual,
          transaccion: provider.cortePropio!.transaccion,
          fechaCierre: null,
          detalles: [],
          pagos: []);
      await SQLHelperCortePropio.insertCorte(ventaNuevo);
      provider.corteinterno = await SQLHelperCortePropio.getItems();
      provider.cortePropio = ventaNuevo;
    //}

    return ventaTemp;
  }
}
