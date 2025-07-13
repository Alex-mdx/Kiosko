import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

import '../models/venta_model.dart';

String nombreBD = "cortepropio";

class SQLHelperCortePropio {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
    CREATE TABLE $nombreBD(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      folio TEXT,
      consecutivo INTEGER,
      sincronizado INTEGER,
      api_key_id INTEGER,
      contacto_id INTEGER,
      vendedor_id INTEGER,
      user_id INTEGER,
      empresa_id INTEGER,
      almacen_id INTEGER,
      sucursal_id INTEGER,
      moneda TEXT,
      cuenta_bancaria_id INTEGER,
      metodo_pago TEXT,
      razon_social_id INTEGER,
      fecha INTEGER,
      serie INTEGER,
      total INTEGER,
      comision INTEGER,
      tipo_cambio INTEGER,
      forma_pago_id INTEGER,
      cerrado INTEGER,
      notas TEXT,
      transaccion TEXT,
      fecha_apertura TEXT,
      fecha_cierre TEXT,
      detalles TEXT,
      pagos TEXT,
      status INTEGER,
      error_venta INTEGER
    )
""");
  }

//la función "db()"" abre la DB SQLite Y crear las tablas utilizando la función "createTables".
  static Future<sql.Database> database() async {
    return sql.openDatabase('cortepropio.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<bool> existColumna(String columnaAdd) async {
    final db1 = await database();
    List<Map<String, dynamic>> columnas =
        await db1.rawQuery('PRAGMA table_info($nombreBD)');

    for (Map<String, dynamic> columna in columnas) {
      String name = columna['name'];
      if (name == columnaAdd) {
        debugPrint('existe $columnaAdd');
        return true;
      }
    }
    debugPrint('agregando $columnaAdd');
    await db1.execute('ALTER TABLE $nombreBD ADD COLUMN $columnaAdd INTEGER');
    return false;
  }

  static Future<void> insertCorte(VentaModel corte) async {
    final db = await database();
    await db.insert(nombreBD, corte.toJson(),
        conflictAlgorithm: ConflictAlgorithm.rollback);
  }

  static Future<List<VentaModel>> getItems() async {
    final db = await database();
    List<VentaModel> modelado = [];
    final data = await db.query(nombreBD, orderBy: "consecutivo");
    for (var element in data) {
      modelado.add(VentaModel.fromJson(element));
    }
    return modelado;
  }

  static Future<List<VentaModel>> getItemsConsecutivo(String id) async {
    final db = await database();
    final data = await db.query(nombreBD,
        where: "consecutivo = ?", whereArgs: [id], orderBy: "consecutivo");
    List<VentaModel> modelado = [];
    for (var element in data) {
      modelado.add(VentaModel.fromJson(element));
    }
    return modelado;
  }

  static Future<List<VentaModel>> getItemsLastTen() async {
    final db = await database();
    final data = await db.query(nombreBD,
        orderBy: "consecutivo DESC", where: 'cerrado = 1', limit: 20);
    List<VentaModel> modelado = [];
    for (var element in data) {
      modelado.add(VentaModel.fromJson(element));
    }
    return modelado;
  }

  static Future<List<VentaModel>> getItemsLastTenSync() async {
    final db = await database();
    final data = await db.query(nombreBD,
        orderBy: "consecutivo DESC",
        where: 'cerrado = 1 AND sincronizado = 0',
        limit: 20);
    List<VentaModel> modelado = [];
    for (var element in data) {
      modelado.add(VentaModel.fromJson(element));
    }
    return modelado;
  }

  static Future<List<VentaModel>> getItem(String transaccion) async {
    final db = await database();
    final data = await db.query(nombreBD,
        where: "transaccion = ?",
        whereArgs: [transaccion],
        orderBy: "consecutivo");
    List<VentaModel> modelado = [];
    for (var element in data) {
      modelado.add(VentaModel.fromJson(element));
    }
    return modelado;
  }

  static Future<void> deleteCorte(String transaccion) async {
    final db = await database();
    await db
        .delete(nombreBD, where: 'transaccion = ?', whereArgs: [transaccion]);
  }

  static Future<void> deleteCorteSincronizado(String transaccion) async {
    final db = await database();
    await db.delete(nombreBD,
        where: 'transaccion = ? AND sincronizado = 1',
        whereArgs: [transaccion]);
  }

  static Future<void> deleteAll() async {
    final db = await database();
    await db.delete(nombreBD);
  }

  static Future<void> deleteItems(dynamic folio) async {
    final db = await database();
    await db.delete(nombreBD, where: 'consecutivo = ?', whereArgs: [folio]);
  }

  static Future<void> deleteCorteItem(String transaccion) async {
    final db = await database();
    await db.delete(nombreBD,
        where: 'transaccion = ? AND cerrado = 0', whereArgs: [transaccion]);
  }

  static Future<void> updateUser(VentaModel corte) async {
    await existColumna('error_venta');
    final db = await database();

    // Convertir detalles y pagos a JSON antes de almacenarlos en la base de datos
    final detallesJson =
        jsonEncode(corte.detalles.map((detalle) => detalle.toJson()).toList());
    final pagosJson =
        jsonEncode(corte.pagos.map((pago) => pago.toJson()).toList());
    await db.update(
        nombreBD,
        {
          'folio':
              '${corte.serie}${corte.cuentaBancariaId}${corte.consecutivo}',
          'api_key_id': corte.apiKeyId,
          'consecutivo': corte.consecutivo,
          'sincronizado': corte.sincronizado,
          'contacto_id': corte.contactoId,
          'vendedor_id': corte.vendedorId,
          'user_id': corte.userId,
          'empresa_id': corte.empresaId,
          'almacen_id': corte.almacenId,
          'sucursal_id': corte.sucursalId,
          'moneda': corte.moneda,
          'metodo_pago': corte.metodoPago,
          'razon_social_id': corte.razonSocialId,
          'fecha': corte.fecha,
          'serie': corte.serie,
          'total': corte.total,
          'comision': corte.comision,
          'tipo_cambio': corte.tipoCambio,
          'forma_pago_id': corte.formaPagoId,
          'cerrado': corte.cerrado,
          'notas': corte.notas,
          'transaccion': corte.transaccion,
          'fecha_apertura': corte.fechaApertura,
          'fecha_cierre': corte.fechaCierre,
          'error_venta': corte.errorVenta,
          'detalles': detallesJson,
          'pagos': pagosJson
        },
        where: 'transaccion = ? AND consecutivo = ?',
        whereArgs: [corte.transaccion, corte.consecutivo],
        conflictAlgorithm: ConflictAlgorithm.rollback);
  }

  static Future<void> updateLastUser(VentaModel updatedCorte) async {
    await existColumna('error_venta');
    final db = await database();

    // Obtener el último elemento guardado en la base de datos
    final lastCorte = await db.query(nombreBD, orderBy: 'id DESC', limit: 1);

    if (lastCorte.isNotEmpty) {
      final lastCorteId = lastCorte.first['id'];

      // Convertir detalles y pagos a JSON antes de almacenarlos en la base de datos
      final detallesJson = jsonEncode(
          updatedCorte.detalles.map((detalle) => detalle.toJson()).toList());
      final pagosJson =
          jsonEncode(updatedCorte.pagos.map((pago) => pago.toJson()).toList());
      final mapObj = {
        'folio':
            '${updatedCorte.serie}${updatedCorte.cuentaBancariaId}${updatedCorte.consecutivo}',
        'api_key_id': updatedCorte.apiKeyId,
        'consecutivo': updatedCorte.consecutivo,
        'sincronizado': updatedCorte.sincronizado,
        'contacto_id': updatedCorte.contactoId,
        'vendedor_id': updatedCorte.vendedorId,
        'user_id': updatedCorte.userId,
        'empresa_id': updatedCorte.empresaId,
        'almacen_id': updatedCorte.almacenId,
        'sucursal_id': updatedCorte.sucursalId,
        'moneda': updatedCorte.moneda,
        'metodo_pago': updatedCorte.metodoPago,
        'razon_social_id': updatedCorte.razonSocialId,
        'fecha': updatedCorte.fecha,
        'serie': updatedCorte.serie,
        'total': updatedCorte.total,
        'comision': updatedCorte.comision,
        'tipo_cambio': updatedCorte.tipoCambio,
        'forma_pago_id': updatedCorte.formaPagoId,
        'cerrado': updatedCorte.cerrado,
        'notas': updatedCorte.notas,
        'transaccion': updatedCorte.transaccion,
        'fecha_apertura': updatedCorte.fechaApertura,
        'fecha_cierre': updatedCorte.fechaCierre,
        'error_venta': updatedCorte.errorVenta,
        'detalles': detallesJson,
        'pagos': pagosJson,
      };
      await db.update(nombreBD, mapObj,
          where: 'id = ?',
          whereArgs: [lastCorteId],
          conflictAlgorithm: ConflictAlgorithm.rollback);
    }
  }
}
