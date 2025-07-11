import 'package:flutter/material.dart';
import 'package:kiosko/controllers/user_controller.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/sucursal_model.dart';
import '../utils/route/link.dart';
//Services

String nombreDb = "sucursal";

class SucursalController {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
    CREATE TABLE $nombreDb(
        id INTEGER,
        nombre TEXT,
        empresa_id INTEGER,
        direccion_id INTEGER,
        direccion TEXT
    )
""");
  }

  static Future<sql.Database> database() async {
    return sql.openDatabase('app_new.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<void> getApi() async {
    final user = await UserController.getItem();
    final connJson =
        Uri.parse("${Link.apiSucursal}${user?.databaseId}&api_key=${user?.uuid}");
    debugPrint("$connJson");
    List<SucursalModel> getLineas = [];
    var response = await http.get(connJson);
    String responseBody = response.body;
    var jsonBody = json.decode(responseBody);

    final db = await database();
    await db.delete(nombreDb);
    for (var element in jsonBody) {
      debugPrint("$element}");
      getLineas.add(SucursalModel(
          id: element["id"],
          nombre: element["nombre"],
          empresaId: element["empresa_id"],
          direccionId: element["direccion_id"]));
    }
    for (var element in getLineas) {
      await db.insert(nombreDb, element.toJson(),
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
    }
  }

  static Future<List<SucursalModel>> getItems() async {
    final db = await database();
    final data = await db.query(nombreDb, orderBy: "id");
    List<SucursalModel> modelo = [];
    for (var element in data) {
      modelo.add(SucursalModel.fromJson(element));
    }
    return modelo;
  }

  static Future<SucursalModel?> getItem() async {
    final db = await database();
    final data = (await db.query(nombreDb, orderBy: "id")).firstOrNull;
    SucursalModel? modelo = data == null ? null : SucursalModel.fromJson(data);
    return modelo;
  }
}
