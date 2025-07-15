import 'dart:developer';
import 'dart:typed_data';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/utils.dart';
import 'package:kiosko/controllers/contacto_controller.dart';
import 'package:kiosko/controllers/direccion_controller.dart';
import 'package:kiosko/controllers/empresa_controller.dart';
import 'package:kiosko/controllers/user_controller.dart';
import 'package:kiosko/models/device_model.dart';
import 'package:kiosko/models/venta_detalle_model.dart';
import 'package:kiosko/utils/main_provider.dart';
import 'package:kiosko/utils/textos.dart';
import 'package:image/image.dart' as img;
import 'package:thermal_printer_plus/thermal_printer.dart';

import '../models/MPago_payment_model.dart';
import '../models/venta_model.dart';
import 'funcion_parser.dart';

class PrintFinal {
  static Future<void> ticketCompra(
      {required PrinterModel? print, required List<Detalles> carrito}) async {
    final profile = await CapabilityProfile.load();

    final generator = Generator(print!.paper!, profile);
    List<int> bytes = [];
    bytes += generator.reset();
    bytes += generator.text(Textos.normalizar('Carrito de compra'),
        linesAfter: 1,
        styles: const PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.row(multiLine: true, [
      PosColumn(
          text: ' Cantidad',
          width: 2,
          styles: const PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
          text: 'Producto',
          width: 7,
          styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: ' Monto',
          width: 3,
          styles: const PosStyles(align: PosAlign.right, bold: true))
    ]);
    bytes += generator.hr();
    double totalizado = 0.0;
    for (var pr in carrito) {
      totalizado += pr.total ?? 0;
      bytes += generator.row(multiLine: true, [
        PosColumn(
            text: "${pr.cantidad}",
            width: 2,
            styles: const PosStyles(align: PosAlign.right)),
        PosColumn(
            text: Textos.normalizar(pr.concepto ?? "Sin nombre"),
            width: 7,
            styles: const PosStyles(align: PosAlign.left)),
        PosColumn(
            text:
                " \$${Textos.moneda(moneda: double.parse(pr.total.toString()))}",
            width: 3,
            styles: const PosStyles(align: PosAlign.right))
      ]);
    }

    bytes += generator.hr();
    bytes += generator.text(
        "Total: \$${Textos.moneda(moneda: double.parse(totalizado.toString()))}",
        linesAfter: 1,
        styles: PosStyles(align: PosAlign.right));
    bytes += generator.text(
        'Usted puede facturar este ticket\nGracias por su compra',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.reset();
    bytes += generator.cut();
    await PrinterManager.instance
        .send(type: print.connectionTypes!, bytes: bytes);
  }

  static Future<void> ventaBoletaje(
      {required PrinterModel type,
      required MainProvider provider,
      required VentaModel venta, required MPagoPaymentModel? transaccion}) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(type.paper!, profile);
    List<int> bytes = [];

    bytes += generator.reset();
    final contactosTicket = await ContactoController.getItemsContacto();
    double precioBase = 0.0;
    List<String> nombreIva = [];
    List<double> iva = [];
    double ventaTotal = 0;
    double ventaCambio = 0;
    final empresa = await EmpresaController.getItems();
    var newEmpresa = empresa
        .firstWhere((element) => element.id == provider.user!.empresaId!);
    final ByteData data = await rootBundle.load('assets/no_img.jpg');
    final obtencionByByte =
        Parser.toUint8List(newEmpresa.file) ?? data.buffer.asUint8List();
    final img.Image imageOriginal = img.decodeImage(obtencionByByte)!;
    bytes += generator.image(imageOriginal);

    bytes += await dataEmpresa(papel: type.paper!);
    debugPrint('${venta.contactoId}');
    bytes += generator.text(
        'Atendido por ${(contactosTicket.where((element) => element.id == provider.user?.vendedorId).firstOrNull)?.nombreCompleto.toString() ?? 'Desconocido'}',
        styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text(
        'Vendedor: ${(contactosTicket.where((element) => element.id == venta.vendedorId).firstOrNull)?.nombreCompleto.toString() ?? 'Desconocido'}',
        styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text(
        'Cliente: ${(contactosTicket.where((element) => element.id == venta.contactoId).firstOrNull)?.nombreCompleto.toString() ?? 'Desconocido'}',
        styles: const PosStyles(align: PosAlign.left),
        linesAfter: 1);

    bytes += generator.text('Creacion: ${venta.fecha}',
        styles: const PosStyles(align: PosAlign.left, bold: true));
    bytes += generator.text('Folio: ${venta.serie}${venta.consecutivo}',
        styles: const PosStyles(align: PosAlign.left, bold: true));

    bytes += generator.hr();

    for (var detalle in venta.detalles) {
      precioBase += double.parse(detalle.subTotal ?? "0");
      if (nombreIva.isNotEmpty) {
        for (var imp in detalle.impuestos) {
          for (var i = 0; i < nombreIva.length; i++) {
            if (nombreIva[i].toLowerCase().contains(imp.nombre.toLowerCase())) {
              iva[i] += double.parse(detalle.impuesto ?? "0");
            } else {
              nombreIva.add(imp.nombre);
              iva.add(double.parse(detalle.impuesto ?? "0"));
            }
          }
        }
      } else {
        for (var imp in detalle.impuestos) {
          nombreIva.add(imp.nombre);
          iva.add(double.parse(detalle.impuesto ?? "0"));
        }
      }
      bytes += generator.row(multiLine: false, [
        PosColumn(
            text: '${detalle.concepto}',
            width: 8,
            styles: const PosStyles(align: PosAlign.left)),
        PosColumn(
            text: '\$${Textos.moneda(moneda: detalle.total!)}',
            width: 4,
            styles: const PosStyles(align: PosAlign.right))
      ]);

      if (detalle.cantidad! > 1) {
        bytes += generator.text(
            '${Textos.moneda(moneda: detalle.cantidad ?? 0)} X \$${Textos.moneda(moneda: double.parse(detalle.precio ?? '0'))} ${detalle.descuentoImporte != 0 ? "- ${Textos.moneda(moneda: detalle.descuentoImporte!)}%" : ""}',
            styles: const PosStyles(align: PosAlign.left, bold: true));
      }

      ventaTotal += double.parse(detalle.total.toString());
    }
    bytes += generator.hr();
    bytes += generator.text('SUBTOTAL: \$${Textos.moneda(moneda: precioBase)}',
        styles: const PosStyles(align: PosAlign.right));
    for (var i = 0; i < nombreIva.length; i++) {
      bytes += generator.text(
          '${nombreIva[i]}: \$${Textos.moneda(moneda: iva[i])}',
          styles: const PosStyles(align: PosAlign.right));
    }
    bytes += generator.text('TOTAL: \$${Textos.moneda(moneda: ventaTotal)}',
        styles: const PosStyles(align: PosAlign.right));

    bytes += generator.hr();
    for (var pago in venta.pagos) {
      bytes += generator.row([
        PosColumn(
            text: '${pago.nombre}',
            width: pago.tipoCambio == 1 ? 8 : 6,
            styles: const PosStyles(align: PosAlign.left)),
        if (pago.tipoCambio != 1)
          PosColumn(
              text: '\$${double.parse(pago.importe.toString())}',
              width: 3,
              styles: const PosStyles(align: PosAlign.right)),
        PosColumn(
            text:
                '\$${double.parse(pago.importe.toString()) * double.parse(pago.tipoCambio.toString())}',
            width: pago.tipoCambio == 1 ? 4 : 3,
            styles: const PosStyles(align: PosAlign.right))
      ]);
      ventaCambio += double.parse(pago.importe.toString()) *
          double.parse(pago.tipoCambio.toString());
    }

    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
          text: 'Entregado: ',
          width: 9,
          styles: const PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
          text: '\$${Textos.moneda(moneda: ventaCambio)}',
          width: 3,
          styles: const PosStyles(align: PosAlign.right, bold: true))
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Cambio: ',
          width: 9,
          styles: const PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
          text:
              '\$${Textos.moneda(moneda: ventaCambio - (double.parse(venta.total.toString())))}',
          width: 3,
          styles: const PosStyles(align: PosAlign.right, bold: true))
    ]);

    bytes += generator.feed(1);
    bytes += generator.text(
        'Usted puede facturar este ticket\nGracias por su compra',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.reset();
    bytes += generator.cut();
    /* if (Preferencias.tipoImpresion) {
      for (var comision
          in venta.detalles.where((element) => element.lineaId != null)) {
        final now = DateTime.now();
        final tiempoSinSegundo = DateFormat('yyyy-MM-dd HH:mm');
        int folioCont = 0;
        folioCont = venta.consecutivo!;
        for (var j = 0; j < comision.cantidad!; j++) {
          bytes += generator.qrcode(
              '${Textos.normalizar(comision.concepto!.toLowerCase())}-${(comision.total! / comision.cantidad!).toString()}-${NumberFormat('0000').format(folioCont)}:${(j + 1)}|${now.add(Duration(days: 1))}|${comision.lineaId}|10:00:00',
              cor: QRCorrection.L,
              size: QRSize.size8);
          bytes += generator.text('${comision.concepto}',
              styles: const PosStyles(align: PosAlign.center));
          bytes += generator.feed(1);
          bytes += generator.text(
              'Importe: \$${Textos.moneda(moneda: comision.total! / comision.cantidad!)}',
              styles: const PosStyles(align: PosAlign.center));
          bytes += generator.text(
              'Folio: ${NumberFormat('0000').format(folioCont)}-${(j + 1)}',
              styles: const PosStyles(align: PosAlign.center));
          bytes += generator.text('Expedido: ${tiempoSinSegundo.format(now)}',
              styles: const PosStyles(align: PosAlign.center));
          bytes += generator.reset();
          bytes += generator.cut();
        }
      }
    } */

    await PrinterManager.instance
        .send(type: type.connectionTypes!, bytes: bytes);
  }

  static Future<void> impresionCorteVenta(
      {required MainProvider provider,
      required List<VentaModel> corteFin,
      required PrinterModel tipo, required }) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(tipo.paper!, profile);
    List<int> bytes = [];
    final user = await UserController.getItem();
    final contactos = await ContactoController.getItemsContacto();
    final empresa = await EmpresaController.getItems();
    var newEmpresa =
        empresa.firstWhere((element) => element.id == user!.empresaId!);
    final direccion = await DireccionController.getItems();
    var newDirecion =
        direccion.firstWhere((element) => element.id == newEmpresa.direccionId);
    double importe = 0;
    double personas = 0;
    double comisionTotal = 0;
    //*listado de pagos generales
    List<String> satCodigo = [];
    List<String> nombrePagos = [];
    List<double> importePagos = [];
    List<double> tipoCambioPagos = [];
    //*listado de ventas
    List<String> ventaDescripcion = [];
    List<double> ventaPrecio = [];
    List<double> ventaCantidad = [];
    List<double> ventaDescuento = [];
    List<int> ventaGrupoProductoId = [];
    List<double> ventaTotal = [];
    //*listado de comisiones
    List<String> comisionNombre = [];
    List<double> comisionMonto = [];
    //*listado de categorias
    DateTime fechaIni = DateTime(9999, 00, 00);
    DateTime fechaFin = DateTime(0000, 00, 00);
    for (var i = 0; i < corteFin.length; i++) {
      if (corteFin[i].folio != null) {
        if (fechaIni.isAfter(DateTime.parse(corteFin[i].fechaApertura!))) {
          fechaIni = DateTime.parse(corteFin[i].fechaApertura!);
        }
        if (fechaFin.isBefore(DateTime.parse(corteFin[i].fechaCierre!))) {
          fechaFin = DateTime.parse(corteFin[i].fechaCierre!);
        }
        if ((corteFin[i].detalles) != []) {
          for (var elemento in corteFin[i].detalles) {
            if (ventaDescripcion.isEmpty) {
              ventaDescripcion.add(elemento.concepto!);
              ventaPrecio.add(double.parse(elemento.precio!));
              ventaCantidad.add(elemento.cantidad!);
              ventaDescuento.add(elemento.descuentoImporte!);
              if (elemento.grupoProductoId != null) {
                ventaGrupoProductoId.add(elemento.grupoProductoId!);
              }

              ventaTotal.add(elemento.total!);
            } else {
              if (ventaDescripcion
                      .indexWhere((element) => element == elemento.concepto) !=
                  -1) {
                ventaCantidad[ventaDescripcion.indexWhere(
                        (element) => element == elemento.concepto)] +=
                    (elemento.cantidad!);
                ventaTotal[ventaDescripcion.indexWhere(
                        (element) => element == elemento.concepto)] +=
                    (elemento.total!);
              } else {
                ventaDescripcion.add(elemento.concepto!);
                ventaPrecio.add(double.parse(elemento.precio!));
                ventaCantidad.add(elemento.cantidad!);
                ventaDescuento.add(elemento.descuentoImporte!);
                if (elemento.grupoProductoId != null) {
                  ventaGrupoProductoId.add(elemento.grupoProductoId!);
                }

                ventaTotal.add(elemento.total!);
              }
            }
            //!comisiones
            /* if (elemento.listaComisionId != null) {
              if (comisionNombre.isEmpty) {
                comisionNombre.add(listaComision
                        .firstWhere(
                            (element) => element.id == elemento.listaComisionId)
                        .nombre ??
                    'Comision Desconocida');
                comisionMonto.add(elemento.comision!);
              } else {
                if (comisionNombre.indexWhere((element) =>
                        element ==
                        (listaComision
                                .firstWhere((element) =>
                                    element.id == elemento.listaComisionId)
                                .nombre ??
                            'Comision Desconocida')) !=
                    -1) {
                  comisionMonto[comisionNombre.indexWhere((element) =>
                      element ==
                      (listaComision
                              .firstWhere((element) =>
                                  element.id == elemento.listaComisionId)
                              .nombre ??
                          'Comision Desconocida'))] += elemento.comision!;
                } else {
                  comisionNombre.add(listaComision
                          .firstWhere((element) =>
                              element.id == elemento.listaComisionId)
                          .nombre ??
                      'Comision Desconocida');
                  comisionMonto.add(elemento.comision!);
                }
              }
            } */
            if (provider.categorias.any((element) => element.numerable == 1)) {
              for (var element
                  in provider.categorias.where((element) => element.numerable == 1)) {
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
        if ((corteFin[i].pagos) != []) {
          for (var elemento in corteFin[i].pagos) {
            if (nombrePagos.isEmpty) {
              satCodigo.add(elemento.codigoSat!);
              nombrePagos.add(elemento.nombre!);
              importePagos
                  .add(double.parse(elemento.importe!) - elemento.cambio!);
              tipoCambioPagos
                  .add(double.tryParse(elemento.tipoCambio.toString()) ?? 0);
            } else {
              if (nombrePagos
                      .indexWhere((element) => element == elemento.nombre) !=
                  -1) {
                importePagos[nombrePagos
                        .indexWhere((element) => element == elemento.nombre)] +=
                    (double.parse(elemento.importe!) - elemento.cambio!);
              } else {
                satCodigo.add(elemento.codigoSat!);
                nombrePagos.add(elemento.nombre!);
                importePagos
                    .add(double.parse(elemento.importe!) - elemento.cambio!);
                tipoCambioPagos
                    .add(double.tryParse(elemento.tipoCambio.toString()) ?? 0);
              }
            }
          }
        }
      }
    }
    log("$ventaGrupoProductoId");
    bytes += generator.reset();

    bytes += generator.setStyles(const PosStyles(codeTable: "CP437"));
    bytes += generator.text('Corte de Caja',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2));
    bytes += generator.text('${newEmpresa.nombre}\n${newEmpresa.rfc}',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('${newEmpresa.eslogan}',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text(
        '${newDirecion.vialidad}, ${newDirecion.numeroExterior} x ${newDirecion.numeroInterior}, Colonia: ${newDirecion.colonia}',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text(
        '${newDirecion.entidad}, ${newDirecion.municipio}, C.P. ${newDirecion.codigoPostal}',
        styles: const PosStyles(align: PosAlign.center),
        linesAfter: 1);
    final nowImpresion = DateTime.now();
    bytes += generator.text(
        'Fecha Impresion:\n${Textos.FechaYMDHMS(fecha: nowImpresion)}',
        styles: const PosStyles(align: PosAlign.center),
        linesAfter: 1);

    bytes += generator.text(
        'Cajero: ${(contactos.where((element) => element.id == user!.vendedorId).firstOrNull)?.nombreCompleto.toString() ?? 'Desconocido'}',
        styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text("${corteFin.first.serie}",
        styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text('Apertura: ${Textos.FechaYMDHMS(fecha: fechaIni)}',
        styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text('Cierre: ${Textos.FechaYMDHMS(fecha: fechaFin)}',
        styles: const PosStyles(align: PosAlign.left), linesAfter: 1);
    bytes += generator.text('VENTAS',
        styles: const PosStyles(align: PosAlign.left, bold: true));
    bytes += generator.row(multiLine: false, [
      PosColumn(
          text: 'Descripcion',
          width: 8,
          styles: const PosStyles(codeTable: "CP437", align: PosAlign.left)),
      /* 
      PosColumn(
          text: 'Precio',
          width: 2,
          styles: const PosStyles(align: PosAlign.right)),
      PosColumn(
          text: 'Cant.',
          width: 2,
          styles: const PosStyles(align: PosAlign.right)),
      PosColumn(
          text: 'Desc.',
          width: 1,
          styles: const PosStyles(align: PosAlign.right)), */
      PosColumn(
          text: 'Total',
          width: 4,
          styles: const PosStyles(align: PosAlign.right))
    ]);
    bytes += generator.hr();
    List<int> grupoid = [];
    List<int> grupoCant = [];
    for (int i = 0; i < ventaDescripcion.length; i++) {
      if (ventaGrupoProductoId.isNotEmpty) {
        if (grupoid.isEmpty) {
          grupoid.add(ventaGrupoProductoId[i]);
          grupoCant.add(ventaCantidad[i].toInt());
        } else {
          int indeccion = grupoid
              .indexWhere((element) => element == ventaGrupoProductoId[i]);
          if (indeccion != -1) {
            grupoCant[indeccion] += ventaCantidad[i].toInt();
          } else {
            grupoid.add(ventaGrupoProductoId[i]);
            grupoCant.add(ventaCantidad[i].toInt());
          }
        }
      }

      bytes += generator.row(multiLine: false, [
        PosColumn(
            text:
                "${ventaCantidad[i].toStringAsFixed(0)} x ${ventaDescripcion[i]}",
            width: 8,
            styles: const PosStyles(codeTable: "CP437", align: PosAlign.left)),
        /* 
        PosColumn(
            text: '\$${ventaPrecio[i].toStringAsFixed(2)}',
            width: 2,
            styles: const PosStyles(align: PosAlign.right)),
        PosColumn(
            text: '${ventaCantidad[i]}',
            width: 2,
            styles: const PosStyles(align: PosAlign.right)),
        PosColumn(
            text: ventaDescuento[i].toStringAsFixed(2),
            width: 1,
            styles: const PosStyles(align: PosAlign.right)), */
        PosColumn(
            text: '\$${ventaTotal[i].toStringAsFixed(2)}',
            width: 4,
            styles: const PosStyles(align: PosAlign.right))
      ]);
    }

    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
          text: 'Venta Total',
          width: 6,
          styles: const PosStyles(
              align: PosAlign.right,
              width: PosTextSize.size1,
              height: PosTextSize.size1)),
      PosColumn(
          text: '\$${importe.toStringAsFixed(2)}',
          width: 6,
          styles: const PosStyles(
              align: PosAlign.right,
              width: PosTextSize.size1,
              height: PosTextSize.size1))
    ]);

    bytes += generator.row([
      PosColumn(
          text: 'Cant: $personas',
          width: 12,
          styles: const PosStyles(align: PosAlign.left, bold: true))
    ]);
    if (grupoid.isNotEmpty) {
      bytes += generator.hr();
      bytes += generator.row(multiLine: false, [
        PosColumn(
            text: "Grupo de producto",
            width: 8,
            styles: const PosStyles(
                bold: true,
                align: PosAlign.left,
                width: PosTextSize.size1,
                height: PosTextSize.size1)),
        PosColumn(
            text: 'Cantidad',
            width: 4,
            styles: const PosStyles(
                align: PosAlign.right,
                width: PosTextSize.size1,
                height: PosTextSize.size1))
      ]);
      for (var j = 0; j < grupoid.length; j++) {
        bytes += generator.row(multiLine: false, [
          PosColumn(
              text: provider.grupoProducto
                      .firstWhereOrNull((element) => element.id == grupoid[j])
                      ?.nombre ??
                  "Sin Grupo",
              width: 8,
              styles: const PosStyles(
                  align: PosAlign.left,
                  width: PosTextSize.size1,
                  height: PosTextSize.size1)),
          PosColumn(
              text: '${grupoCant[j]}',
              width: 4,
              styles: const PosStyles(
                  align: PosAlign.right,
                  width: PosTextSize.size1,
                  height: PosTextSize.size1))
        ]);
      }
    }

    bytes += generator.hr();
    double importePago = 0.0;
    double importeEfectivo = 0.0;
    bytes += generator.row([
      PosColumn(
          text: 'Formas De Pago',
          width: 7,
          styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Importe',
          width: 5,
          styles: const PosStyles(align: PosAlign.right, bold: true))
    ]);
    for (int i = 0; i < nombrePagos.length; i++) {
      importePago += importePagos[i] * tipoCambioPagos[i];
      if (satCodigo[i] == "01") {
        importeEfectivo += importePagos[i];
      }
      bytes += generator.row([
        PosColumn(
            text: nombrePagos[i],
            width: 7,
            styles: const PosStyles(align: PosAlign.left)),
        PosColumn(
            text: '\$${Textos.moneda(moneda: importePagos[i])}',
            width: 5,
            styles: const PosStyles(align: PosAlign.right))
      ]);
    }

    if (comisionTotal != 0) {
      bytes += generator.hr();
      bytes += generator.text(
        'Comisiones',
        styles: const PosStyles(align: PosAlign.left, bold: true),
      );
      for (int i = 0; i < comisionNombre.length; i++) {
        bytes += generator.row([
          PosColumn(
              text: comisionNombre[i],
              width: 7,
              styles: const PosStyles(align: PosAlign.left)),
          PosColumn(
              text: '-\$${comisionMonto[i].toStringAsFixed(2)}',
              width: 5,
              styles: const PosStyles(align: PosAlign.right))
        ]);
      }
    }

    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
          text: 'Importe total',
          width: 6,
          styles: const PosStyles(
              align: PosAlign.right,
              width: PosTextSize.size1,
              height: PosTextSize.size1)),
      PosColumn(
          text: '\$${importePago.toStringAsFixed(2)}',
          width: 6,
          styles: const PosStyles(
              align: PosAlign.right,
              width: PosTextSize.size1,
              height: PosTextSize.size1))
    ]);
    double corteContado = 0.0;
    bytes += generator.text('Arqueo',
        styles: const PosStyles(align: PosAlign.left, bold: true));
    if (comisionTotal != 0) {
      bytes += generator.row([
        PosColumn(
            text: 'Comision Total',
            width: 6,
            styles: const PosStyles(
                align: PosAlign.right,
                width: PosTextSize.size1,
                height: PosTextSize.size1)),
        PosColumn(
            text: '\$${Textos.moneda(moneda: comisionTotal)}',
            width: 6,
            styles: const PosStyles(
                align: PosAlign.right,
                width: PosTextSize.size1,
                height: PosTextSize.size1))
      ]);
      bytes += generator.row([
        PosColumn(
            text: 'Saldo en Caja',
            width: 6,
            styles: const PosStyles(
                align: PosAlign.right,
                width: PosTextSize.size1,
                height: PosTextSize.size1)),
        PosColumn(
            text: '\$${Textos.moneda(moneda: (importe - comisionTotal))}',
            width: 6,
            styles: const PosStyles(
                align: PosAlign.right,
                width: PosTextSize.size1,
                height: PosTextSize.size1))
      ]);
    }
      bytes += generator.row([
        PosColumn(
            text: 'Diferencia',
            width: 6,
            styles: const PosStyles(
                align: PosAlign.right,
                width: PosTextSize.size1,
                height: PosTextSize.size1)),
        PosColumn(
            text:
                '\$${Textos.moneda(moneda: (importeEfectivo - corteContado))}',
            width: 6,
            styles: const PosStyles(
                align: PosAlign.right,
                width: PosTextSize.size1,
                height: PosTextSize.size1))
      ]);
    

    bytes += generator.reset();
    bytes += generator.cut();
    await PrinterManager.instance
        .send(type: tipo.connectionTypes!, bytes: bytes);
  }

  static Future<List<int>> dataEmpresa({required PaperSize papel}) async {
    List<int> bytes = [];
    final now = DateTime.now();
    final String tiempoImpresion = Textos.FechaYMDHMS(fecha: now);
    final user = await UserController.getItem();
    final empresa = await EmpresaController.getItems();
    var newEmpresa =
        empresa.firstWhere((element) => element.id == user!.empresaId!);
    final dirTicket =
        await DireccionController.getItem(newEmpresa.direccionId!);

    final profile = await CapabilityProfile.load();
    final generator = Generator(papel, profile);

    bytes += generator.text('${newEmpresa.razonSocial} S.A. DE C.V.',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text(
        '${dirTicket?.vialidad ?? ""}, ${dirTicket?.numeroExterior ?? ""} entre ${dirTicket?.cruzamiento1 ?? ""} x ${dirTicket?.cruzamiento2 ?? ""}, Colonia: ${dirTicket?.colonia ?? ""}',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text(
        '${dirTicket?.entidad ?? ""}, ${dirTicket?.localidad ?? ""}, CP ${dirTicket?.codigoPostal ?? ""}',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('FECHA: $tiempoImpresion',
        styles: const PosStyles(align: PosAlign.center), linesAfter: 1);
    return bytes;
  }
}
