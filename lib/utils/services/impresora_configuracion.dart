import 'dart:async';
import 'dart:developer';
import 'package:flutter/rendering.dart';
import 'package:kiosko/utils/main_provider.dart';
import 'package:oktoast/oktoast.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../controllers/printer_controller.dart';
import '../../models/device_model.dart';

class ImpresoraConnect {
  /// Esta Funcion crea una conexion automatica de los dispositivos Bluetooth/USB/WIFI para que esten listos para usar
  ///
  /// Parámetros:
  /// * provider: ingrese su provider que esta usando en su proyecto.
  ///
  /// Consejos: dentro de tu clase genera una variable usando el modelo de [DevicePrinterModel] con el siguiente formato
  ///
  /// List<DevicePrinterModel> _devices = [];
  /// List<DevicePrinterModel> get devices => _devices;
  /// set devices(List<DevicePrinterModel> valor) {
  /// _devices = valor;
  /// notifyListeners();
  /// }
  ///
  static Future<void> conectAuto(MainProvider provider) async {
    final device = await PrinterController.getItems();
    await PrintBluetoothThermal.disconnect;
    log('almacen: ${device.map((e) => "${e.name} - ${e.connectionTypes}").toList()}');
    bool result = false;
    for (var element in device) {
        PrinterModel newDevice = PrinterModel(
            name: element.name!,
            address: element.address,
            connectionTypes: element.connectionTypes,
            isConnected: element.isConnected,
            productId: element.productId,
            vendorId: element.vendorId);
        log("${newDevice.toJson()}");
        result = await PrintBluetoothThermal.connect(
            macPrinterAddress: newDevice.address ?? "");
      
      Future.delayed(Duration(milliseconds: 500), () {
        debugPrint("$result");
        provider.devices.add(element);
        if (result) {
          debugPrint("$result");
          provider.selectDevice = element;
          log('Conexion establecida\n${provider.selectDevice!.toJson()}');
          showToast('Conexion Establecida');
        }
        debugPrint("$result");
      });
    }
  }

  static Future<PrinterModel?> verificar(PrinterModel actual) async {
    log("${actual.toJson()}");
    bool result = false;
    await PrintBluetoothThermal.disconnect;
    PrinterModel device = actual;
    try {
      showToast("Estableciendo conexion con la impresora");
      result = await PrintBluetoothThermal.connect(
              macPrinterAddress: actual.address ?? "");

      if (!result) {
        showToast(
            "No se pudo establecer conexion con la impresora\n${actual.connectionTypes}");
      }
    } catch (e) {
      log("$e");
    }

    return result ? device : null;
  }

  /* static Future<bool> connectDevice(
      PrinterDevice selectedPrinter, PrinterType type,
      {bool reconnect = false, bool isBle = false, String? ipAddress}) async {
    bool conexion = false;
    switch (type) {
      case PrinterType.usb:
        conexion = await PrinterManager.instance.connect(
            type: type,
            model: UsbPrinterInput(
                name: selectedPrinter.name,
                productId: selectedPrinter.productId,
                vendorId: selectedPrinter.vendorId));
        break;
      case PrinterType.bluetooth:
        await Future.delayed(const Duration(seconds: 2), () async {
          conexion = await PrinterManager.instance.connect(
              type: type,
              model: BluetoothPrinterInput(
                  name: selectedPrinter.name,
                  address: selectedPrinter.address!,
                  isBle: isBle,
                  autoConnect: reconnect));
        });
        log('${selectedPrinter.address}');
        break;
      case PrinterType.network:
        await PrinterManager.instance.connect(
            type: type,
            model: TcpPrinterInput(
                ipAddress: ipAddress ?? selectedPrinter.address!));
        conexion = true;
        break;
    }

    return conexion;
  } */

  /// Esta Funcion crea una conexion automatica en caso de que se detecte que se ha conectado un cable USB al dispositivo
  ///
  /// Parámetros:
  /// * provider: ingrese su provider que esta usando en su proyecto.
  ///
  /// Consejos: dentro de tu clase genera una variable usando el modelo de [DevicePrinterModel] con el siguiente formato
  ///
  /// DevicePrinterModel? _selectDevice;
  /// DevicePrinterModel? get selectDevice => _selectDevice;
  /// set selectDevice(DevicePrinterModel? valor) {
  ///  _selectDevice = valor;
  ///  notifyListeners();
  /// }
  ///
}
