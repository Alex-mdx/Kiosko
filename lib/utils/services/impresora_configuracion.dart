import 'dart:async';
import 'dart:developer';
import 'package:flutter/rendering.dart';
import 'package:kiosko/utils/main_provider.dart';
import 'package:oktoast/oktoast.dart';
import 'package:thermal_printer_plus/thermal_printer.dart';

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
    log('almacen: ${device.map((e) => "${e.name} - ${e.connectionTypes}").toList()}');
    bool result = false;
    for (var element in device) {
      result = await conectar(element);

      debugPrint("$result");
      provider.devices.add(element);
      if (result) {
        debugPrint("$result");
        provider.selectDevice = element;
        log('Conexion establecida\n${provider.selectDevice!.toJson()}');
        showToast('Conexion Establecida');
        await PrinterManager.instance
            .disconnect(type: element.connectionTypes!);
      }
      debugPrint("$result");
    }
  }

  static Future<bool> conectar(PrinterModel printer,
      {bool reconnect = false, bool isBle = false, String? ipAddress}) async {
    bool result = false;
    switch (printer.connectionTypes!) {
      // only windows and android
      case PrinterType.usb:
        result = await PrinterManager.instance.connect(
            type: printer.connectionTypes!,
            model: UsbPrinterInput(
                name: printer.name,
                productId: printer.productId,
                vendorId: printer.vendorId));
        break;
      // only iOS and android
      case PrinterType.bluetooth:
        result = await PrinterManager.instance.connect(
            type: printer.connectionTypes!,
            model: BluetoothPrinterInput(
                name: printer.name,
                address: printer.address!,
                isBle: isBle,
                autoConnect: reconnect));
        break;
      case PrinterType.network:
        result = await PrinterManager.instance.connect(
            type: printer.connectionTypes!,
            model: TcpPrinterInput(ipAddress: ipAddress ?? printer.address!));
        break;
    }
    if (!result) {
      showToast("No se pudo conectar a la impresora");
    }
    return result;
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
