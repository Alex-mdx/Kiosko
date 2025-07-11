import 'package:flutter/widgets.dart';
import 'package:kiosko/controllers/user_controller.dart';
import 'package:kiosko/utils/funcion_parser.dart';
import 'package:kiosko/utils/main_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/empresa_model.dart';
import '../utils/route/link.dart';
//Services

String nombreDB = "empresa";

class EmpresaController {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
    CREATE TABLE $nombreDB(
        id INTEGER,
        nombre TEXT,
        rfc TEXT,
        marca TEXT,
        eslogan TEXT,
        logo TEXT,
        razon_social TEXT,
        representante_legal TEXT,
        fecha_constitucion TEXT,
        direccion_id INTEGER,
        database_id INTEGER,
        url TEXT,
        curp TEXT,
        registro_patronal TEXT,
        regimen_fiscal TEXT,
        ciec INTEGER,
        perfil_impuesto_compra INTEGER,
        perfil_impuesto_venta INTEGER,
        clave INTEGER,
        telefono INTEGER,
        correo INTEGER,
        file INTEGER
    )
""");
  }

  static Future<sql.Database> database() async {
    return sql.openDatabase('app_$nombreDB.db', version: 1,
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
    await db1.execute('ALTER TABLE $nombreDB ADD COLUMN $columnaAdd TEXT');
    return false;
  }

  static Future<void> getApiEmpresa(MainProvider provider) async {
    final user = await UserController.getItem();
    final connJson = Uri.parse(
        "${Link.apiEmpresa}${user?.databaseId}&api_key=${user?.uuid}");
    List<EmpresaModel> getLineas = [];
    var response = await http.get(connJson);
    String responseBody = response.body;
    var jsonBody = json.decode(responseBody);

    final db = await database();
    await db.delete(nombreDB);

    for (var data in jsonBody) {
      String? file;
      if (data["logo"] != null) {
        file = (await Parser.descargaImagen(data["logo"]!)).toString();
      }
      getLineas.add(EmpresaModel(
          id: data["id"],
          file: file,
          nombre: data["nombre"],
          rfc: data["rfc"],
          marca: data["marca"],
          eslogan: data["eslogan"],
          logo: data["logo"],
          razonSocial: data["razon_social"],
          representanteLegal: data["representante_legal"],
          fechaConstitucion: data["fecha_constitucion"],
          direccionId: data["direccion_id"],
          url: data["url"],
          curp: data["curp"],
          registroPatronal: data["registro_patronal"],
          regimenFiscal: data["regimen_fiscal"],
          ciec: data["ciec"],
          perfilImpuestoCompra: data["perfil_impuesto_compra"],
          perfilImpuestoVenta: data["perfil_impuesto_venta"],
          clave: data["clave"],
          telefono: data["telefono"],
          correo: data["correo"]));
    }
    for (var element in getLineas) {
      await db.insert(nombreDB, element.toJson(),
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
    }
  }

  static Future<List<EmpresaModel>> getItems() async {
    final db = await database();

    List<EmpresaModel> modelado = [];
    final data = await db.query(nombreDB, orderBy: "id");
    for (var element in data) {
      modelado.add(EmpresaModel.fromJson(element));
    }

    return modelado;
  }

  static Future<EmpresaModel?> getItem(int id) async {
    final db = await database();

    var data =
        (await db.query(nombreDB, where: "id = ?", whereArgs: [id], limit: 1))
            .firstOrNull;
    return data == null ? null : EmpresaModel.fromJson(data);
  }
}
