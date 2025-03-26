import 'package:flutter/material.dart';
import 'package:kiosko/dialog/s_dialog_MPago_state.dart';
import 'package:kiosko/dialog/s_dialog_body_usb.dart';
import 'package:kiosko/dialog/s_dialog_mp_point.dart';
import 'package:kiosko/theme/app_colors.dart';
import 'package:kiosko/utils/main_provider.dart';
import 'package:kiosko/utils/services/impresora_configuracion.dart';
import 'package:kiosko/utils/services/mercadopago.dart';
import 'package:kiosko/utils/services/navigation_service.dart';
import 'package:kiosko/utils/textos.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:badges/badges.dart' as bd;

import '../models/MPago_intent_model.dart';
import '../utils/services/dialog_services.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
        builder: (context, provider, child) =>
            HomeViewOpen(provider: provider));
  }
}

class HomeViewOpen extends StatefulWidget {
  final MainProvider provider;
  const HomeViewOpen({super.key, required this.provider});

  @override
  State<HomeViewOpen> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeViewOpen> {
  final productos = [
    {"descripcion": "Arroz blanco 1kg", "monto": 25.5},
    {"descripcion": "Leche entera 1L", "monto": 18.0},
    {"descripcion": "Aceite de girasol 900ml", "monto": 32.75},
    {"descripcion": "Pan integral 500g", "monto": 12.3},
    {"descripcion": "Huevos (docena)", "monto": 28.9},
    {"descripcion": "Atún en lata 120g", "monto": 15.2},
    {"descripcion": "Café molido 250g", "monto": 45.6},
    {"descripcion": "Azúcar refinada 1kg", "monto": 14.8},
    {"descripcion": "Sal de mesa 500g", "monto": 5.5},
    {"descripcion": "Fideos espagueti 500g", "monto": 10.75},
    {"descripcion": "Galletas de avena 200g", "monto": 8.4},
    {"descripcion": "Manzanas (1kg)", "monto": 22.0},
    {"descripcion": "Plátanos (1kg)", "monto": 16.5},
    {"descripcion": "Yogur natural 150g", "monto": 7.9},
    {"descripcion": "Queso fresco 200g", "monto": 30.25},
    {"descripcion": "Jabón líquido 750ml", "monto": 19.8},
    {"descripcion": "Papel higiénico (4 rollos)", "monto": 24.6},
    {"descripcion": "Detergente en polvo 1kg", "monto": 38.7},
    {"descripcion": "Cepillo de dientes", "monto": 9.5},
    {"descripcion": "Shampoo anticaída 400ml", "monto": 42.3},
    {"descripcion": "Lata de refresco 355ml", "monto": 6.8},
    {"descripcion": "Agua mineral 1L", "monto": 4.5},
    {"descripcion": "Chocolate negro 100g", "monto": 20.0},
    {"descripcion": "Cereal de maíz 500g", "monto": 27.4},
    {"descripcion": "Mantequilla 250g", "monto": 23.1},
    {"descripcion": "Tomates (1kg)", "monto": 17.9},
    {"descripcion": "Cebolla blanca (1kg)", "monto": 11.2},
    {"descripcion": "Pasta dental 90g", "monto": 13.75},
    {"descripcion": "Pañuelos desechables (50u)", "monto": 8.0},
    {"descripcion": "Cerveza nacional 330ml", "monto": 16.8}
  ];
  @override
  void initState() {
    super.initState();
    ImpresoraConnect.conectAuto(widget.provider);
    widget.provider.logeo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Seleccione sus productos",
                style: TextStyle(fontSize: 16.sp)),
            actions: [
              OverflowBar(children: [
                IconButton.filled(
                    iconSize: 18.sp,
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) => Dialog(child: DialogImpresora())),
                    icon: Icon(
                        widget.provider.selectDevice == null
                            ? Icons.print_disabled
                            : Icons.print,
                        color: LightThemeColors.background)),
                ElevatedButton(
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) => SDialogMpPoint()),
                    child: Icon(Icons.point_of_sale,
                        size: 20.sp,
                        color: widget.provider.pointNow == null
                            ? LightThemeColors.darkGrey
                            : LightThemeColors.green))
              ])
            ]),
        body: LiquidPullToRefresh(
          onRefresh: () async {},
          child: Scrollbar(
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, childAspectRatio: .8),
                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                  itemCount: productos.length,
                  itemBuilder: (context, index) => Card(
                      child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {},
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    height: (8).h,
                                    child: Image.asset("assets/no_img.jpg",
                                        fit: BoxFit.contain)),
                                Text("${productos[index]["descripcion"]}",
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: (13).sp,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    "\$${Textos.moneda(moneda: double.parse(productos[index]["monto"].toString()))} MXN",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: LightThemeColors.green,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold))
                              ]))))),
        ),
        floatingActionButton: Column(mainAxisSize: MainAxisSize.min, children: [
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(LightThemeColors.red)),
              onPressed: () async =>
                  await Navigation.pushNamed(route: 'banner'),
              child: Text("Cancelar",
                  style: TextStyle(
                      fontSize: 14.sp, color: LightThemeColors.grey))),
          bd.Badge(
              badgeAnimation: bd.BadgeAnimation.fade(),
              badgeStyle: bd.BadgeStyle(badgeColor: LightThemeColors.green),
              position: bd.BadgePosition.topEnd(top: 0, end: -15),
              badgeContent: Icon(Icons.production_quantity_limits,
                  size: 16.sp, color: LightThemeColors.background),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(LightThemeColors.primary)),
                  onPressed: () async {
                    if (widget.provider.pointNow != null) {
                      MPagoIntentModel? intent;
                      await Dialogs.showMorph(
                          title: "Efectuar venta",
                          description:
                              "¿Desea que se le cobre por estos productos que ha ingresado?",
                          loadingTitle: "Enviando Intencion",
                          onAcceptPressed: (context) async {
                            intent = await Mercadopago.sendIntencion(
                                widget.provider.pointNow!.id, 15);
                          });
                      if (intent != null) {
                        await showDialog(
                            context: context,
                            builder: (context) =>
                                SDialogMpagoState(intencion: intent!));
                      }
                    } else {
                      showToast("No hay ninguna terminal conectada");
                    }
                  },
                  child: Text("Pagar",
                      style: TextStyle(
                          fontSize: 14.sp, color: LightThemeColors.grey))))
        ]),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked);
  }
}
