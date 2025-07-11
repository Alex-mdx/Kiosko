import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kiosko/controllers/forma_pago_controller.dart';
import 'package:kiosko/utils/main_provider.dart';
import 'package:kiosko/utils/route/link.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../models/usuario_model.dart';
import '../utils/internet_except.dart';
import 'direccion_controller.dart';
import 'empresa_controller.dart';
import 'sucursal_controller.dart';

String nombreDB = "usuario";

class UserController {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE $nombreDB(
        id INTEGER,
        uuid TEXT,
        nombre TEXT,
        consecutivo INTEGER,
        corte INTEGER,
        database_id INTEGER,
        user_id INTEGER,
        estatus INTEGER,
        usuario TEXT,
        user TEXT,
        password TEXT,
        token TEXT,
        almacen_id INTEGER,
        sucursal_id INTEGER,
        empresa_id INTEGER,
        cliente_id INTEGER,
        vendedor_id INTEGER,
        razon_social_id INTEGER,
        moneda TEXT,
        serie_venta INTEGER,
        serie_cobro INTEGER,
        contacto_id INTEGER,
        empleado_nomina_id INTEGER,
        cuenta_bancaria_id INTEGER,
        empleado_nomina TEXT
      )""");
  }

  static Future<sql.Database> database() async {
    return sql.openDatabase('app_pos_usuario.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<bool> existColumna(String columnaAdd) async {
    final db1 = await database();
    List<Map<String, dynamic>> columnas = await db1.rawQuery(
      'PRAGMA table_info($nombreDB)',
    );

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

  static Future<String> login(List<String> login, MainProvider provider) async {
    double porcentaje = 100 / 6;
    final uri = Uri.parse(Link.apiLogin);
    debugPrint('$uri');
    String body = jsonEncode({'usuario': login[0], 'password': login[1]});
    //try {
    final response = await http
        .post(uri, body: body, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final jasonData = jsonDecode(response.body);
      final usuarioBack = (await getItem());
      if (jasonData["almacen_id"] != null &&
          jasonData["sucursal_id"] != null &&
          jasonData["empresa_id"] != null &&
          jasonData["cliente_id"] != null &&
          jasonData["vendedor_id"] != null &&
          jasonData["razon_social_id"] != null &&
          jasonData["cuenta_bancaria_id"] != null) {
        UsuarioModel user = UsuarioModel(
            id: jasonData["id"],
            uuid: jasonData["uuid"],
            nombre: jasonData["nombre"],
            consecutivo: usuarioBack == null ? 1 : usuarioBack.consecutivo,
            databaseId: jasonData["database_id"],
            userId: jasonData["user_id"],
            usuario: jasonData["usuario"],
            user: login[0],
            password: login[1],
            token: jasonData["token"],
            almacenId: jasonData["almacen_id"],
            sucursalId: jasonData["sucursal_id"],
            empresaId: jasonData["empresa_id"],
            clienteId: jasonData["cliente_id"],
            vendedorId: jasonData["vendedor_id"],
            razonSocialId: jasonData["razon_social_id"],
            moneda: jasonData["moneda"],
            serieVenta: jasonData["serie_venta"],
            serieCobro: jasonData["serie_cobro"],
            contactoId: jasonData["contacto_id"],
            empleadoNominaId: jasonData["empleado_nomina_id"],
            cuentaBancariaId: jasonData["cuenta_bancaria_id"],
            empleadoNomina: jasonData["empleado_nomina"].toString());

        await insert(user);
        provider.cargaApi += porcentaje;
        await EmpresaController.getApiEmpresa(provider);
        provider.cargaApi += porcentaje;
        provider.empresas = await EmpresaController.getItems();
        showToast('guardo empresas', dismissOtherToast: true);
        for (var element in provider.empresas) {
          await DireccionController.getApiDireccion(element.direccionId!);
          provider.cargaApi += porcentaje / provider.empresas.length;
        }
        await SucursalController.getApi();
        provider.cargaApi += porcentaje;
        provider.sucursales = await SucursalController.getItems();
        showToast('guardo sucursal', dismissOtherToast: true);
        for (var element in provider.sucursales) {
          await DireccionController.getApiDireccion(element.direccionId!);
          provider.cargaApi += porcentaje / provider.sucursales.length;
        }
        provider.direcciones = await DireccionController.getItems();
        provider.cargaApi += porcentaje;
        showToast('guardo direcciones', dismissOtherToast: true);
        await FormaPagoController.getApiFormaPago();
        provider.formaPago = await FormaPagoController.getItems();
        provider.cargaApi += porcentaje;
        provider.user = user;
        showToast('Sincronizacion Completada');
        provider.cargaApi = 100;
        return "success";
      } else {
        provider.cargaApi = 0;
        await deleteAll();
        showToast(
            'Error con el la cuenta de usuario\n no se configuro algun ${jasonData["almacen_id"] == null ? 'Almacen_id, ' : ''}${jasonData["sucursal_id"] == null ? 'sucursal_id, ' : ''}${jasonData["empresa_id"] == null ? 'empresa_id, ' : ''} ${jasonData["cliente_id"] == null ? 'cliente_id, ' : ''}${jasonData["vendedor_id"] == null ? 'vendedor_id, ' : ''}${jasonData["razon_social_id"] == null ? 'razon_social_id ' : ''}${jasonData["cuenta_bancaria_id"] == null ? 'cuenta_bancaria_id ' : ''}');
        return "idle";
      }
    } else {
      provider.cargaApi = 0;
      ExcepcionInternet.errorHttp(
          status: response.statusCode, response: response.body);
      return "idle";
    }
    /* } catch (e) {
      ExcepcionInternet.errorRed(excepcion: e);
      provider.cargaApi = 0;
      log('$e');

      return "idle";
    } */
  }

  static Future<UsuarioModel?> getItem() async {
    final db = await database();
    final data = (await db.query(nombreDB, limit: 1)).firstOrNull;
    return data == null ? null : UsuarioModel.fromJson(data);
  }

  static Future<void> insert(UsuarioModel user) async {
    final db = await database();
    await db.insert(nombreDB, user.toJson());
  }

  static Future<void> deleteAll() async {
    final db = await database();
    await db.delete(nombreDB);
  }
}
