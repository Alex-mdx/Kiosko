import 'dart:convert';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:smart_usb/smart_usb.dart';

class PrinterModel {
  String? address;
  String? name;
  int? isConnected;
  String? vendorId;
  String? productId;
  PaperSize? paper;
  String? manufacturer;
  String? serialNumber;
  String? connectionTypes;
  UsbDevice? usbDevice;

  PrinterModel(
      {required this.name,
      required this.address,
      this.isConnected,
      this.vendorId,
      this.productId,
       this.paper,
      this.manufacturer,
      this.serialNumber,
      this.connectionTypes,
      this.usbDevice});

  PrinterModel copyWith(
          {String? name,
          String? address,
          int? isConnected,
          String? vendorId,
          String? productId,
          PaperSize? paper,
          String? manufacturer,
          String? serialNumber,
          String? connectionTypes,
          String? direccion,
          UsbDevice? usbDevice}) =>
      PrinterModel(
          name: name ?? this.name,
          address: address ?? this.address,
          isConnected: isConnected ?? this.isConnected,
          vendorId: vendorId ?? this.vendorId,
          productId: productId ?? this.productId,
          paper: paper ?? this.paper,
          manufacturer: manufacturer ?? this.manufacturer,
          serialNumber: serialNumber ?? this.serialNumber,
          connectionTypes: connectionTypes ?? this.connectionTypes,
          usbDevice: usbDevice ?? this.usbDevice);

  factory PrinterModel.fromJson(Map<String, dynamic> json) => PrinterModel(
      name: json["name"],
      address: json["address"],
      isConnected: json["is_connected"],
      vendorId: json["vendor_id"].toString(),
      productId: json["product_id"].toString(),
      paper: json["paper"] == '80'
          ? PaperSize.mm80
          : json["paper"] == '72'
              ? PaperSize.mm72
              : PaperSize.mm58,
      manufacturer: json["manufacturer"].toString(),
      serialNumber: json["serial_number"].toString(),
      connectionTypes: json["connection_types"],
      usbDevice: json["usb_device"].toString() == "null"
          ? UsbDevice(
              identifier: "", vendorId: 0, productId: 0, configurationCount: 0)
          : UsbDevice.fromMap(jsonDecode(json["usb_device"])));

  Map<String, dynamic> toJson() => {
        "name": name,
        "address": address,
        "is_connected": isConnected,
        "vendor_id": vendorId,
        "product_id": productId,
        "paper": paper == PaperSize.mm80
            ? "80"
            : paper == PaperSize.mm72
                ? "72"
                : "58",
        "manufacturer": manufacturer,
        "serial_number": serialNumber,
        "connection_types": connectionTypes,
        "usb_device": jsonEncode(usbDevice?.toMap())
      };
}
