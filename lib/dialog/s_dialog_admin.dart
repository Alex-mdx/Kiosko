import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:kiosko/controllers/empresa_controller.dart';
import 'package:kiosko/utils/main_provider.dart';
import 'package:kiosko/utils/print_final.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sizer/sizer.dart';
import '../controllers/corte_cobro_propio_controller.dart';
import '../controllers/operacion_controller.dart';
import '../models/venta_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../utils/services/dialog_services.dart';
import '../utils/services/impresora_configuracion.dart';
import '../utils/services/navigation_service.dart';
import '../utils/textos.dart';
import '../view/widgets/html_visualizador_widget.dart';
import 's_dialog_admin_detalle.dart';
import 's_dialog_body_usb.dart';
import 's_dialog_pin.dart';

class DialogAdmin extends StatefulWidget {
  final MainProvider proNavegacion;

  const DialogAdmin({super.key, required this.proNavegacion});
  @override
  State<DialogAdmin> createState() => _DialogAdmin();
}

class _DialogAdmin extends State<DialogAdmin> {
  final TextEditingController _buscadorFolio = TextEditingController();
  final ScrollController _scrollFolio = ScrollController();

  bool folio = false;

  List<VentaModel> folios = [];
  @override
  void initState() {
    super.initState();
    getFolio();
  }

  Future<void> getFolio() async {
    final data = await SQLHelperCortePropio.getItemsLastTen();
    setState(() {
      folios = data;
    });
  }

  Future<void> getFolioNoSync() async {
    final data = await SQLHelperCortePropio.getItemsLastTenSync();
    setState(() {
      folios = data;
    });
  }

  Future<void> getConsecutivo(String buscar) async {
    final data = await SQLHelperCortePropio.getItemsConsecutivo(buscar);
    setState(() {
      folios = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode actualTeclado = FocusScope.of(context);

    return SizedBox(
        child: Column(children: [
      AppBar(
          leading: BackButton(
              style: const ButtonStyle(
                  iconColor: WidgetStatePropertyAll(Colors.white)),
              onPressed: () => Navigation.pop()),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
          backgroundColor: AppTheme.lightPrimary,
          title: const Text('Ventas Internas',
              style: TextStyle(color: Colors.white)),
          actions: [
            Container(
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius)),
                padding: const EdgeInsets.all(8),
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Todos", style: TextStyle(fontSize: 11.sp)),
                      Switch(
                          value: folio,
                          onChanged: (value) async {
                            setState(() {
                              folio = !folio;
                            });
                            if (!folio) {
                              await getFolio();
                            } else {
                              await getFolioNoSync();
                            }
                          }),
                      Text("No enviados", style: TextStyle(fontSize: 11.sp))
                    ]))
          ]),
      Expanded(
          flex: 15,
          child: Column(children: [
            Container(
                color: LightThemeColors.background,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        controller: _buscadorFolio,
                        onFieldSubmitted: (value) async {
                          _buscadorFolio.text = value;
                          await getConsecutivo(_buscadorFolio.text);
                        },
                        onTapOutside: (event) {
                          if (!actualTeclado.hasPrimaryFocus) {
                            actualTeclado.unfocus();
                          }
                        },
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                            hintText: 'Ingresar el numero de folio de venta',
                            suffixIcon: Icon(Icons.manage_search))))),
            Expanded(
                child: folios.isEmpty
                    ? Center(
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(_buscadorFolio.text == ""
                            ? 'No se han ingresado ventas'
                            : 'No existen ventas pertenecientes al folio ingresado'),
                        if (_buscadorFolio.text != "")
                          IconButton(
                              onPressed: () async {
                                if (!folio) {
                                  await getFolio();
                                } else {
                                  await getFolioNoSync();
                                }
                                setState(() {
                                  _buscadorFolio.clear();
                                });
                              },
                              icon: const Icon(Icons.close))
                      ]))
                    : Scrollbar(
                        controller: _scrollFolio,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: folios.length,
                            controller: _scrollFolio,
                            itemBuilder: (context, index) {
                              VentaModel ventaLista = folios[index];
                              return listaVentas(
                                  widget.proNavegacion, ventaLista);
                            })))
          ])),
      Expanded(
          flex: 1,
          child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              color: LightThemeColors.background,
              child: const Text('Esta ventana traera las ultimas 20 ventas')))
    ]));
  }

  Widget listaVentas(MainProvider provider, VentaModel venta) {
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListTile(
            tileColor: Colors.white,
            leading: const Icon(Icons.description_outlined),
            title: Text(
                'Folio: ${venta.consecutivo} | Importe: \$${Textos.moneda(moneda: venta.total ?? 0)} ${venta.comision! > 0 ? "| Comision: ${Textos.moneda(moneda: venta.comision ?? 0)}" : ""}'),
            subtitle: Column(children: [
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                      'Apertura: ${venta.fechaApertura} - Cierre: ${venta.fechaCierre}')),
              Row(mainAxisSize: MainAxisSize.min, children: [
                venta.sincronizado == 1
                    ? Icon(
                        size: 16.sp,
                        Icons.cloud_done,
                        color: LightThemeColors.green)
                    : Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(
                            iconSize: 16.sp,
                            onPressed: () => Dialogs.showMorph(
                                title: "Enviar venta no sincronizada",
                                description:
                                    '¿Desea enviar esta venta no sincronizada?',
                                loadingTitle: 'Enviando',
                                onAcceptPressed: (context) async {
                                  if (provider.internet) {
                                    final ventas =
                                        await SqlOperaciones.pagoVenta(venta);
                                    await SQLHelperCortePropio.updateUser(
                                        ventas);
                                    if (!folio) {
                                      await getFolio();
                                    } else {
                                      await getFolioNoSync();
                                    }
                                    Navigation.pop();
                                  } else {
                                    showToast(
                                        "Sin conexion a internet intente mas tarde");
                                  }
                                }),
                            icon: const Icon(Icons.sync_problem_sharp,
                                color: LightThemeColors.primary))
                      ]),
                if (venta.errorVenta != null && venta.sincronizado == 0)
                  IconButton(
                      iconSize: 16.sp,
                      onPressed: () {
                        showAdaptiveDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                  child: Padding(
                                      padding: EdgeInsets.all(6.sp),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('Razon de error de envio',
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            venta.errorVenta!.contains('html')
                                                ? HtmlVisualizadorWidget(
                                                    body: venta.errorVenta!)
                                                : Text('${venta.errorVenta}',
                                                    style: TextStyle(
                                                        fontSize: 11.sp)),
                                            ElevatedButton.icon(
                                                onPressed: () {
                                                  final Email email = Email(
                                                      body: "${venta.toJson()}",
                                                      subject:
                                                          'Error en la venta ${venta.serie}${venta.consecutivo} con fecha ${venta.fecha}',
                                                      recipients: [
                                                        'alexarmandomdx@gmail.com'
                                                      ],
                                                      cc: [
                                                        'alexarmandomdx@gmail.com'
                                                      ],
                                                      isHTML: false);
                                                  Dialogs.showMorph(
                                                      title: "Notificar error",
                                                      description:
                                                          "Se enviara esta venta al desarrollador para revision",
                                                      loadingTitle:
                                                          "Enviando...",
                                                      onAcceptPressed:
                                                          (context) async {
                                                        try {
                                                          await FlutterEmailSender
                                                              .send(email);
                                                        } catch (e) {
                                                          showToast("$e");
                                                        }
                                                        Navigation.pop();
                                                      });
                                                },
                                                label: Text("Notificar error",
                                                    style: TextStyle(
                                                        fontSize: 16.sp)),
                                                icon: Icon(
                                                    size: 20.sp,
                                                    Icons.nearby_error))
                                          ])));
                            });
                      },
                      icon: const Icon(Icons.new_releases,
                          color: LightThemeColors.darkBlue)),
                IconButton(
                    iconSize: 16.sp,
                    onPressed: () async {
                      if (provider.selectDevice == null) {
                        showDialog(
                            context: context,
                            builder: (context) =>
                                const Dialog(child: DialogImpresora()));
                        return;
                      } else {
                        var result = await ImpresoraConnect.conectar(
                            provider.selectDevice!);
                        if (result) {
                          await PrintFinal.ventaBoletaje(
                              provider: provider,
                              type: provider.selectDevice!,
                              venta: venta);
                        } else {
                          provider.selectDevice = null;
                        }
                      }
                    },
                    icon: const Icon(Icons.print,
                        color: LightThemeColors.primary)),
                IconButton(
                    iconSize: 16.sp,
                    onPressed: () {
                      showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                  child: DialogAdminDetalle(venta: venta)))
                          .then((value) async {
                        if (!folio) {
                          await getFolio();
                        } else {
                          await getFolioNoSync();
                        }
                      });
                    },
                    icon: const Icon(Icons.sell_sharp,
                        color: LightThemeColors.yellow)),
                IconButton(
                    iconSize: 16.sp,
                    onPressed: () async {
                      var empresaActual = await EmpresaController.getItem(
                          provider.user!.empresaId!);
                      if (empresaActual?.correo == null) {
                        showToast(
                            'No existen ningun correo de administrador\nConfigurelo desde Soferp');
                      } else {
                        int? codigo;
                        if (provider.internet) {
                          await Dialogs.showMorph(
                              title:
                                  'Eliminar la venta ${venta.serie}${venta.consecutivo}',
                              description:
                                  'Se esta tratando de eliminar esta venta, oprima el boton de ACEPTAR\npara enviar un codigo de autorización al administrador',
                              loadingTitle: 'Enviando autorizacion...',
                              onAcceptPressed: (context) async {
                                codigo = await SqlOperaciones.solicitarPin();
                                debugPrint('$codigo');
                                Navigation.pop();
                              });
                          if (codigo != null) {
                            await showDialog(
                                context: context,
                                builder: (context) => SDialogPin(
                                    codigo: codigo.toString(),
                                    acepta: (p0) async {
                                      if (venta.sincronizado == 1) {
                                        await SqlOperaciones.eliminarVenta(
                                            fecha: venta.fecha!,
                                            folio: venta.consecutivo.toString(),
                                            serie: venta.serie!,
                                            proNavegacion: provider);
                                        debugPrint('sincronizado');
                                        Navigation.pop();
                                      } else {
                                        await SQLHelperCortePropio.deleteItems(
                                            venta.consecutivo);
                                        debugPrint('no sincronizado');
                                        Navigation.pop();
                                      }
                                    })).then((value) async {
                              if (!folio) {
                                await getFolio();
                              } else {
                                await getFolioNoSync();
                              }
                            });
                          }
                        } else {
                          showToast('No hay conexion a internet');
                        }
                      }
                    },
                    icon: const Icon(Icons.delete_forever_sharp,
                        color: LightThemeColors.red))
              ])
            ])));
  }
}
