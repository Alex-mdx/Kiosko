import 'package:flutter/material.dart';
import 'package:kiosko/utils/main_provider.dart';
import 'package:kiosko/utils/print_final.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../controllers/corte_cobro_propio_controller.dart';
import '../../controllers/operacion_controller.dart';
import '../../dialog/s_dialog_corte.dart';
import '../../models/venta_model.dart';
import '../../utils/services/impresora_configuracion.dart';
import '../../utils/textos.dart';

class SyncPanelPagos extends StatefulWidget {
  const SyncPanelPagos({super.key});
  @override
  State<SyncPanelPagos> createState() => _SyncPanelPagosState();
}

class _SyncPanelPagosState extends State<SyncPanelPagos> {
  @override
  Widget build(BuildContext context) {
    final proNavegacion = Provider.of<MainProvider>(context);
    List<Widget> tarjetaCorte(List<VentaModel> items) {
      List<VentaModel> ventaMuestra = [];
      for (var element in items) {
        ventaMuestra.add(element);
      }
      List<String> transacciones = [];
      List<DateTime> fechaIni = [];
      List<DateTime?> fechaFin = [];
      List<int> cerrado = [];
      for (var i = 0; i < ventaMuestra.length; i++) {
        if (transacciones.isEmpty) {
          transacciones.add(ventaMuestra[i].transaccion!);
          fechaIni.add(DateTime.parse(ventaMuestra[i].fechaApertura!));
          fechaFin.add(ventaMuestra[i].fechaCierre == null
              ? null
              : DateTime.parse(ventaMuestra[i].fechaCierre!));
          cerrado.add(ventaMuestra[i].cerrado!);
        } else {
          final intIndice = transacciones
              .indexWhere((element) => element == ventaMuestra[i].transaccion);
          if (intIndice != -1) {
            if (fechaIni[intIndice]
                .isAfter(DateTime.parse(ventaMuestra[i].fechaApertura!))) {
              fechaIni[intIndice] =
                  DateTime.parse(ventaMuestra[i].fechaApertura!);
            }
            if (ventaMuestra[i].fechaCierre == null) {
              fechaFin[intIndice] = null;
            } else {
              fechaFin[intIndice] == null
                  ? fechaFin[intIndice] =
                      DateTime.parse(ventaMuestra[i].fechaCierre!)
                  : fechaFin[intIndice]!
                      .isBefore(DateTime.parse(ventaMuestra[i].fechaCierre!));
              fechaFin[intIndice] =
                  DateTime.parse(ventaMuestra[i].fechaCierre!);
            }
            if (ventaMuestra[i].cerrado == 0) {
              cerrado[intIndice] = (ventaMuestra[i].cerrado!);
            }
          } else {
            transacciones.add(ventaMuestra[i].transaccion!);
            fechaIni.add(DateTime.parse(ventaMuestra[i].fechaApertura!));
            fechaFin.add(ventaMuestra[i].fechaCierre == null
                ? null
                : DateTime.parse(ventaMuestra[i].fechaCierre!));
            cerrado.add(ventaMuestra[i].cerrado!);
          }
        }
      }
      return transacciones.map((item) {
        return Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.w),
            child: Column(children: [
              ElevatedButton.icon(
                  onPressed: () async {
                    final ventaDemo = await SQLHelperCortePropio.getItem(
                        proNavegacion.cortePropio!.transaccion!);
                    List<VentaModel> ventasTemp = [];
                    for (var element in ventaDemo) {
                      ventasTemp.add(element);
                    }
                    if (!proNavegacion.estadoSincronizacion) {
                      try {
                        await showDialog(
                            context: context,
                            builder: (context) => DialogCorte(
                                ventas: ventasTemp, visualizar: false));
                      } catch (e) {
                        showToast("$e");
                        debugPrint("$e");
                      }
                    }
                  },
                  icon: Icon(Icons.shopping_cart_checkout, size: 18.sp),
                  label: Text('Hacer Corte',
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: !proNavegacion.estadoSincronizacion
                              ? Colors.black
                              : Colors.grey))),
              Card(
                  child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(children: [
                        OverflowBar(children: [
                          IconButton(
                              iconSize: 18.sp,
                              icon: const Icon(Icons.shopping_bag_sharp),
                              onPressed: () async {
                                final objCortes =
                                    (await SQLHelperCortePropio.getItem(item))
                                        .toList();
                                if (objCortes.isNotEmpty) {
                                  await showDialog(
                                      context: context,
                                      builder: (context) => DialogCorte(
                                          ventas: (objCortes.where((element) =>
                                              element.transaccion!
                                                  .contains(item))).toList(),
                                          visualizar: true));
                                } else {
                                  showToast(
                                      'Error al visualizar corte\nNo se ha efectuado ninguna compra');
                                }
                              }),
                          Text('Ventas',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold)),
                          cerrado[transacciones.indexOf(item)] == 1
                              ? IconButton(
                                  iconSize: 18.sp,
                                  onPressed: () async {
                                    showToast(item);
                                    final ventaSesion =
                                        (await SQLHelperCortePropio.getItem(
                                                item))
                                            .where((element) =>
                                                (element.sincronizado == 0) &&
                                                (element.cerrado == 1))
                                            .toList();
                                    try {
                                      var result =
                                          await ImpresoraConnect.conectar(
                                              proNavegacion.selectDevice!);
                                      if (result) {
                                        if (ventaSesion.isNotEmpty) {
                                          var envio =
                                              await SqlOperaciones.pagoTotal(
                                                  proNavegacion, item);
                                          if (envio) {
                                            await PrintFinal
                                                .impresionCorteVenta(
                                                    provider: proNavegacion,
                                                    corteFin: ventaSesion,
                                                    tipo: proNavegacion
                                                        .selectDevice!);
                                          }
                                        } else {
                                          await SQLHelperCortePropio
                                              .deleteCorte(item);
                                          proNavegacion.corteinterno =
                                              await SQLHelperCortePropio
                                                  .getItems();
                                          showToast('Venta Sincronizada');
                                        }
                                      } else {
                                        proNavegacion.selectDevice = null;
                                        showToast(
                                            'No se pudo establecer conexion con la impresora',
                                            dismissOtherToast: true);
                                      }
                                    } catch (e) {
                                      showToast('$e');
                                      debugPrint('$e');
                                    }
                                  },
                                  icon: const Icon(Icons.send))
                              : IconButton(
                                  iconSize: 18.sp,
                                  onPressed: () {
                                    showToast('Venta en proceso',
                                        dismissOtherToast: true);
                                  },
                                  icon: const Icon(Icons.priority_high_sharp))
                        ]),
                        Text(
                            'Estado: ${cerrado[transacciones.indexOf(item)] == 1 ? 'CERRADO' : 'Pediente'}',
                            textAlign: TextAlign.center,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                            'Apertura\n${Textos.FechaYMDHMS(fecha: fechaIni[transacciones.indexOf(item)])}',
                            textAlign: TextAlign.center),
                        Text(
                            'Cierre\n${fechaFin[transacciones.indexOf(item)] != null ? Textos.FechaYMDHMS(fecha: fechaFin[transacciones.indexOf(item)]!) : 'En proceso'}',
                            textAlign: TextAlign.center)
                      ])))
            ]));
      }).toList();
    }

    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('Cortes Pendientes',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
        Icon(Icons.save, size: 16.sp)
      ]),
      SingleChildScrollView(
          padding: const EdgeInsets.all(2.0),
          scrollDirection: Axis.horizontal,
          reverse: true,
          physics: const BouncingScrollPhysics(
              decelerationRate: ScrollDecelerationRate.fast),
          child: Row(children: tarjetaCorte(proNavegacion.corteinterno)))
    ]);
  }
}
