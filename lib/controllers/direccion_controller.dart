import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kiosko/controllers/user_controller.dart';
import 'package:kiosko/utils/route/link.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../models/direccion_model.dart';

//Services

class DireccionController {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE direcciones(
    id INTEGER ,
    nombre TEXT,
    vialidad TEXT,
    numero_exterior TEXT,
    numero_interior TEXT,
    cruzamiento_1 TEXT,
    cruzamiento_2 TEXT,
    codigo_postal TEXT,
    colonia TEXT,
    localidad TEXT,
    municipio TEXT,
    entidad TEXT,
    pais TEXT,
    latitud TEXT,
    longitud TEXT,
    colonia_id INTEGER,
    localidad_id INTEGER,
    municipio_id INTEGER,
    entidad_id INTEGER,
    pais_id INTEGER
        )""");
  }

  static Future<sql.Database> database() async {
    return sql.openDatabase('app_direcciones.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<void> getApiDireccion(int id) async {
    final user = await UserController.getItem();
    final connJson =
        Uri.parse("${Link.apiDireccion}/$id?database_id=${user?.databaseId}&api_key=${user?.uuid}");
    var response = await http.get(connJson);

    String responseBody = response.body;
    var jsonBody = jsonDecode(responseBody);

    final db = await database();
    DireccionModel getList = DireccionModel(
        jsonBody['id'],
        jsonBody['nombre'],
        jsonBody['vialidad'],
        jsonBody['numero_exterior'],
        jsonBody['numero_interior'],
        jsonBody['cruzamiento_1'],
        jsonBody['cruzamiento_2'],
        jsonBody['codigo_postal'],
        jsonBody['colonia'],
        jsonBody['localidad'],
        jsonBody['municipio'],
        jsonBody['entidad'],
        jsonBody['pais'],
        jsonBody['latitud'],
        jsonBody['longitud'],
        jsonBody['colonia_id'],
        jsonBody['localidad_id'],
        jsonBody['municipio_id'],
        jsonBody['entidad_id'],
        jsonBody['pais_id']);

    final objecto = await getItem(getList.id);
    if (objecto == null) {
      await db.insert('direcciones', getList.toJson(),
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
    } else {
      await db.update("direcciones", getList.toJson(),
          where: "id = ?", whereArgs: [getList.id]);
    }
  }

  static Future<List<DireccionModel>> getItems() async {
    final db = await database();
    List<DireccionModel> modelado = [];
    final data = await db.query('direcciones', orderBy: "id");
    for (var element in data) {
      modelado.add(DireccionModel.fromJson(element));
    }
    return modelado;
  }

  static Future<DireccionModel?> getItem(int id) async {
    final db = await database();
    final data = (await db.query('direcciones',
            where: "id = ?", whereArgs: [id], limit: 1))
        .firstOrNull;
    return data == null ? null : DireccionModel.fromJson(data);
  }
}
