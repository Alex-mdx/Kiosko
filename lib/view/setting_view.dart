import 'package:flutter/material.dart';
import 'package:kiosko/controllers/user_controller.dart';
import 'package:kiosko/dialog/s_dialog_familia.dart';
import 'package:kiosko/utils/main_provider.dart';
import 'package:kiosko/utils/shared_preferences.dart';
import 'package:kiosko/view/widgets/sync_sincronizar_widget.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../controllers/operacion_controller.dart';
import '../controllers/s_dialog_general.dart';
import '../dialog/s_dialog_admin.dart';
import '../dialog/s_dialog_body_usb.dart';
import '../dialog/s_dialog_mp_point.dart';
import '../dialog/s_dialog_pin.dart';
import '../models/usuario_model.dart';
import '../theme/app_colors.dart';
import '../utils/services/dialog_services.dart';
import '../utils/services/navigation_service.dart';
import 'widgets/sync_pagos_widget.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final TextEditingController _controllerApertura = TextEditingController();

  Widget folioSelect(MainProvider proNavegacion) {
    return Column(children: [
      SizedBox(
          width: 35.w,
          child: TextField(
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 1.w, vertical: 0),
                  suffixIcon: Icon(Icons.numbers),
                  fillColor: LightThemeColors.background),
              textAlign: TextAlign.end,
              controller: _controllerApertura,
              keyboardType: TextInputType.number)),
      ElevatedButton(
          onPressed: () async {
            if (int.tryParse(_controllerApertura.text) != null) {
              UsuarioModel user = proNavegacion.user!;
              await UserController.updateUser(user.copyWith(
                  consecutivo: int.parse(_controllerApertura.text)));
              proNavegacion.user = (await UserController.getItem());
              Future.delayed(Duration.zero, () => Navigator.pop(context));
            } else {
              showToast(
                  'El valor ${_controllerApertura.text}\nNo es de tipo entero',
                  dismissOtherToast: true);
            }
          },
          style: const ButtonStyle(
              backgroundColor:
                  WidgetStatePropertyAll(LightThemeColors.background)),
          child: const Icon(Icons.save_alt))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context);
    return PopScope(
        canPop: !provider.estadoSincronizacion,
        child: Scaffold(
            appBar: AppBar(
                title: Text("Configuracion", style: TextStyle(fontSize: 16.sp)),
                actions: [
                  ElevatedButton.icon(
                      onPressed: () async {
                        int? codigo;
                        bool type = false;
                        await Dialogs.showMorph(
                            title: 'Cambiar folio de punto de venta',
                            description:
                                'Se intenta cambiar folio, oprima el boton de ACEPTAR\npara enviar un codigo de autorización al administrador',
                            loadingTitle: 'Enviando autorizacion...',
                            onAcceptPressed: (context) async {
                              codigo = await SqlOperaciones.solicitarPin();
                              debugPrint('$codigo');
                            });
                        if (codigo != null) {
                          await showDialog(
                              context: context,
                              builder: (context) => SDialogPin(
                                  codigo: codigo.toString(),
                                  acepta: (p0) async => type = p0));
                        }
                        if (type) {
                          showDialog(
                              context: context,
                              builder: (context) => DialoGeneral(
                                  encabezado: 'Ingresar Folio',
                                  subText:
                                      'Por favor, introduzca el número siguiente al folio actual',
                                  child: folioSelect(provider)));
                        }
                      },
                      icon: Icon(Icons.shopping_cart_sharp, size: 18.sp),
                      label: Text(
                          'Modificar folio: ${provider.user?.consecutivo}',
                          style: TextStyle(fontSize: (11).sp))),
                  IconButton.filled(
                      onPressed: () => showAdaptiveDialog(
                          context: context,
                          barrierDismissible: false,
                          barrierLabel: 'administrador',
                          builder: (context) => Dialog(
                              child: DialogAdmin(proNavegacion: provider))),
                      icon: Icon(Icons.admin_panel_settings_sharp,
                          size: 18.sp, color: Colors.white)),
                  IconButton(
                      onPressed: () => Dialogs.showMorph(
                          title: "Salir de la sesion",
                          description:
                              "¿Desea salir la actual sesion?\nEsta accion lo enviara a la ventana de login",
                          loadingTitle: "Cerrando",
                          onAcceptPressed: (context) async {
                            Preferencias.logeado = false;
                            await Navigation.pushNamedAndRemoveUntil(
                                routeName: 'login');
                          }),
                      iconSize: 20.sp,
                      icon:
                          Icon(Icons.exit_to_app, color: LightThemeColors.red))
                ]),
            body: Column(children: [
              SyncPanelPagos(),
              Divider(),
              Expanded(
                child: Scrollbar(
                  child: ListView(shrinkWrap: true, children: [
                    SyncPanelSincro(),
                    Wrap(
                        alignment: WrapAlignment.spaceAround,
                        spacing: 1.w,
                        children: [
                          ElevatedButton.icon(
                              label: Text("impresora",
                                  style: TextStyle(fontSize: 14.sp)),
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) =>
                                      Dialog(child: DialogImpresora())),
                              icon: Icon(
                                  size: 18.sp,
                                  provider.selectDevice == null
                                      ? Icons.print_disabled
                                      : Icons.print,
                                  color: provider.selectDevice == null
                                      ? LightThemeColors.darkGrey
                                      : LightThemeColors.primary)),
                          ElevatedButton.icon(
                              label: Text("Terminal de cobro",
                                  style: TextStyle(fontSize: 14.sp)),
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => SDialogMpPoint()),
                              icon: Icon(Icons.point_of_sale,
                                  size: 18.sp,
                                  color: provider.pointNow == null
                                      ? LightThemeColors.darkGrey
                                      : LightThemeColors.green)),
                          ElevatedButton.icon(
                              icon: Icon(Icons.group_work,
                                  size: 20.sp, color: LightThemeColors.green),
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => SDialogFamilia()),
                              label: Text("Familia filtro",
                                  style: TextStyle(fontSize: 14.sp)))
                        ])
                  ]),
                ),
              )
            ])));
  }
}
