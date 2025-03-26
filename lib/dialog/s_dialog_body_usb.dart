import 'dart:async';
import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:kiosko/utils/main_provider.dart';
import 'package:kiosko/utils/services/navigation_service.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_usb/smart_usb.dart';
import '../controllers/printer_controller.dart';
import '../models/device_model.dart';
import '../theme/app_colors.dart';
import '../utils/services/dialog_services.dart';
import '../utils/textos.dart';

class DialogImpresora extends StatefulWidget {
  const DialogImpresora({super.key});

  @override
  State<DialogImpresora> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<DialogImpresora> {
  SingleSelectController<String> controller = SingleSelectController(null);
  final ScrollController _scrollCompra = ScrollController();
  List<BluetoothInfo> bleInfo = [];
  String? tipoPrinter;
  PaperSize tipoPapel = PaperSize.mm80;
  List<UsbDeviceDescription> listUSB = [];
  /* PrinterDevice? selectDevice;
  List<PrinterDevice> dispositivosPrint = []; */
  bool starscan = false;
  static Map mmPaper = {
    PaperSize.mm80.value: '80mm',
    PaperSize.mm72.value: '72mm',
    PaperSize.mm58.value: '58mm'
  };

  List<String> Connection = ["USB", "BLUETOOTH"];

  @override
  void initState() {
    super.initState();
    
    obtenerPermisoBluetooth();
    
  }

  Future<void> scanUsb() async {
    listUSB.clear();
    var descriptions =
        await SmartUsb.getDevicesWithDescription(requestPermission: true);
    debugPrint("$descriptions");
    listUSB = descriptions;
    setState(() {});
  }

  Future<bool> connectDevice(UsbDeviceDescription device) async {
    var isConnect = await SmartUsb.connectDevice(device.device);
    debugPrint("$device");
    return isConnect;
  }

  Future<void> obtenerPermisoBluetooth() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.locationWhenInUse,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.bluetooth,
      Permission.bluetoothAdvertise
    ].request();
    await SmartUsb.init();
    await scanUsb();
    debugPrint('scan: $statuses');
  }

  Future<void> startScan() async {
    try {
      starscan = true;
      bleInfo = await PrintBluetoothThermal.pairedBluetooths;
      setState(() {});
      starscan = false;
      /* await _devicesStreamSubscription?.cancel();
      await thermal.getPrinters(
          connectionTypes: [tipo], refreshDuration: Duration(seconds: 3));
      _devicesStreamSubscription =
          thermal.devicesStream.listen((List<Printer> event) {
        log(event.map((e) => e.name).toList().toString());
        setState(() {
          starscan = false;
          bleDevices = event;

          bleDevices.removeWhere(
              (element) => element.name == null || element.name == '');
        });
      }); */
    } catch (e) {
      log('fallo al escanear los dispositivos\n$e');
    }
  }

  // Stop scanning for BLE devices
  Future<void> stopScan() async {
    try {
      //await thermal.stopScan();
      bleInfo.clear();
      starscan = false;
    } catch (e) {
      log('Fallo al escanear los dispositivos$e');
    }
  }

  @override
  void dispose() {
    stopScan();
    super.dispose();
  }

  Future<bool> ingresarImpresora(
      {required PrinterModel? device,
      required UsbDeviceDescription? usb}) async {
    await PrintBluetoothThermal.disconnect;
    showToast('Estableciendo conexion con ${device?.name ?? usb?.product}');
    log("${device?.toJson() ?? usb?.toMap()}");
    var result = device != null
        ? await PrintBluetoothThermal.connect(
            macPrinterAddress: device.address ?? "")
        : await connectDevice(usb!);
    if (result) {
      showToast('conexion exitosa');
      PrinterModel newDevice = PrinterModel(
          manufacturer: usb?.manufacturer,
          serialNumber: usb?.serialNumber,
          usbDevice: usb?.device,
          name: device?.name ?? usb!.product,
          address: device?.address,
          vendorId: device?.vendorId ?? usb?.device.vendorId.toString(),
          productId: device?.productId ?? usb?.device.productId.toString(),
          paper: tipoPapel,
          connectionTypes: device?.connectionTypes ?? "USB",
          isConnected: int.tryParse(device?.isConnected.toString() ?? ""));
      await PrinterController.insertPrinter(newDevice);
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
                    decoration: CustomDropdownDecoration(
                        closedSuffixIcon: Icon(tipoPrinter == "BLUETOOTH"
                            ? Icons.bluetooth
                            : tipoPrinter == "USB"
                                ? Icons.usb
                                : Icons.device_unknown)),
                    items: Connection.toList(),
                    excludeSelected: true,
                    initialItem: null,
                    onChanged: (value) async {
                      await stopScan();
                      setState(() {
                        tipoPrinter = Connection.firstWhere((element) => element
                            .toLowerCase()
                            .contains(value!.toLowerCase()));
                        log("$tipoPrinter");
                      });
                      if (tipoPrinter == "USB") {
                        await scanUsb();
                      } else {
                        await startScan();
                      }
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
                    listItemBuilder: (context, item, isSelected, onItemSelect) {
                      return Text(item == PaperSize.mm80
                          ? "80 mm"
                          : item == PaperSize.mm72
                              ? "72 mm"
                              : "58 mm");
                    },
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
              child: bleInfo.isEmpty && listUSB.isEmpty
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
                                  itemCount: tipoPrinter == "USB"
                                      ? listUSB.length
                                      : bleInfo.length,
                                  itemBuilder: (context, index) {
                                    if (tipoPrinter == "USB") {
                                      UsbDeviceDescription device =
                                          listUSB[index];
                                      return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            listTileUsb(device, provider),
                                            Divider(height: 1.h)
                                          ]);
                                    } else {
                                      PrinterModel device = PrinterModel(
                                          name: bleInfo[index].name,
                                          address: bleInfo[index].macAdress);
                                      return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            listTileDevice(device, provider),
                                            Divider(height: 1.h)
                                          ]);
                                    }
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
            '${device.name} ${deviceActual ? '| ${mmPaper[provider.selectDevice!.paper!.value]}' : ''}',
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
                  //bool result = await thermal.connect(device);
                  await PrintBluetoothThermal.disconnect;
                  var result = await PrintBluetoothThermal.connect(
                      macPrinterAddress: device.address ?? "");
                  if (result) {
                    await prinTest(
                        dispositivoPrint: device,
                        ubsprint: null,
                        papelPrint: tipoPapel);
                  } else {
                    showToast('Perdida de conexion con la impresora');
                  }
                })
            : guardado || deviceActual
                ? IconButton(
                    tooltip: 'Eliminar dispositivo',
                    icon: const Icon(Icons.delete_outline,
                        color: LightThemeColors.red),
                    onPressed: () async {
                      Dialogs.showMorph(
                          title: 'Eliminar',
                          description:
                              '¿Desea eliminar configuracion de este dispositivo?',
                          loadingTitle: 'Eliminando',
                          onAcceptPressed: (context) async {
                            PrinterModel newModel = PrinterModel(
                                manufacturer: null,
                                serialNumber: null,
                                usbDevice: null,
                                name: device.name,
                                address: device.address,
                                vendorId: device.vendorId,
                                productId: device.productId,
                                paper: tipoPapel,
                                connectionTypes: device.connectionTypes,
                                isConnected: device.isConnected);
                            await PrinterController.deleteDispositivo(newModel);
                            provider.devices =
                                await PrinterController.getItems();
                            Navigation.pop();
                          });
                    })
                : null,
        onTap: () async {
          bool resultado = await ingresarImpresora(device: device, usb: null);
          if (resultado) {
            PrinterModel newModel = PrinterModel(
                manufacturer: null,
                serialNumber: null,
                usbDevice: null,
                name: device.name,
                address: device.address,
                vendorId: device.vendorId,
                productId: device.productId,
                paper: tipoPapel,
                connectionTypes: device.connectionTypes,
                isConnected: device.isConnected);
            provider.selectDevice = newModel;
          }
        });
  }

  ListTile listTileUsb(
      UsbDeviceDescription device, MainProvider provider) {
    bool deviceActual = ((provider.selectDevice?.vendorId ==
            device.device.vendorId.toString()) &&
        provider.selectDevice?.name == device.product);
    bool guardado = ((provider.devices
                .where((element) =>
                    element.name == device.product &&
                    (element.vendorId == device.device.vendorId.toString()))
                .toList())
            .firstOrNull
            ?.name ==
        device.product);
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
            '${device.product} ${deviceActual ? '| ${mmPaper[provider.selectDevice!.paper!.value]}' : ''}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle:
            Text('${device.device.productId} - ${device.device.vendorId}'),
        dense: true,
        trailing: deviceActual
            ? IconButton(
                tooltip: 'imprimir test',
                icon: const Icon(Icons.find_in_page,
                    color: LightThemeColors.darkBlue),
                onPressed: () async {
                  showToast("Verificando conexion con ${device.product}");
                  final result = await connectDevice(device);
                  if (result) {
                    await prinTest(
                        dispositivoPrint: null,
                        ubsprint: device,
                        papelPrint: tipoPapel);
                  } else {
                    showToast("No se pudo conectar con ${device.product}");
                  }
                })
            : guardado || deviceActual
                ? IconButton(
                    tooltip: 'Eliminar dispositivo',
                    icon: const Icon(Icons.delete_outline,
                        color: LightThemeColors.red),
                    onPressed: () async {
                      Dialogs.showMorph(
                          title: 'Eliminar',
                          description:
                              '¿Desea eliminar configuracion de este dispositivo?',
                          loadingTitle: 'Eliminando',
                          onAcceptPressed: (context) async {
                            PrinterModel newModel = PrinterModel(
                                manufacturer: device.manufacturer,
                                serialNumber: device.serialNumber,
                                usbDevice: device.device,
                                name: device.product,
                                address: null,
                                vendorId: device.device.vendorId.toString(),
                                productId: device.device.productId.toString(),
                                paper: tipoPapel,
                                connectionTypes: tipoPrinter,
                                isConnected: null);
                            log("${newModel.toJson()}");
                            await PrinterController.deleteDispositivo(newModel);
                            provider.devices =
                                await PrinterController.getItems();
                            Navigation.pop();
                          });
                    })
                : null,
        onTap: () async {
          bool resultado = await ingresarImpresora(device: null, usb: device);
          if (resultado) {
            PrinterModel newModel = PrinterModel(
                manufacturer: device.manufacturer,
                serialNumber: device.serialNumber,
                usbDevice: device.device,
                name: device.product,
                address: null,
                vendorId: device.device.vendorId.toString(),
                productId: device.device.productId.toString(),
                paper: tipoPapel,
                connectionTypes: tipoPrinter,
                isConnected: null);
            provider.selectDevice = newModel;
          }
        });
  }

  Future<void> prinTest(
      {required PrinterModel? dispositivoPrint,
      required UsbDeviceDescription? ubsprint,
      required PaperSize papelPrint}) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(papelPrint, profile);
    List<int> bytes = [];
    bytes += generator.reset();
    bytes += generator.text(
        Textos.normalizar(
            'Impresion De Prueba\n${dispositivoPrint?.name ?? ubsprint!.product}'),
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
    if (dispositivoPrint != null) {
      await PrintBluetoothThermal.writeBytes(bytes);
    } else {
      log("enviar datos de impresora");
      var result = await SmartUsb.send(bytes);
      log("$result");
    }
  }
}
