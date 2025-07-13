import 'dart:async';
import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:kiosko/utils/main_provider.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:thermal_printer_plus/thermal_printer.dart';
import '../controllers/printer_controller.dart';
import '../models/device_model.dart';
import '../theme/app_colors.dart';
import '../utils/services/dialog_services.dart';
import '../utils/services/impresora_configuracion.dart';
import '../utils/services/navigation_service.dart';
import '../utils/textos.dart';

class DialogImpresora extends StatefulWidget {
  const DialogImpresora({super.key});

  @override
  State<DialogImpresora> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<DialogImpresora> {
  SingleSelectController<String> controller = SingleSelectController(null);
  final ScrollController _scrollCompra = ScrollController();
  var printer = PrinterManager.instance;
  PrinterType? tipoPrinter;
  List<PrinterModel> devices = [];
  PaperSize tipoPapel = PaperSize.mm80;
  /* PrinterDevice? selectDevice;
  List<PrinterDevice> dispositivosPrint = []; */
  bool starscan = false;
  static Map mmPaper = {
    PaperSize.mm80.value: '80mm',
    PaperSize.mm72.value: '72mm',
    PaperSize.mm58.value: '58mm'
  };

  List<PrinterType> Connection = [
    PrinterType.bluetooth,
    PrinterType.usb,
    //PrinterType.network
  ];

  @override
  void initState() {
    super.initState();
    obtenerPermisoBluetooth();
  }

  Future<void> scan(PrinterType type, bool? ble) async {
    PrinterManager.instance
        .discovery(type: type, isBle: ble ?? false)
        .listen((device) {
      setState(() {
        devices.add(PrinterModel(
            name: device.name,
            address: device.address,
            vendorId: device.vendorId,
            productId: device.productId,
            connectionTypes: type,
            manufacturer: device.operatingSystem));
      });
    });
  }

  Future<void> obtenerPermisoBluetooth() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.locationWhenInUse,
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
      Permission.nearbyWifiDevices,
    ].request();
    debugPrint('scan: $statuses');
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> ingresarImpresora({required PrinterModel? device}) async {
    await printer.disconnect(type: device!.connectionTypes!);
    showToast('Estableciendo conexion con ${device.name}');
    log("${device.toJson()}");
    var result = await ImpresoraConnect.conectar(device);
    if (result) {
      showToast('conexion exitosa');
      await PrinterController.insertPrinter(device);
      return true;
    } else {
      showToast('No se pudo establecer la conexion');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      AppBar(
          title: Text('Seleccion de impresora',
              style: TextStyle(fontSize: 14.sp))),
      Padding(
          padding: EdgeInsets.all(3.sp),
          child: Row(children: [
            Expanded(
                flex: 1,
                child: CustomDropdown(
                    hintText: 'Tipo de conexion',
                    listItemBuilder:
                        (context, item, isSelected, onItemSelect) => Text(
                            item == PrinterType.usb
                                ? "USB"
                                : item == PrinterType.bluetooth
                                    ? "BLUETOOTH"
                                    : "NETWORK",
                            style: TextStyle(fontSize: 12.sp)),
                    headerBuilder: (context, selectedItem, enabled) => Text(
                        selectedItem == PrinterType.usb
                            ? "USB"
                            : selectedItem == PrinterType.bluetooth
                                ? "BLUETOOTH"
                                : "NETWORK",
                        style: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.bold)),
                    decoration: CustomDropdownDecoration(
                        closedSuffixIcon: Icon(
                            size: 18.sp,
                            tipoPrinter == PrinterType.bluetooth
                                ? Icons.bluetooth
                                : tipoPrinter == PrinterType.usb
                                    ? Icons.usb
                                    : tipoPrinter == PrinterType.bluetooth
                                        ? Icons.wifi
                                        : Icons.device_unknown)),
                    items: Connection,
                    excludeSelected: true,
                    initialItem: null,
                    onChanged: (value) async {
                      devices.clear();
                      setState(() {
                        tipoPrinter = value;
                      });
                      await scan(tipoPrinter!, null);
                    })),
            Expanded(
                flex: 1,
                child: CustomDropdown(
                    excludeSelected: true,
                    initialItem: tipoPapel,
                    decoration: CustomDropdownDecoration(
                        closedSuffixIcon: Icon(tipoPapel == PaperSize.mm80
                            ? Icons.density_large
                            : tipoPapel == PaperSize.mm72
                                ? Icons.density_medium
                                : Icons.density_small)),
                    headerBuilder: (context, selectedItem, enabled) => Text(
                        selectedItem == PaperSize.mm80
                            ? "80 mm"
                            : selectedItem == PaperSize.mm72
                                ? "72 mm"
                                : "58 mm",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    items: const [
                      PaperSize.mm80,
                      PaperSize.mm72,
                      PaperSize.mm58
                    ],
                    listItemBuilder:
                        (context, item, isSelected, onItemSelect) =>
                            Text(item == PaperSize.mm80
                                ? "80 mm"
                                : item == PaperSize.mm72
                                    ? "72 mm"
                                    : "58 mm"),
                    onChanged: (p0) => setState(() {
                          log('${tipoPapel.value} - $p0');
                          tipoPapel = p0!;
                        })))
          ])),
      Padding(
          padding: EdgeInsets.all(6.sp),
          child: Container(
              width: 75.w,
              constraints: BoxConstraints(maxHeight: 70.h),
              child: devices.isEmpty
                  ? Column(mainAxisSize: MainAxisSize.min, children: [
                      starscan == true
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator())
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                      'No existen dispositivos disponibles${tipoPrinter != null ? '\n Para la conexion ${tipoPrinter!}' : ''}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold))))
                    ])
                  : Consumer<MainProvider>(builder: (context, provider, child) {
                      return Padding(
                          padding: EdgeInsets.all(4.sp),
                          child: Scrollbar(
                              controller: _scrollCompra,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: devices.length,
                                  itemBuilder: (context, index) {
                                    PrinterModel print = devices[index];

                                    return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          listTileDevice(print, provider),
                                          Divider(height: 1.h)
                                        ]);
                                  })));
                    })))
    ]);
  }

  ListTile listTileDevice(PrinterModel device, MainProvider provider) {
    bool deviceActual = ((provider.selectDevice?.address == device.address ||
            provider.selectDevice?.vendorId == device.vendorId) &&
        provider.selectDevice?.name == device.name);
    bool guardado = ((provider.devices
                .where((element) =>
                    element.name == device.name &&
                    (element.address == device.address ||
                        element.vendorId == device.vendorId))
                .toList())
            .firstOrNull
            ?.name ==
        device.name);
    return ListTile(
        leading: deviceActual
            ? IconButton(
                icon: const Icon(Icons.link, color: LightThemeColors.green),
                onPressed: () {
                  showToast('Dispositivo Enlanzado');
                })
            : !guardado
                ? IconButton(
                    icon: const Icon(Icons.device_hub,
                        color: LightThemeColors.primary),
                    onPressed: () {
                      showToast('Dispositivo Disponible');
                    })
                : IconButton(
                    icon: const Icon(Icons.add_link,
                        color: LightThemeColors.yellow),
                    onPressed: () {
                      showToast('Dispositivo Almacenado Disponible');
                    }),
        title: Text(
            '${device.name} ${deviceActual ? '| ${mmPaper[provider.selectDevice?.paper?.value ?? 1]}' : ''}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle:
            Text(device.address ?? '${device.productId} - ${device.vendorId}'),
        dense: true,
        trailing: deviceActual
            ? IconButton(
                tooltip: 'imprimir test',
                icon: const Icon(Icons.find_in_page,
                    color: LightThemeColors.darkBlue),
                onPressed: () async {
                  showToast("Verificando conexion con ${device.name}");

                  final result = await ImpresoraConnect.conectar(device);
                  if (result) {
                    await prinTest(
                        dispositivoPrint: device, papelPrint: tipoPapel);
                  } else {
                    showToast("No se pudo conectar con ${device.name}");
                  }
                })
            : guardado || deviceActual
                ? IconButton(
                    tooltip: 'Eliminar dispositivo',
                    icon: const Icon(Icons.delete_outline,
                        color: LightThemeColors.red),
                    onPressed: () async => Dialogs.showMorph(
                        title: 'Eliminar',
                        description:
                            '¿Desea eliminar configuracion de este dispositivo?',
                        loadingTitle: 'Eliminando',
                        onAcceptPressed: (context) async {
                          await PrinterController.deleteDispositivo(device);
                          provider.devices = await PrinterController.getItems();
                          Navigation.pop();
                        }))
                : null,
        onTap: () async {
          var newPrint = device.copyWith(paper: tipoPapel);
          bool resultado = await ingresarImpresora(device: newPrint);
          if (resultado) {
            provider.selectDevice = newPrint;
          }
        });
  }

  Future<void> prinTest(
      {required PrinterModel dispositivoPrint,
      required PaperSize papelPrint}) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(papelPrint, profile);
    List<int> bytes = [];
    bytes += generator.reset();
    bytes += generator.text(
        Textos.normalizar(
            'Impresion De Prueba\n${dispositivoPrint.name ?? "Desconocido"}'),
        styles: const PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.row([
      PosColumn(
          text: '1', width: 1, styles: const PosStyles(align: PosAlign.center)),
      PosColumn(
          text: '2', width: 1, styles: const PosStyles(align: PosAlign.center)),
      PosColumn(
          text: '3', width: 1, styles: const PosStyles(align: PosAlign.center)),
      PosColumn(
          text: '4', width: 1, styles: const PosStyles(align: PosAlign.center)),
      PosColumn(
          text: '5', width: 1, styles: const PosStyles(align: PosAlign.center)),
      PosColumn(
          text: '6', width: 1, styles: const PosStyles(align: PosAlign.center)),
      PosColumn(
          text: '7', width: 1, styles: const PosStyles(align: PosAlign.center)),
      PosColumn(
          text: '8', width: 1, styles: const PosStyles(align: PosAlign.center)),
      PosColumn(
          text: '9', width: 1, styles: const PosStyles(align: PosAlign.center)),
      PosColumn(
          text: '10',
          width: 1,
          styles: const PosStyles(align: PosAlign.center)),
      PosColumn(
          text: '11',
          width: 1,
          styles: const PosStyles(align: PosAlign.center)),
      PosColumn(
          text: '12', width: 1, styles: const PosStyles(align: PosAlign.center))
    ]);
    bytes += generator.cut();
    await PrinterManager.instance
        .send(type: dispositivoPrint.connectionTypes!, bytes: bytes);
  }
}
