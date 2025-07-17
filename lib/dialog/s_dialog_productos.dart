import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:kiosko/models/MPago_intent_model.dart';
import 'package:kiosko/models/venta_pago_model.dart';
import 'package:kiosko/theme/app_colors.dart';
import 'package:kiosko/utils/main_provider.dart';
import 'package:kiosko/utils/services/navigation_service.dart';
import 'package:kiosko/utils/textos.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../utils/services/impresora_configuracion.dart';
import '../utils/services/mercadopago.dart';
import 's_dialog_MPago_state.dart';

class SDialogProductos extends StatefulWidget {
  const SDialogProductos({super.key});

  @override
  State<SDialogProductos> createState() => _SDialogProductosState();
}

class _SDialogProductosState extends State<SDialogProductos> {
  bool press = false;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context);
    return PopScope(
        canPop: !press,
        child: Dialog(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          AppBar(
              leading: press ? Icon(Icons.timer, size: 20.sp) : null,
              title: Text("Carrito de compras",
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 16.sp))),
          Padding(
              padding: EdgeInsets.all(8.sp),
              child: Column(children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Row(children: [
                      Expanded(
                          flex: 4,
                          child: Text("Productos",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold))),
                      Expanded(
                          flex: 1,
                          child: Text("Cantidad",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold))),
                      Expanded(
                          flex: 2,
                          child: Text("Total",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold)))
                    ])),
                Container(
                    constraints: BoxConstraints(maxHeight: 50.h),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: provider.listaDetalle.length,
                        padding: EdgeInsets.symmetric(horizontal: 1.w),
                        itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.only(bottom: (.5).h),
                            child: Slidable(
                                endActionPane: ActionPane(
                                    motion: const BehindMotion(),
                                    children: [
                                      SlidableAction(
                                          flex: 1,
                                          onPressed: (context) {
                                            setState(() {
                                              provider.listaDetalle
                                                  .removeAt(index);
                                              provider.totalSumatoria();
                                              showToast("Producto eliminado");
                                            });
                                            if (provider.listaDetalle.isEmpty) {
                                              showToast(
                                                  "Lista de productos vacia");
                                              Navigation.pop();
                                            }
                                          },
                                          backgroundColor: LightThemeColors.red,
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                          padding: EdgeInsets.all(4.sp),
                                          label: 'Eliminar')
                                    ]),
                                child: Stack(
                                    alignment: Alignment.centerRight,
                                    children: [
                                      ListTile(
                                          contentPadding: EdgeInsets.only(
                                              right: 2.h, left: 1.h),
                                          title: Row(children: [
                                            Expanded(
                                                flex: 4,
                                                child: Text(
                                                    provider.listaDetalle[index]
                                                            .concepto ??
                                                        "Sin nombre",
                                                    textAlign: TextAlign.start,
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 14.sp))),
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                    "${provider.listaDetalle[index].cantidad}",
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(
                                                        fontSize: 14.sp))),
                                            Expanded(
                                                flex: 2,
                                                child: Text(
                                                    "\$${Textos.moneda(moneda: provider.listaDetalle[index].total ?? 0)}",
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(
                                                        fontSize: 14.sp)))
                                          ])),
                                      Icon(Icons.keyboard_double_arrow_left,
                                          size: 16.sp,
                                          color: LightThemeColors.red)
                                    ]))))),
                Divider(),
                Text(
                    "Total a pagar: \$${Textos.moneda(moneda: provider.totalSumatoria())}",
                    style: TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.bold)),
                TextButton(
                    onPressed: () {},
                    child: Text(
                        "Metodo de pago: ${provider.formaPago.firstWhereOrNull((element) => element.defecto == 1)?.nombre}",
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold))),
                ElevatedButton.icon(
                    icon: RiveAnimatedIcon(
                        riveIcon: press ? RiveIcon.refresh : RiveIcon.like,
                        width: 8.w,
                        height: 8.w,
                        color: Colors.green,
                        onTap: null,
                        strokeWidth: 22.w,
                        loopAnimation: true),
                    onPressed: () async {
                      if (!press) {
                        setState(() {
                          press = true;
                        });

                        MPagoIntentModel? intent;
                        var pagoTemp = provider.formaPago.firstWhereOrNull(
                            (element) => element.defecto == 1);

                        var pago = PagoModel(
                            id: pagoTemp?.id,
                            nombre: pagoTemp?.nombre,
                            databaseId: pagoTemp?.databaseId,
                            factorComision: pagoTemp?.factorComision,
                            codigoSat: pagoTemp?.codigoSat,
                            cuentaContable: pagoTemp?.cuentaContable,
                            metodoPago: pagoTemp?.metodoPago,
                            formaPago: pagoTemp?.formaPago,
                            moneda: pagoTemp?.moneda,
                            permitirCambio: pagoTemp?.permitirCambio,
                            importe:
                                provider.totalSumatoria().toStringAsFixed(2),
                            referencia: null,
                            cambio: 0,
                            tipoCambio: double.tryParse(
                                pagoTemp?.tipoCambioDefault ?? "1"),
                            press: 0,
                            cuentaBancariaId: pagoTemp?.cuentaBancariaId,
                            formaPagoId: pagoTemp?.id);

                        var result = await ImpresoraConnect.conectar(
                            provider.selectDevice!);
                        if (result) {
                          intent = await Mercadopago.sendIntencion(
                              provider.pointNow!.id, provider.totalSumatoria());
                        } else {
                          showToast("No hay ninguna impresora conectada");
                        }
                        if (intent != null) {
                          await showDialog(
                              context: context,
                              builder: (context) => SDialogMpagoState(
                                  intencion: intent!,
                                  provider: provider,
                                  pago: pago));
                        }
                        setState(() {
                          press = false;
                        });
                      }
                    },
                    label: Text("Confirmar compra",
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold)))
              ]))
        ])));
  }
}
