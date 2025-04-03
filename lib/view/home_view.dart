import 'package:flutter/material.dart';
import 'package:kiosko/dialog/s_dialog_MPago_state.dart';
import 'package:kiosko/dialog/s_dialog_body_usb.dart';
import 'package:kiosko/dialog/s_dialog_mp_point.dart';
import 'package:kiosko/dialog/s_dialog_productos.dart';
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
import '../utils/venta_generar.dart';

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
    {
      "id": 22,
      "descripcion": "Renta de cuatrimoto (15 min)",
      "monto": 1.80,
      "img": "assets/22.jpg"
    },
    {
      "id": 3,
      "descripcion": "Boleto de acceso VIP",
      "monto": 9.99,
      "img": "assets/3.png"
    },
    {
      "id": 8,
      "descripcion": "Pase familiar (2 personas)",
      "monto": 4.30,
      "img": "assets/8.jpg"
    },
    {
      "id": 6,
      "descripcion": "Tour en cabalgata (corto)",
      "monto": 6.75,
      "img": "assets/6.jpg"
    },
    {
      "id": 1,
      "descripcion": "Boleto de entrada general",
      "monto": 7.25,
      "img": "assets/1.png"
    },
    {
      "id": 30,
      "descripcion": "Refresco en lata (355ml)",
      "monto": 7.60,
      "img": "assets/30.jpg"
    },
    {
      "id": 24,
      "descripcion": "Alquiler de locker (1h)",
      "monto": 7.45,
      "img": "assets/24.png"
    },
    {
      "id": 19,
      "descripcion": "Foto con personaje (digital)",
      "monto": 4.50,
      "img": "assets/19.avif"
    },
    {
      "id": 23,
      "descripcion": "Snack pack (chocolate + agua)",
      "monto": 6.95,
      "img": "assets/23.png"
    },
    {
      "id": 5,
      "descripcion": "Pase express (1 atracción)",
      "monto": 8.20,
      "img": "assets/5.jpeg"
    },
    {
      "id": 2,
      "descripcion": "Recarga para juegos (5 créditos)",
      "monto": 5.80,
      "img": "assets/2.png"
    },
    {
      "id": 12,
      "descripcion": "Gorra oficial del parque",
      "monto": 7.80,
      "img": "assets/12.webp"
    },
    {
      "id": 4,
      "descripcion": "Estacionamiento básico",
      "monto": 3.45,
      "img": "assets/4.webp"
    },
    {
      "id": 10,
      "descripcion": "Boleto para montaña rusa",
      "monto": 5.60,
      "img": "assets/10.jpg"
    },
    {
      "id": 14,
      "descripcion": "Helado sencillo",
      "monto": 3.25,
      "img": "assets/14.png"
    }
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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: .8,
                        crossAxisSpacing: 0),
                    padding: EdgeInsets.symmetric(horizontal: .5.w),
                    itemCount: productos.length,
                    itemBuilder: (context, index) => Card(
                        child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              setState(() {
                                VentaGenerar.addCarrito(
                                    provider: widget.provider,
                                    producto: productos[index]);
                              });
                            },
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                      height: (8).h,
                                      child: Image.asset(
                                          "${productos[index]["img"]}",
                                          errorBuilder: (context, error,
                                                  stackTrace) =>
                                              Image.asset("assets/no_img.jpg",
                                                  fit: BoxFit.contain),
                                          fit: BoxFit.contain)),
                                  Text("${productos[index]["descripcion"]}",
                                      textAlign: TextAlign.center,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          height: .1.h, fontSize: (14).sp)),
                                  Text(
                                      "\$${Textos.moneda(moneda: double.parse(productos[index]["monto"].toString()))} MXN",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: LightThemeColors.green,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold))
                                ])))))),
        floatingActionButton: Column(mainAxisSize: MainAxisSize.min, children: [
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(LightThemeColors.red)),
              onPressed: () async {
                widget.provider.detalle.clear();
                await Navigation.pushNamed(route: 'banner');
              },
              child: Text("Cancelar",
                  style: TextStyle(
                      fontSize: 14.sp, color: LightThemeColors.grey))),
          bd.Badge(
              showBadge: widget.provider.detalle.isNotEmpty,
              badgeAnimation: bd.BadgeAnimation.fade(),
              badgeStyle: bd.BadgeStyle(badgeColor: LightThemeColors.green),
              position: bd.BadgePosition.topEnd(top: 0, end: -15),
              badgeContent: Icon(Icons.production_quantity_limits,
                  size: 16.sp, color: LightThemeColors.background),
              onTap: () => showDialog(
                  context: context, builder: (context) => SDialogProductos()),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(LightThemeColors.primary)),
                  onPressed: () async {
                    if (widget.provider.selectDevice != null) {
                      if (widget.provider.pointNow != null) {
                        if (widget.provider.detalle.isNotEmpty) {
                          MPagoIntentModel? intent;
                          await Dialogs.showMorph(
                              title: "Efectuar venta",
                              description:
                                  "¿Desea que se le cobre por estos productos que ha ingresado con el monto de \$${Textos.moneda(moneda: widget.provider.totalSumatoria())}?",
                              loadingTitle: "Enviando Intencion",
                              onAcceptPressed: (context) async {
                                var result = await ImpresoraConnect.verificar(
                                    widget.provider.selectDevice);
                                if (result != null) {
                                  intent = await Mercadopago.sendIntencion(
                                      widget.provider.pointNow!.id,
                                      widget.provider.totalSumatoria());
                                } else {
                                  showToast(
                                      "No hay ninguna impresora conectada");
                                }
                                Navigation.pop();
                              });
                          if (intent != null) {
                            await showDialog(
                                context: context,
                                builder: (context) => SDialogMpagoState(
                                    intencion: intent!,
                                    provider: widget.provider));
                          }
                        } else {
                          showToast("No ha ingresado ningun producto");
                        }
                      } else {
                        showToast("No hay ninguna terminal conectada");
                      }
                    } else {
                      showToast("Conecte una impresora");
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
