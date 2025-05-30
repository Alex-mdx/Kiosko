import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kiosko/models/MPago_intent_model.dart';
import 'package:kiosko/models/MPago_payment_model.dart';
import 'package:kiosko/models/Mpago_pay_intent_model.dart';
import 'package:kiosko/theme/app_colors.dart';
import 'package:kiosko/utils/main_provider.dart';
import 'package:kiosko/utils/services/mercadopago.dart';
import 'package:kiosko/utils/services/navigation_service.dart';
import 'package:sizer/sizer.dart';
import 'package:translator/translator.dart';

import '../utils/print_final.dart';

class SDialogMpagoState extends StatefulWidget {
  final MainProvider provider;
  final MPagoIntentModel intencion;
  const SDialogMpagoState(
      {super.key, required this.intencion, required this.provider});

  @override
  State<SDialogMpagoState> createState() => _SDialogMpagoStateState();
}

class _SDialogMpagoStateState extends State<SDialogMpagoState> {
  final translator = GoogleTranslator();
  MPagoPayIntentModel? intencionPago;
  MPagoPaymentModel? pago;
  bool pagoBool = false;
  Timer? _timer;
  String estado = "";
  String descripcion = "";

  @override
  void initState() {
    super.initState();

    _startPeriodicTask();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPeriodicTask() {
    _timer = Timer.periodic(Duration(seconds: 4), (Timer timer) async {
      if (intencionPago?.state != "FINISHED" &&
          intencionPago?.state != "CANCELED") {
        var intencion =
            await Mercadopago.findIntencion(id: widget.intencion.id);
        setState(() {
          intencionPago = intencion;
        });
      } else {
        if (intencionPago?.state == "FINISHED") {
          var payment =
              await Mercadopago.findPay(id: intencionPago!.payment.id!);
          estado = (await translator.translate(payment?.status ?? "", to: 'es'))
              .text;
          descripcion = (await translator.translate(
                  payment?.statusDetail?.replaceAll("_", " ") ?? "",
                  to: 'es'))
              .text;
          setState(() {
            pago = payment;
            pagoBool = true;
          });
          if (pago?.status == "approved") {
            await PrintFinal.ticketCompra(
                print: widget.provider.selectDevice,
                carrito: widget.provider.detalle);
            widget.provider.detalle.clear();
          }
          _timer?.cancel();
        }
        Future.delayed(Duration(seconds: 3), () => Navigation.pop());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: PopScope(
            canPop: false,
            child: Padding(
                padding: EdgeInsets.all(8.sp),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text("Estado de pago",
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  Column(children: [
                    Text(Mercadopago.string(state: intencionPago?.state ?? ""),
                        style: TextStyle(fontSize: 16.sp)),
                    if (pago != null)
                      Card(
                          color: pago?.status == "rejected"
                              ? LightThemeColors.red
                              : null,
                          child: Padding(
                              padding: EdgeInsets.all(10.sp),
                              child: Column(children: [
                                Text("Seguimiento de pago",
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold)),
                                pagoBool
                                    ? Text("$estado\n $descripcion",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 15.sp))
                                    : CircularProgressIndicator()
                              ]))),
                    if (intencionPago?.state != "FINISHED" &&
                        intencionPago?.state != "CANCELED")
                      Column(children: [
                        Text(
                            "Ingrese su tarjeta en la terminal correspondiente",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15.sp)),
                        CircularProgressIndicator()
                      ])
                  ])
                ]))));
  }
}
