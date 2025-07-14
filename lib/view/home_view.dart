import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:kiosko/dialog/s_dialog_productos.dart';
import 'package:kiosko/theme/app_colors.dart';
import 'package:kiosko/theme/app_theme.dart';
import 'package:kiosko/utils/main_provider.dart';
import 'package:kiosko/utils/services/impresora_configuracion.dart';
import 'package:kiosko/utils/services/navigation_service.dart';
import 'package:kiosko/view/widgets/producto_widget.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';
import 'package:sizer/sizer.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:zo_collection_animation/zo_collection_animation.dart';
import 'package:badges/badges.dart' as bd;

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
/*   final productos = [
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
  ]; */
  @override
  void initState() {
    super.initState();
    ImpresoraConnect.conectAuto(widget.provider);
    widget.provider.logeo();
    internet();
  }

  void totalizar() {
    debugPrint("entro");
    setState(() {
      widget.provider.totalSumatoria();
    });
  }

  Future<void> internet() async {
    InternetConnectionCheckerPlus().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          widget.provider.internet = true;
          break;
        case InternetConnectionStatus.disconnected:
          widget.provider.internet = false;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey animatedKey = GlobalKey();
    return PopScope(
        canPop: false,
        child: Scaffold(
            appBar: AppBar(
                title: Text("Seleccione sus productos",
                    maxLines: 2, style: TextStyle(fontSize: 16.sp)),
                actions: [
                  OverflowBar(children: [
                    RiveAnimatedIcon(
                        riveIcon: RiveIcon.settings,
                        width: 12.w,
                        height: 12.w,
                        color: LightThemeColors.primary,
                        strokeWidth: 4.w,
                        loopAnimation: true,
                        onTap: () async {
                          await Navigation.pushNamed(route: "setting");
                        })
                  ])
                ]),
            body: ProductoWidget(keyAnima: animatedKey, fun: totalizar),
            floatingActionButton:
                Column(mainAxisSize: MainAxisSize.min, children: [
              ZoCollectionDestination(
                  key: animatedKey,
                  child: bd.Badge(
                      badgeAnimation: bd.BadgeAnimation.size(),
                      position: bd.BadgePosition.topEnd(),
                      badgeStyle: bd.BadgeStyle(badgeColor: Colors.transparent),
                      showBadge: widget.provider.listaDetalle.isNotEmpty,
                      badgeContent: Container(
                          decoration: BoxDecoration(
                              color: LightThemeColors.green,
                              borderRadius:
                                  BorderRadius.circular(AppTheme.borderRadius)),
                          child: Padding(
                              padding: EdgeInsets.all(4.sp),
                              child: AnimatedFlipCounter(
                                  value: widget.provider.totalSumatoria(),
                                  prefix: "\$",
                                  duration: Durations.extralong1,
                                  textStyle: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: LightThemeColors.background)))),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  LightThemeColors.primary)),
                          onPressed: () async {
                            if (widget.provider.selectDevice != null) {
                              if (widget.provider.pointNow != null) {
                                if (widget.provider.listaDetalle.isNotEmpty) {
                                  await showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) => SDialogProductos());
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
                                  fontSize: 14.sp,
                                  color: LightThemeColors.grey))))),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(LightThemeColors.red)),
                  onPressed: () async {
                    widget.provider.listaDetalle.clear();
                    await Navigation.pushNamed(route: 'banner');
                  },
                  child: Text("Cancelar",
                      style: TextStyle(
                          fontSize: 14.sp, color: LightThemeColors.grey)))
            ]),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked));
  }
}
