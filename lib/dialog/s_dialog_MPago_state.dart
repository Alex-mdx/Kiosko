import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kiosko/models/MPago_intent_model.dart';
import 'package:kiosko/models/Mpago_pay_intent_model.dart';
import 'package:kiosko/utils/services/mercadopago.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sizer/sizer.dart';

class SDialogMpagoState extends StatefulWidget {
  final MPagoIntentModel intencion;
  const SDialogMpagoState({super.key, required this.intencion});

  @override
  State<SDialogMpagoState> createState() => _SDialogMpagoStateState();
}

class _SDialogMpagoStateState extends State<SDialogMpagoState> {
  MPagoPayIntentModel? intencionPago;
  Timer? _timer;

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
      if (intencionPago?.state != "FINISHED") {
        intencionPago =
            await Mercadopago.findIntencion(id: widget.intencion.id);
      } else {
        showToast("Pago finalizado");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              showToast("Espere un momento en lo quqe se efectua su pedido");
            },
            child: Padding(
                padding: EdgeInsets.all(8.sp),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text("Estado de pago",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.bold)),
                  intencionPago != null
                      ? Column(children: [
                          Text(intencionPago!.state,
                              style: TextStyle(fontSize: 14.sp))
                        ])
                      : CircularProgressIndicator()
                ]))));
  }
}
