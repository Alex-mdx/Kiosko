import 'package:flutter/material.dart';
import 'package:kiosko/controllers/user_controller.dart';
import 'package:kiosko/utils/route/link.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/contacto_model.dart';
import '../models/razon_social_model.dart';
import '../utils/funcion_parser.dart';

class ContactoController {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE contactos(
          id INTEGER,
          nombre TEXT,
          direccion_id INTEGER,
          estatus INTEGER,
          created_at TEXT,
          updated_at TEXT,
          database_id INTEGER,
          lista_precio_cliente_id INTEGER,
          lista_precio_proveedor_id INTEGER,
          apellido_paterno TEXT,
          apellido_materno TEXT,
          persona_moral INT,
          cliente INTEGER,
          proveedor INTEGER,
          deudor INTEGER,
          acreedor INTEGER,
          empleado INTEGER,
          vendedor INTEGER,
          cajero INTEGER,
          tecnico INTEGER,
          nombre_completo TEXT,
          user_id INTEGER,
          impuesto_perfil_proveedor TEXT,
          socio INTEGER,
          dias_credito_cliente INTEGER,
          dias_credito_proveedor INTEGER,
          permisionario INTEGER,
          chofer INTEGER,
          lista_descuento_cliente_id INTEGER,
          codigo TEXT,
          tipo_comision_id INTEGER,
          lista_comision_id INTEGER,
          razones_sociales INTERGER
      )""");
  }

  static Future<sql.Database> database() async {
    return sql.openDatabase('app_pos_contacto.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<bool> existColumna(String columnaAdd) async {
    final db1 = await database();
    List<Map<String, dynamic>> columnas =
        await db1.rawQuery('PRAGMA table_info(contactos)');

    for (Map<String, dynamic> columna in columnas) {
      String name = columna['name'];
      if (name == columnaAdd) {
        debugPrint('existe $columnaAdd');
        return true;
      }
    }
    debugPrint('agregando $columnaAdd');
    await db1.execute('ALTER TABLE contactos ADD COLUMN $columnaAdd INTEGER');
    return false;
  }

  static Future<void> getApiContactos() async {
    final user = await UserController.getItem();
    final connJson =
        Uri.parse("${Link.apiUrlContacto}${user?.databaseId}&api_key=${user?.uuid}&cliente=1");
    List<ContactosModelo> getLineas = [];
    var response = await http.get(connJson);
    String responseBody = response.body;
    List<dynamic> jsonBody = jsonDecode(responseBody);
    final db = await database();

    for (var data in jsonBody) {
      List<RazonSocialModel> razones = [];
      if (data["razones_sociales"] != null) {
        for (var element in data["razones_sociales"]) {
          razones.add(RazonSocialModel.fromJson(element));
        }

        getLineas.add(ContactosModelo(
            id: data["id"],
            nombre: data["nombre"],
            direccionId: data["direccion_id"],
            databaseId: data["database_id"],
            listaPrecioClienteId: data["lista_precio_cliente_id"],
            listaPrecioProveedorId: data["lista_precio_proveedor_id"],
            apellidoPaterno: data["apellido_paterno"],
            apellidoMaterno: data["apellido_materno"],
            personaMoral: Parser.toInt(data["persona_moral"]),
            cliente: Parser.toInt(data["cliente"]),
            proveedor: Parser.toInt(data["proveedor"]),
            deudor: Parser.toInt(data["deudor"]),
            acreedor: Parser.toInt(data["acreedor"]),
            empleado: Parser.toInt(data["empleado"]),
            vendedor: Parser.toInt(data["vendedor"]),
            cajero: Parser.toInt(data["cajero"]),
            tecnico: Parser.toInt(data["tecnico"]),
            nombreCompleto: data["nombre_completo"],
            userId: data["user_id"],
            impuestoPerfilProveedor: data["impuesto_perfil_proveedor"],
            socio: Parser.toInt(data["socio"]),
            diasCreditoCliente: data["dias_credito_cliente"],
            listaDescuentoClienteId: data["lista_descuento_cliente_id"],
            permisionario: Parser.toInt(data["permisionario"]),
            diasCreditoProveedor: data["dias_credito_proveedor"],
            chofer: Parser.toInt(data["chofer"]),
            codigo: data['codigo'],
            tipoComisionId: data["tipo_comision_id"],
            listaComisionId: data["lista_comision_id"],
            razonesSociales: razones));
      }
    }
    for (var element in getLineas) {
      final buscar = await getItem(element.id);
      if (buscar == null) {
        debugPrint('ingreso');
        await db.insert('contactos', element.toJson(),
            conflictAlgorithm: sql.ConflictAlgorithm.replace);
      } else {
        debugPrint('actualizo');
        await db.update('contactos', element.toJson(),
            where: "id = ?", whereArgs: [element.id]);
      }
    }
  }

  static Future<List<ContactosModelo>> getItemsContacto() async {
    final db = await database();
    final listaContacto = await db.query('contactos', orderBy: "nombre");
    List<ContactosModelo> lineas = [];
    for (var element in listaContacto) {
      lineas.add(ContactosModelo.fromJson(element));
    }
    return lineas;
  }

  static Future<List<ContactosModelo>> getItemsContacto10() async {
    final db = await database();
    final listaContacto =
        await db.query('contactos', orderBy: "nombre", limit: 15);
    List<ContactosModelo> lineas = [];
    for (var element in listaContacto) {
      lineas.add(ContactosModelo.fromJson(element));
    }
    return lineas;
  }

  static Future<Map<String, dynamic>?> getQr(String qr) async {
    final db = await database();
    final dbContactos = await db.query('contactos',
        orderBy: "nombre", where: "codigo = ?", whereArgs: [qr], limit: 1);
    return dbContactos.isNotEmpty ? dbContactos.first : null;
  }

  static Future<ContactosModelo?> getItem(int id) async {
    final db = await database();
    final dbcontacto = (await db.query('contactos',
            where: "id = ?", whereArgs: [id], limit: 1, orderBy: "nombre"))
        .firstOrNull;
    ContactosModelo? nuevoContacto =
        dbcontacto == null ? null : ContactosModelo.fromJson(dbcontacto);
    return nuevoContacto;
  }
}
