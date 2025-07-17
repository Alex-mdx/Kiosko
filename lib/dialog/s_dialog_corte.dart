import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosko/utils/main_provider.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../controllers/corte_cobro_propio_controller.dart';
import '../controllers/operacion_controller.dart';
import '../models/venta_model.dart';
import '../theme/app_colors.dart';
import '../utils/print_final.dart';
import '../utils/services/dialog_services.dart';
import '../utils/services/generador_ventas.dart';
import '../utils/services/impresora_configuracion.dart';
import '../utils/services/navigation_service.dart';
import '../utils/textos.dart';
import 's_dialog_body_usb.dart';

class DialogCorte extends StatelessWidget {
  final List<VentaModel> ventas;
  final bool visualizar;
  const DialogCorte(
      {required this.ventas, required this.visualizar, super.key});

  @override
  Widget build(BuildContext context) {
    final proNavegacion = Provider.of<MainProvider>(context);
    final ScrollController ventaScroll = ScrollController();
    final ScrollController pagosScroll = ScrollController();
    final ScrollController grupoScroll = ScrollController();
    /* final ScrollController conteoScroll = ScrollController();
    final ScrollController comisionScroll = ScrollController(); */

    var ventaCorte = GeneradorVentas.ventaCorte(ventas: ventas);
    var agrupados = GeneradorVentas.grupoCorte(ventas: ventas);
    //var comision = GeneradorVentas.comisionCorte(ventas: ventas, comision: proNavegacion.listaComision);
    var pagos = GeneradorVentas.pagoCorte(ventas: ventas);
    //var conteo = GeneradorVentas.billetajeCorte(moneda: proNavegacion.billeteModel);
    var ICP = GeneradorVentas.sumatoriasICP(
        ventas: ventas, categoria: proNavegacion.categorias);
    var ventaET = GeneradorVentas.corteET(ventas: ventas);
    //var corteContado =GeneradorVentas.corteTotal(moneda: proNavegacion.billeteModel);

    Future<void> generarCorte(List<VentaModel> items) async {
      //*enviar pago
      final ventaSesion = (await SQLHelperCortePropio.getItem(
              proNavegacion.cortePropio!.transaccion!))
          .where((element) =>
              (element.sincronizado == 0) && (element.cerrado == 1))
          .toList();
      if (ventaSesion.isNotEmpty) {
        if (proNavegacion.internet) {
          await SqlOperaciones.pagoTotal(
              proNavegacion.cortePropio!.transaccion!);
        } else {
          showToast('Guardo el corte internamente');
        }
      } else {
        await SQLHelperCortePropio.deleteCorteSincronizado(
            proNavegacion.cortePropio!.transaccion!);
        showToast('Corte Sincronizado');
      }
      await SQLHelperCortePropio.deleteCorteItem(
          proNavegacion.cortePropio!.transaccion!);
      proNavegacion.listaDetalle.clear();
    }

    return Dialog(
        child: Container(
            color: LightThemeColors.background,
            width: 70.w,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              AppBar(
                  centerTitle: true,
                  title: Text('Resumen del Corte',
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.bold))),
              Expanded(
                  child: SingleChildScrollView(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: [
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 1.w),
                                child: Row(children: [
                                  Expanded(
                                      flex: 6,
                                      child: Text('Concepto',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold))),
                                  Expanded(
                                      flex: 2,
                                      child: Text('Cantidad',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold))),
                                  Expanded(
                                      flex: 3,
                                      child: Text('Precio',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold))),
                                  Expanded(
                                      flex: 2,
                                      child: Text('Descuento',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold))),
                                  Expanded(
                                      flex: 3,
                                      child: Text('Importe',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold)))
                                ])),
                            Container(
                                color: Colors.white,
                                constraints: BoxConstraints(maxHeight: 25.h),
                                child: Scrollbar(
                                    controller: ventaScroll,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: ventaCorte.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                              title: Row(children: [
                                            Expanded(
                                                flex: 6,
                                                child: Text(
                                                    ventaCorte[index]
                                                        .descripcion,
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: 11.sp))),
                                            Expanded(
                                                flex: 2,
                                                child: Text(
                                                    '${ventaCorte[index].cantidad}',
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(
                                                        fontSize: 11.sp))),
                                            Expanded(
                                                flex: 3,
                                                child: Text(
                                                    Textos.moneda(
                                                        moneda:
                                                            ventaCorte[index]
                                                                .precio),
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(
                                                        fontSize: 11.sp))),
                                            Expanded(
                                                flex: 2,
                                                child: Text(
                                                    Textos.moneda(
                                                        moneda:
                                                            ventaCorte[index]
                                                                .descuento),
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(
                                                        fontSize: 11.sp))),
                                            Expanded(
                                                flex: 3,
                                                child: Text(
                                                    Textos.moneda(
                                                        moneda:
                                                            ventaCorte[index]
                                                                .total),
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(
                                                        fontSize: 11.sp)))
                                          ]));
                                        }))),
                            if (!visualizar) Divider(height: 1.h),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Column(children: [
                                  Text(
                                      'Vental Total: ${Textos.moneda(moneda: ICP[0])}',
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold))
                                ])),
                            if (!visualizar)
                              Text('Cant: ${ICP[2]}',
                                  style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.bold)),
                            if (agrupados.isNotEmpty)
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Expanded(
                                          flex: 2,
                                          child: Text('Grupo de producto',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      Expanded(
                                          flex: 1,
                                          child: Text('Cantidad',
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold)))
                                    ]),
                                    Container(
                                        color: Colors.white,
                                        constraints:
                                            BoxConstraints(maxHeight: 13.h),
                                        child: Scrollbar(
                                            controller: grupoScroll,
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: agrupados.length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                      title: Row(children: [
                                                    Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                            proNavegacion
                                                                    .grupoProducto
                                                                    .firstWhereOrNull((element) =>
                                                                        element
                                                                            .id ==
                                                                        agrupados[index]
                                                                            .id)
                                                                    ?.nombre ??
                                                                "Sin Grupo",
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    11.sp))),
                                                    Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                            "${agrupados[index].cantidad}",
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    11.sp)))
                                                  ]));
                                                })))
                                  ]),
                            Divider(height: 4.sp),
                            Row(children: [
                              Expanded(
                                  flex: 2,
                                  child: Text('Forma de Pago',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                  flex: 1,
                                  child: Text('Importe',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold)))
                            ]),
                            Container(
                                color: Colors.white,
                                constraints: BoxConstraints(maxHeight: 17.h),
                                child: Scrollbar(
                                    controller: pagosScroll,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: pagos.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                              title: Row(children: [
                                            Expanded(
                                                flex: 2,
                                                child: Text(pagos[index].nombre,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: 11.sp))),
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                    "\$${Textos.moneda(moneda: pagos[index].importe)}",
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(
                                                        fontSize: 11.sp)))
                                          ]));
                                        }))),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Column(children: [
                                  Text(
                                      'Importe total: ${Textos.moneda(moneda: ventaET[0])}',
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold))
                                ])),
                            Divider(height: 1.h),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Column(children: [
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: Column(children: [
                                        Text(
                                            'Saldo en Caja: ${Textos.moneda(moneda: (ICP[0]))}',
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.bold))
                                      ]))
                                ]))
                          ])))),
              const Divider(height: 0),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                buttonImpresion(proNavegacion, context),
                if (!visualizar)
                  ElevatedButton.icon(
                      onPressed: () async {
                        await Dialogs.showMorph(
                            title: 'Realizando Corte',
                            description:
                                'Verifique que ha impreso el ticket del corte final antes de enviar el corte',
                            loadingTitle: 'Espere un momento\nEnviando corte',
                            onAcceptPressed: (context) async {
                              await generarCorte(ventas);
                              await Navigation.pushNamedAndRemoveUntil(
                                  routeName: 'login');
                            });
                      },
                      label: Text('Enviar Corte',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12.sp)),
                      icon: Icon(Icons.send_and_archive, size: 16.sp))
              ])
            ])));
  }

  ElevatedButton buttonImpresion(
      MainProvider proNavegacion, BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () async {
          if (proNavegacion.selectDevice == null) {
            showDialog(
                context: context,
                builder: (context) => const Dialog(child: DialogImpresora()));
          } else {
            try {
              showToast("Imprimiendo");
              var result =
                  await ImpresoraConnect.conectar(proNavegacion.selectDevice!);
              if (result) {
                await PrintFinal.impresionCorteVenta(
                    provider: proNavegacion,
                    corteFin: ventas,
                    tipo: proNavegacion.selectDevice!);
              } else {
                proNavegacion.selectDevice = null;
                showToast('No se pudo establecer conexion con la impresora',
                    dismissOtherToast: true);
              }
            } catch (e) {
              showToast('$e');
              debugPrint('$e');
            }
          }
        },
        label: Text('Generar Corte',
            overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp)),
        icon: Icon(Icons.local_print_shop, size: 16.sp));
  }
}
