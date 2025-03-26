import 'package:flutter/material.dart';
import 'package:kiosko/controllers/MPago_point_controller.dart';
import 'package:kiosko/utils/main_provider.dart';
import 'package:kiosko/utils/services/dialog_services.dart';
import 'package:kiosko/utils/services/navigation_service.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../models/MPago_point_model.dart';
import '../theme/app_colors.dart';
import '../utils/services/mercadopago.dart';

class SDialogMpPoint extends StatefulWidget {
  const SDialogMpPoint({super.key});

  @override
  State<SDialogMpPoint> createState() => _SDialogMpPointState();
}

class _SDialogMpPointState extends State<SDialogMpPoint> {
  List<MPagoPointModel> points = [];
  @override
  void initState() {
    super.initState();
    initPoints();
  }

  Future<void> initPoints() async {
    showToast("Buscando terminales viculadas a su cuenta");
    var mPoint = await Mercadopago.getTPoint();
    setState(() {
      points = mPoint;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context);
    return Dialog(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      AppBar(
          title:
              Text("Terminal Mercado Point", style: TextStyle(fontSize: 16.sp)),
          actions: [
            IconButton.filled(
                onPressed: () async => initPoints(),
                icon: Icon(Icons.youtube_searched_for,
                    size: 18.sp, color: LightThemeColors.grey))
          ]),
      Column(children: [
        points.isEmpty
            ? Center(
                child: Text("Sin puntos de Mercado pago disponibles",
                    style: TextStyle(
                        fontSize: 12.sp, fontWeight: FontWeight.bold)))
            : Scrollbar(
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 1.w),
                    shrinkWrap: true,
                    itemCount: points.length,
                    itemBuilder: (context, index) {
                      MPagoPointModel point = points[index];
                      return ListTile(
                          leading: provider.pointNow?.id == point.id
                              ? Icon(Icons.perm_device_information,
                                  color: LightThemeColors.background,
                                  size: 18.sp)
                              : null,
                          trailing: IconButton.filled(
                              onPressed: () async {
                                if (point.operatingMode == "PDV") {
                                  await Dialogs.showMorph(
                                      title: "Enlanzar",
                                      description:
                                          "¿Desea enlazar esta terminal ${point.id}, con este punto de venta?",
                                      loadingTitle: "Enlanzando",
                                      onAcceptPressed: (context) async {
                                        MPagoPointModel pago = MPagoPointModel(
                                            id: point.id,
                                            posId: point.posId,
                                            storeId: point.storeId,
                                            externalPosId: point.externalPosId,
                                            operatingMode: point.operatingMode);
                                        await MpagoPointController.insert(
                                            point: pago);
                                        provider.pointNow = pago;
                                        showToast(
                                            "Terminal Mercado Pago Point ${pago.id}\nEnlazado con este dipositivo");
                                        Future.delayed(Duration.zero, () {
                                          Navigation.pop();
                                        });
                                      });
                                } else {
                                  showToast(
                                      "Terminal no valida\nConfigure esta terminal como un punto de venta desde su cuenta de Mercado Pago");
                                }
                              },
                              icon: Icon(Icons.link,
                                  color: LightThemeColors.green),
                              iconSize: 18.sp),
                          tileColor: point.operatingMode == "PDV"
                              ? LightThemeColors.green
                              : LightThemeColors.red,
                          title:
                              Text(point.id, style: TextStyle(fontSize: 12.sp)),
                          subtitle: Text(
                              "Pos id: ${point.posId} - Store id: ${point.storeId}",
                              style: TextStyle(fontSize: 12.sp)));
                    }))
      ])
    ]));
  }
}
