import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sizer/sizer.dart';
import '../controllers/corte_cobro_propio_controller.dart';
import '../models/venta_model.dart';
import '../models/venta_pago_model.dart';
import '../theme/app_theme.dart';
import '../utils/services/dialog_services.dart';
import '../utils/services/navigation_service.dart';
import '../utils/textos.dart';

class DialogAdminDetalle extends StatefulWidget {
  final VentaModel venta;
  const DialogAdminDetalle({super.key, required this.venta});
  @override
  State<DialogAdminDetalle> createState() => _DialogAdminDetalle();
}

class _DialogAdminDetalle extends State<DialogAdminDetalle> {
  final ScrollController _scrollDetalle = ScrollController();
  final ScrollController _scrollPago = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 80.h,
        width: 75.w,
        child: Column(children: [
          AppBar(
              leading: BackButton(
                  style: const ButtonStyle(
                      iconColor: WidgetStatePropertyAll(Colors.white)),
                  onPressed: () => Navigation.pop()),
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(10))),
              backgroundColor: AppTheme.lightPrimary,
              actions: [
                if (widget.venta.sincronizado == 0)
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                          onPressed: () async => await Dialogs.showMorph(
                              title: "Reparar Pagos",
                              description:
                                  "Este proceso eliminara los cambios de los metodos de pago para particionar los montos",
                              loadingTitle: "Reparando",
                              onAcceptPressed: (context) async {
                                PagoModel pagoNew = widget.venta.pagos.first
                                    .copyWith(
                                        importe: (widget.venta.total! /
                                                widget.venta.pagos.first
                                                    .tipoCambio!)
                                            .toStringAsFixed(2),
                                        cambio: 0);
                                VentaModel newVenta =
                                    widget.venta.copyWith(pagos: [pagoNew]);
                                log("${newVenta.toJson()}");
                                await SQLHelperCortePropio.updateUser(newVenta);
                                showToast("Nodo de pago en venta corregida");
                                Navigation.popTwice();
                              }),
                          label: const Text("Reparar pagos"),
                          icon: const Icon(Icons.settings_backup_restore)))
              ],
              title: Text('Detalle de venta ${widget.venta.folio}',
                  style: const TextStyle(color: Colors.white))),
          Expanded(
              child: Row(children: [
            Expanded(
                flex: 5,
                child: widget.venta.detalles.isEmpty
                    ? const Center(child: Text('No hay detalles en la venta'))
                    : Scrollbar(
                        controller: _scrollDetalle,
                        child: ListView.builder(
                            itemCount: widget.venta.detalles.length,
                            controller: _scrollDetalle,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: ListTile(
                                      onTap: () => debugPrint(
                                          "${widget.venta.detalles[index].toJson()}"),
                                      leading: const Icon(Icons.sell_outlined),
                                      title: const Row(children: [
                                        Expanded(
                                            flex: 2,
                                            child: Text('Producto',
                                                maxLines: 1,
                                                textAlign: TextAlign.start,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                        Expanded(
                                            flex: 1,
                                            child: Text('Cantidad',
                                                maxLines: 1,
                                                textAlign: TextAlign.end,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                        Expanded(
                                            flex: 1,
                                            child: Text('Precio',
                                                maxLines: 1,
                                                textAlign: TextAlign.end,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                        Expanded(
                                            flex: 1,
                                            child: Text('Descuento',
                                                maxLines: 1,
                                                textAlign: TextAlign.end,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                        Expanded(
                                            flex: 1,
                                            child: Text('Total',
                                                maxLines: 1,
                                                textAlign: TextAlign.end,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                      ]),
                                      subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(children: [
                                              Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                      '${widget.venta.detalles[index].concepto}',
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.start,
                                                      overflow: TextOverflow
                                                          .ellipsis)),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                      Textos.moneda(
                                                          moneda: widget
                                                                  .venta
                                                                  .detalles[
                                                                      index]
                                                                  .cantidad ??
                                                              0),
                                                      maxLines: 1,
                                                      textAlign: TextAlign.end,
                                                      overflow: TextOverflow
                                                          .ellipsis)),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                      '\$${Textos.moneda(moneda: double.parse(widget.venta.detalles[index].precio ?? "0"))}',
                                                      maxLines: 1,
                                                      textAlign: TextAlign.end,
                                                      overflow: TextOverflow
                                                          .ellipsis)),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                      '${Textos.moneda(moneda: widget.venta.detalles[index].descuentoImporte ?? 0)}%',
                                                      maxLines: 1,
                                                      textAlign: TextAlign.end,
                                                      overflow: TextOverflow
                                                          .ellipsis)),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                      '\$${Textos.moneda(moneda: widget.venta.detalles[index].total ?? 0)}',
                                                      maxLines: 1,
                                                      textAlign: TextAlign.end,
                                                      overflow: TextOverflow
                                                          .ellipsis))
                                            ]),
                                            if (widget.venta.detalles[index]
                                                .serie.isNotEmpty)
                                              Text(
                                                  "Serie: ${widget.venta.detalles[index].serie.map((e) => e.serie).join(", ")}",
                                                  style: TextStyle(
                                                      fontSize: 11.sp,
                                                      fontWeight:
                                                          FontWeight.bold))
                                          ])));
                            }))),
            const VerticalDivider(),
            Expanded(
                flex: 4,
                child: widget.venta.pagos.isEmpty
                    ? const Center(child: Text('No hay pagos en la venta'))
                    : Scrollbar(
                        controller: _scrollPago,
                        child: ListView.builder(
                            itemCount: widget.venta.pagos.length,
                            controller: _scrollPago,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: ListTile(
                                      leading: const Icon(
                                          Icons.monetization_on_outlined),
                                      title: Row(children: [
                                        const Expanded(
                                            flex: 3,
                                            child: Text('Nombre',
                                                maxLines: 1,
                                                textAlign: TextAlign.start,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                        const Expanded(
                                            flex: 2,
                                            child: Text('Importe',
                                                maxLines: 1,
                                                textAlign: TextAlign.end,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                        if (widget.venta.pagos[index]
                                                .tipoCambio !=
                                            1)
                                          const Expanded(
                                              flex: 2,
                                              child: Text('Conversion',
                                                  maxLines: 1,
                                                  textAlign: TextAlign.end,
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                        const Expanded(
                                            flex: 2,
                                            child: Text('Cambio',
                                                maxLines: 1,
                                                textAlign: TextAlign.end,
                                                overflow:
                                                    TextOverflow.ellipsis))
                                      ]),
                                      subtitle: Row(children: [
                                        Expanded(
                                            flex: 3,
                                            child: Text(
                                                '${widget.venta.pagos[index].nombre}',
                                                maxLines: 2,
                                                textAlign: TextAlign.start,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                                '\$${Textos.moneda(moneda: double.parse(widget.venta.pagos[index].importe ?? "0"))}',
                                                maxLines: 1,
                                                textAlign: TextAlign.end,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                        if (widget.venta.pagos[index]
                                                .tipoCambio !=
                                            1)
                                          Expanded(
                                              flex: 2,
                                              child: Text(
                                                  '\$${Textos.moneda(moneda: (double.parse(widget.venta.pagos[index].importe ?? "0") * (widget.venta.pagos[index].tipoCambio ?? 0)))}',
                                                  maxLines: 1,
                                                  textAlign: TextAlign.end,
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                                '\$${Textos.moneda(moneda: ((widget.venta.pagos[index].cambio ?? 0) * (widget.venta.pagos[index].tipoCambio ?? 0)))}',
                                                maxLines: 1,
                                                textAlign: TextAlign.end,
                                                overflow:
                                                    TextOverflow.ellipsis))
                                      ])));
                            })))
          ]))
        ]));
  }
}
