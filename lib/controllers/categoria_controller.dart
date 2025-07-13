// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:kiosko/controllers/user_controller.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/categoria_model.dart';
import '../utils/funcion_parser.dart';
import '../utils/route/link.dart';
//Models

class CategoriaController {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE categoria(
          id INTEGER,
          nombre TEXT,
          database_id INTEGER,
          press INTEGER,
          numerable INTEGER
      )""");
  }

  static Future<sql.Database> database() async {
    return sql.openDatabase('app_pos_categoria.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<bool> existColumna(String columnaAdd) async {
    final db1 = await database();
    List<Map<String, dynamic>> columnas =
        await db1.rawQuery('PRAGMA table_info(categoria)');

    for (Map<String, dynamic> columna in columnas) {
      String name = columna['name'];
      if (name == columnaAdd) {
        debugPrint('existe $columnaAdd');
        return true;
      }
    }
    debugPrint('agregando $columnaAdd');
    await db1.execute('ALTER TABLE categoria ADD COLUMN $columnaAdd INTEGER');
    return false;
  }

  static Future<void> getApiCategoria() async {
    final user = await UserController.getItem();
    final connJson = Uri.parse("${Link.apiCategorias}${user?.databaseId}&api_key=${user?.uuid}");
    List<CategoriaModel> getLista = [];
    var response = await http.get(connJson);
    String responseBody = response.body;
    var jsonBody = json.decode(responseBody);
    final db = await database();
    await db.delete('categoria');
    for (var data in jsonBody) {
      if (Parser.toInt(data['punto_venta']) == 1) {
        getLista.add(CategoriaModel(
            id: data['id'],
            nombre: data['nombre'],
            databaseId: data['database_id'],
            numerable: 0,
            press: 0));
      }
    }
    for (var element in getLista) {
      await db.insert('categoria', element.toJson(),
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
    }
  }

  static Future<List<CategoriaModel>> getItems() async {
    final db = await database();
    List<CategoriaModel> categoriaModelo = [];
    List<Map<String, dynamic>> categoria =
        await db.query('categoria', orderBy: "nombre");
    for (var element in categoria) {
      categoriaModelo.add(CategoriaModel.fromJson(element));
    }
    return categoriaModelo;
  }

  static Future<CategoriaModel?> getItem(int id) async {
    final db = await database();
    final data = (await db.query('categoria', where: "id = ?", whereArgs: [id]))
        .firstOrNull;
    CategoriaModel? modelado =
        data == null ? null : CategoriaModel.fromJson(data);
    return modelado;
  }

  static Future<void> updateItem(CategoriaModel categoria) async {
    final db = await database();
    await db.update("categoria", categoria.toJson(),
        where: "id = ?", whereArgs: [categoria.id]);
  }
}
