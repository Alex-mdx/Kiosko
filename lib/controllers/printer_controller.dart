import 'dart:developer';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:thermal_printer_plus/thermal_printer.dart';

import '../models/device_model.dart';

String nombreDb = "device";

class PrinterController {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE $nombreDb(
        name TEXT,
        address TEXT,
        vendor_id TEXT,
        product_id TEXT,
        paper TEXT,
        connection_types TEXT,
        is_connected INTEGER,
        manufacturer INTEGER,
        serial_number INTEGER,
        usb_device INTEGER
      )""");
  }

  static Future<sql.Database> database() async {
    return sql.openDatabase('app_pos_device.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<bool> existColumna(String columnaAdd) async {
    final db1 = await database();
    List<Map<String, dynamic>> columnas =
        await db1.rawQuery('PRAGMA table_info($nombreDb)');

    for (Map<String, dynamic> columna in columnas) {
      String name = columna['name'];
      if (name == columnaAdd) {
        debugPrint('existe $columnaAdd');
        return true;
      }
    }
    debugPrint('agregando $columnaAdd');
    await db1.execute('ALTER TABLE $nombreDb ADD COLUMN $columnaAdd INTEGER');
    return false;
  }

  static Future<void> insertPrinter(PrinterModel dispositivo) async {
    final db = await database();
    final data = await db.query(nombreDb);
    await existColumna("manufacturer");
    await existColumna("serial_number");
    await existColumna("usb_device");
    log('${dispositivo.toJson()}');
    if (data.isEmpty) {
      await db.insert(
          nombreDb,
          {
            "name": dispositivo.name,
            "address": dispositivo.address,
            "is_connected": dispositivo.isConnected,
            "vendor_id": dispositivo.vendorId,
            "product_id": dispositivo.productId,
            "paper": dispositivo.paper == PaperSize.mm80
                ? "80"
                : dispositivo.paper == PaperSize.mm72
                    ? "72"
                    : "58",
            "manufacturer": dispositivo.manufacturer,
            "serial_number": dispositivo.serialNumber,
            "connection_types":
                dispositivo.connectionTypes == PrinterType.bluetooth
                    ? "BLUETOOTH"
                    : dispositivo.connectionTypes == PrinterType.usb
                        ? "USB"
                        : "NETWORK"
          },
          conflictAlgorithm: sql.ConflictAlgorithm.rollback);
      debugPrint('inserto');
    } else {
      bool coincidencia = false;
      for (var element in data) {
        if (element['name'] == dispositivo.name &&
            (element['address'] == dispositivo.address ||
                (element['vendor_id'] == dispositivo.vendorId &&
                    element['product_id'] == dispositivo.productId))) {
          coincidencia = true;
        }
      }
      debugPrint('$coincidencia');
      if (coincidencia) {
        await update(dispositivo);
      } else {
        await db.insert(nombreDb, dispositivo.toJson(),
            conflictAlgorithm: sql.ConflictAlgorithm.rollback);
      }
    }
  }

  static Future<List<PrinterModel>> getItems() async {
    final db = await database();
    final data = await db.query(nombreDb, orderBy: "name");
    List<PrinterModel> modelado = [];
    for (var element in data) {
      modelado.add(PrinterModel.fromJson(element));
    }
    return modelado;
  }

  static Future<void> update(PrinterModel dispositivo) async {
    final db = await database();
    await db.update(
        nombreDb,
        {
          "name": dispositivo.name,
          "address": dispositivo.address,
          "is_connected": dispositivo.isConnected,
          "vendor_id": dispositivo.vendorId,
          "product_id": dispositivo.productId,
          "paper": dispositivo.paper == PaperSize.mm80
              ? "80"
              : dispositivo.paper == PaperSize.mm72
                  ? "72"
                  : "58",
          "manufacturer": dispositivo.manufacturer,
          "serial_number": dispositivo.serialNumber,
          "connection_types":
              dispositivo.connectionTypes == PrinterType.bluetooth
                  ? "BLUETOOTH"
                  : dispositivo.connectionTypes == PrinterType.usb
                      ? "USB"
                      : "NETWORK"
        },
        where: 'name = ? AND connection_types = ?',
        whereArgs: [
          dispositivo.name,
          dispositivo.connectionTypes == PrinterType.bluetooth
              ? "BLUETOOTH"
              : dispositivo.connectionTypes == PrinterType.usb
                  ? "USB"
                  : "NETWORK"
        ],
        conflictAlgorithm: sql.ConflictAlgorithm.rollback);
  }

  static Future<void> deleteAllItems() async {
    final db = await database();
    await db.delete(nombreDb);
  }

  static Future<void> deleteDispositivo(PrinterModel device) async {
    final db = await database();
    await db.delete(nombreDb,
        where: 'name = ? AND connection_types = ?',
        whereArgs: [
          device.name,
          device.connectionTypes == PrinterType.bluetooth
              ? "BLUETOOTH"
              : device.connectionTypes == PrinterType.usb
                  ? "USB"
                  : "NETWORK"
        ]);
  }
}
