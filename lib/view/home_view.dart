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

import '../controllers/operacion_controller.dart';
import '../dialog/s_dialog_pin.dart';
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
                    Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppTheme.borderRadius),
                            color: LightThemeColors.grey),
                        child: RiveAnimatedIcon(
                            riveIcon: RiveIcon.settings,
                            width: 11.w,
                            height: 11.w,
                            color: LightThemeColors.primary,
                            strokeWidth: 4.w,
                            loopAnimation: true,
                            onTap: () async {
                              var aceptar = false;
                              int? codigo;
                              await Dialogs.showMorph(
                                  title: "Acceder a configuraciones",
                                  description:
                                      "Para acceder a las configuraciones tendra que ingresar el codigo de verificacion",
                                  loadingTitle: "Validando",
                                  onAcceptPressed: (context) async {
                                    aceptar = true;
                                    codigo =
                                        await SqlOperaciones.solicitarPin();
                                  });
                              var sync = false;
                              if (aceptar) {
                                await showDialog(
                                    context: context,
                                    builder: (context) => SDialogPin(
                                        codigo: codigo.toString(),
                                        acepta: (p0) async => sync = p0));
                              }
                              if (sync) {
                                await Navigation.pushNamed(route: "setting");
                              }
                            }))
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
                                          builder: (context) =>
                                              SDialogProductos())
                                      .then((value) => totalizar());
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
