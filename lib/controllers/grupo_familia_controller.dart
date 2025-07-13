import 'package:flutter/material.dart';
import 'package:kiosko/controllers/user_controller.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/grupo_producto_model.dart';
import '../utils/route/link.dart';

String nombreDB = "grupo_producto";

class GrupoFamiliaController {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE $nombreDB(
          id INTEGER,
          nombre TEXT
      )""");
  }

  static Future<sql.Database> database() async {
    return sql.openDatabase('app_pos_$nombreDB.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<bool> existColumna(String columnaAdd) async {
    final db1 = await database();
    List<Map<String, dynamic>> columnas =
        await db1.rawQuery('PRAGMA table_info($nombreDB)');

    for (Map<String, dynamic> columna in columnas) {
      String name = columna['name'];
      if (name == columnaAdd) {
        debugPrint('existe $columnaAdd');
        return true;
      }
    }
    debugPrint('agregando $columnaAdd');
    await db1.execute('ALTER TABLE $nombreDB ADD COLUMN $columnaAdd INTEGER');
    return false;
  }

  static Future<void> getApi() async {
    final user = await UserController.getItem();
    final connJson =
        Uri.parse("${Link.apiGrupoFamilia}${user?.databaseId}&api_key=${user?.uuid}");
    List<GrupoProductoModel> getLista = [];
    var response = await http.get(connJson);
    String responseBody = response.body;
    var jsonBody = json.decode(responseBody);
    final db = await database();
    await db.delete(nombreDB);
    for (var data in jsonBody) {
      getLista.add(GrupoProductoModel.fromJson(data));
    }
    for (var element in getLista) {
      await db.insert(nombreDB, element.toJson(),
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
    }
  }

  static Future<List<GrupoProductoModel>> getItems() async {
    final db = await database();
    List<GrupoProductoModel> categoriaModelo = [];
    List<Map<String, dynamic>> categoria =
        await db.query(nombreDB, orderBy: "nombre");
    for (var element in categoria) {
      categoriaModelo.add(GrupoProductoModel.fromJson(element));
    }
    return categoriaModelo;
  }

  static Future<GrupoProductoModel?> getItem(int id) async {
    final db = await database();
    final data = (await db.query(nombreDB, where: "id = ?", whereArgs: [id]))
        .firstOrNull;
    GrupoProductoModel? modelado =
        data == null ? null : GrupoProductoModel.fromJson(data);
    return modelado;
  }

  static Future<void> updateItem(GrupoProductoModel categoria) async {
    final db = await database();
    await db.update(nombreDB, categoria.toJson(),
        where: "id = ?", whereArgs: [categoria.id]);
  }
}
