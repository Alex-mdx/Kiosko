import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

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
        is_connected INTEGER
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
    log('$data');
    if (data.isEmpty) {
      await db.insert(nombreDb, dispositivo.toJson(),
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
    await db.update(nombreDb, dispositivo.toJson(),
        where: 'name = ? AND connection_types = ?',
        whereArgs: [dispositivo.name, dispositivo.connectionTypes],
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
        whereArgs: [device.name, device.connectionTypes]);
  }
}
