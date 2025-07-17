// ignore_for_file: avoid_print

import 'package:flutter/widgets.dart';
import 'package:kiosko/controllers/user_controller.dart';
import 'package:kiosko/utils/route/link.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/forma_pago_model.dart';
import '../utils/funcion_parser.dart';
//Models

class FormaPagoController {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE formaPago(
          id INTEGER ,
          nombre TEXT,
          database_id INTEGER,
          bancarizado INTEGER,
          depositable INTEGER,
          mostrar_pv INTEGER,
          requiere_referencia INTEGER,
          factor_comision TEXT,
          codigo_sat TEXT,
          cuenta_contable TEXT,
          metodo_pago TEXT,
          forma_pago TEXT,
          moneda TEXT,
          tipo_cambio_default TEXT,
          permitir_cambio INTEGER,
          cuenta_bancaria_id INTEGER,
          credito INTEGER,
          razon_social_id INTEGER,
          defecto INTEGER
      )""");
  }

  static Future<sql.Database> database() async {
    return sql.openDatabase('app_pos_formaPago.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<bool> existColumna(String baseDato, String columnaAdd) async {
    final db1 = await database();
    List<Map<String, dynamic>> columnas =
        await db1.rawQuery('PRAGMA table_info($baseDato)');

    for (Map<String, dynamic> columna in columnas) {
      String name = columna['name'];
      if (name == columnaAdd) {
        debugPrint('existe $columnaAdd');
        return true;
      }
    }
    debugPrint('agregando $columnaAdd');
    await db1.execute('ALTER TABLE $baseDato ADD COLUMN $columnaAdd INTEGER');
    return false;
  }

  static Future<void> getApiFormaPago() async {
    final user = await UserController.getItem();
    final connJson = Uri.parse(
        "${Link.apiFormasPago}${user?.databaseId}&api_key=${user?.uuid}&kiosco=1");
    debugPrint("$connJson");
    List<FormaPagoModel> getprecios = [];
    var response = await http.get(connJson);

    String responseBody = response.body;
    var jsonBody = jsonDecode(responseBody);

    final db = await database();
    await db.delete('formaPago');
    var contador = 0;
    for (var data in jsonBody) {
      contador++;
      if (Parser.toInt(data['mostrar_pv']) == 1) {
        getprecios.add(FormaPagoModel(
            id: data['id'],
            nombre: data['nombre'],
            databaseId: Parser.toInt(data['database_id']),
            bancarizado: Parser.toInt(data['bancarizado']),
            depositable: Parser.toInt(data['depositable']),
            mostrarPv: Parser.toInt(data['mostrar_pv']),
            requiereReferencia: Parser.toInt(data['requiere_referencia']),
            factorComision: data['factor_comision'],
            codigoSat: data['codigo_sat'],
            cuentaContable: data['cuenta_contable'],
            metodoPago: data['metodo_pago'],
            formaPago: data['forma_pago'],
            moneda: data['moneda'],
            tipoCambioDefault: data['tipo_cambio_default'] ?? "1",
            permitirCambio: Parser.toInt(data['permitir_cambio']),
            credito: Parser.toInt(data['credito']),
            cuentaBancariaId: data['cuenta_bancaria_id'],
            razonSocialId: data['razon_social_id'],
            defecto: contador == 1 ? 1 : 0));
      }
    }
    for (var element in getprecios) {
      await db.insert('formaPago', element.toJson(),
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
    }
  }

  static Future<List<FormaPagoModel>> getItems() async {
    final db = await database();
    List<FormaPagoModel> tempPago = [];
    final listaPago = await db.query('formaPago', orderBy: "id");
    for (var element in listaPago) {
      tempPago.add(FormaPagoModel.fromJson(element));
    }
    return tempPago;
  }

  static Future<FormaPagoModel?> getItem(int id) async {
    final db = await database();
    final listaPago =
        (await db.query('formaPago', where: "id = ?", whereArgs: [id]))
            .firstOrNull;
    FormaPagoModel? tempPago =
        listaPago == null ? null : FormaPagoModel.fromJson(listaPago);
    return tempPago;
  }
}
