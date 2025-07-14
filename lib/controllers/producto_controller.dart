import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:kiosko/controllers/user_controller.dart';
import 'package:kiosko/utils/funcion_parser.dart';
import 'package:kiosko/utils/route/link.dart';
import 'package:kiosko/utils/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:http/http.dart' as http;
import 'dart:convert';
//Services
import '../models/atributos_model.dart';
import '../models/catagolo_general_model.dart';
//Models
import '../models/chip_model.dart';
import '../models/configuracion_model.dart';
import '../models/grupo_producto_model.dart';
import '../models/impuesto_model.dart';
import '../models/modificadores_model.dart';
import '../models/producto_model.dart';
import '../models/variantes_model.dart';
import '../utils/main_provider.dart';

String nombreDB = "productos";

class ProductosController {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE $nombreDB(
          id INTEGER , 
          descripcion TEXT,
          codigo_barras TEXT,
          producible INTEGER,
          consumible INTEGER,
          vendible INTEGER,
          inventariable INTEGER,
          numero_parte TEXT,
          unidad_id INTEGER,
          categoria_id INTEGER,
          linea_id INTEGER,
          marca_id INTEGER,
          tipo_costeo INTEGER,
          tipo_producto INTEGER,
          costo_estandar TEXT,
          ultimo_costo TEXT,
          precio TEXT,
          controlar_talla INTEGER,
          controlar_color INTEGER,
          controlar_serie INTEGER,
          controlar_lote INTEGER,
          controlar_pedimento INTEGER,
          controlar_caducidad INTEGER,
          dias_entrega INTEGER,
          dias_caducidad INTEGER,
          dias_produccion INTEGER,
          peso TEXT,
          longitud TEXT,
          volumen TEXT,
          fraccion_arancelaria TEXT,
          codigo_sat TEXT,
          foto TEXT,
          database_id INTEGER,
          cuenta_contable_1 TEXT,
          cuenta_contable_2 TEXT,
          lote_configuracion TEXT,
          rentable INTEGER,
          publicado INTEGER,
          ficha_tecnica TEXT,
          calificacion TEXT,
          unidad_venta_id INTEGER,
          unidad_compra_id INTEGER,
          unidad_adicional_id INTEGER,
          precio_base INTEGER,
          centro_costo_id INTEGER,
          codigo_interno INTEGER,
          controlar_ubicacion INTEGER,
          familia_producto_id INTEGER,
          grupo_producto_id INTEGER,
          impuesto INTEGER,
          inventario_maximo INTEGER,
          inventario_minimo INTEGER,
          lote_maximo INTEGER,
          lote_minimo INTEGER,
          matriz_x INTEGER,
          matriz_y INTEGER,
          matrizial INTEGER,
          multiplo INTEGER,
          pesable INTEGER,
          proveedor_id INTEGER,
          punto_venta INTEGER,
          retencion INTEGER,
          impuestos INTEGER,
          atributos INTEGER,
          modificadores INTEGER,
          variantes INTEGER,
          grupo_producto INTEGER,
          file INTEGER,
          producto_equivalencia INTEGER
      )""");
  }

  static Future<sql.Database> database() async {
    return sql.openDatabase('app_pos_productos.db', version: 1,
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

  static Future<void> getApiProductos(MainProvider provider) async {
    final user = await UserController.getItem();
    String familia = Preferencias.familiaCat == 0
        ? ""
        : "&familia_producto_id=${Preferencias.familiaCat}";
    final connJson = Uri.parse(
        "${Link.apiUrlProducto}${user?.databaseId}&cliente_id=${user?.clienteId}&tipo_precio=1&api_key=${user?.uuid}&punto_venta=true$familia");
    log("$connJson");
    List<ProductoModel> getLineas = [];
    var response = await http.get(connJson);
    String responseBody = response.body;
    var jsonBody = json.decode(responseBody);
    final db = await database();
    await db.delete('productos');

    for (var data in jsonBody) {
      List<ImpuestosModel> impo = [];
      List<AtributosModel> atri = [];
      List<ModificadoresModel> modi = [];
      List<VariantesModel> varia = [];
      String? file;
      if (data["foto"] != null) {
        file = (await Parser.descargaImagen(data["foto"])).toString();
      }
      ProductoModel? productoEquivalencia;
      if (data["producto_equivalencia"] != null) {
        productoEquivalencia =
            ProductoModel.fromJson(data["producto_equivalencia"]);
      }
      if (data["impuestos"] != null) {
        for (var imp in data["impuestos"]) {
          impo.add(ImpuestosModel.fromJson(imp["impuesto"]));
        }
      }
      if (data["atributos"] != null) {
        for (var imp in data["atributos"]) {
          List<ConfiguracionModel> listConfi = [];
          List<ChipModel> listChip = [];
          for (var element in imp["configuracion"]) {
            listConfi.add(ConfiguracionModel.fromJson(element));
          }
          for (var element in imp["chip"]) {
            listChip.add(ChipModel.fromJson(element));
          }
          atri.add(AtributosModel(
              id: imp["id"],
              productoId: imp["productoId"],
              catalogoGeneralId: imp["catalogoGeneralId"],
              configuracion: listConfi,
              catalogoGeneral:
                  CatalogoGeneralModel.fromJson(imp["catalogo_general"]),
              chips: listChip));
        }
      }

      if (data["modificadores"] != null) {
        for (var imp in data["modificadores"]) {
          log("id: ${data['id']}\n d: ${data['descripcion']}\n$imp");
          List<ConfiguracionModel> listConfi = [];
          List<ChipModel> listChip = [];
          for (var element in imp["configuracion"]) {
            listConfi.add(ConfiguracionModel.fromJson(element));
          }
          for (var element in imp["chips"]) {
            listChip.add(ChipModel.fromJson(element));
          }
          modi.add(ModificadoresModel(
              id: imp["id"],
              productoId: imp["producto_id"],
              cantidadMinima: imp["cantidad_minima"],
              cantidadMaxima: imp["cantidad_maxima"],
              catalogoGeneralId: imp["catalogo_general_id"],
              configuracion: listConfi,
              catalogoGeneral:
                  CatalogoGeneralModel.fromJson(imp["catalogo_general"]),
              chips: listChip));
        }
      }

      if (data["variantes"] != null) {
        for (var imp in data["variantes"]) {
          List<ConfiguracionModel> listConfi = [];
          for (var element in imp["configuracion"]) {
            listConfi.add(ConfiguracionModel.fromJson(element));
          }
          varia.add(VariantesModel(
              id: imp["id"],
              productoId: imp["producto_id"],
              configuracion: listConfi,
              foto: imp["foto"],
              precio: imp["precio"],
              costo: imp["costo"],
              codigoBarra: imp["codigo_barra"],
              nombre: imp["nombre"]));
        }
      }
      var grupos = data["grupo_producto"] == null
          ? GrupoProductoModel(id: null, nombre: null)
          : GrupoProductoModel.fromJson(data["grupo_producto"]);
      getLineas.add(ProductoModel(
          id: data['id'],
          descripcion: data['descripcion'],
          codigoBarras: data['codigo_barras'],
          producible: Parser.toInt(data['producible']),
          consumible: Parser.toInt(data['consumible']),
          vendible: Parser.toInt(data['vendible']),
          inventariable: Parser.toInt(data['inventariable']),
          numeroParte: data['numero_parte'],
          unidadId: data['unidad_id'],
          categoriaId: data['categoria_id'],
          lineaId: data['linea_id'],
          marcaId: data['marca_id'],
          tipoCosteo: data['tipo_costeo'],
          tipoProducto: data['tipo_producto'],
          costoEstandar: data['costo_estandar'],
          ultimoCosto: data['ultimo_costo'],
          precio: data['precio'].toString(),
          precioBase: data['precio_base'].toString(),
          controlarTalla: Parser.toInt(data['controlar_talla']),
          controlarColor: Parser.toInt(data['controlar_color']),
          controlarSerie: Parser.toInt(data['controlar_serie']),
          controlarLote: Parser.toInt(data['controlar_lote']),
          controlarPedimento: Parser.toInt(data['controlar_pedimento']),
          controlarCaducidad: Parser.toInt(data['controlar_caducidad']),
          diasEntrega: data['dias_entrega'],
          diasCaducidad: data['dias_caducidad'],
          diasProduccion: data['dias_produccion'],
          peso: data['peso'],
          longitud: data['longitud'],
          volumen: data['volumen'],
          fraccionArancelaria: data['fraccion_arancelaria'],
          codigoSat: data['codigo_sat'],
          foto: data['foto'],
          file: file,
          databaseId: data['database_id'],
          cuentaContable1: data['cuenta:contable1'],
          cuentaContable2: data['cuenta_contable2'],
          loteConfiguracion: data['lote_configuracion'],
          rentable: Parser.toInt(data['rentable']),
          publicado: Parser.toInt(data['publicado']),
          fichaTecnica: data['ficha_tecnica'],
          calificacion: data['calificacion'].toString(),
          unidadAdicionalId: data['unidad_adicional_id'],
          unidadCompraId: data['unidad_compra_id'],
          unidadVentaId: data['unidad_venta_id'],
          centroCostoId: data['centro_costo_id'],
          codigoInterno: data['codigo_interno'].toString(),
          controlarUbicacion: Parser.toInt(data['controlar_ubicacion']),
          familiaProductoId: data['familia_producto_id'],
          grupoProductoId: data['grupo_producto_id'],
          grupoProducto: grupos,
          impuesto: data['impuesto'].toString(),
          inventarioMaximo: data['inventario_maximo'],
          inventarioMinimo: data['inventario_minimo'],
          loteMaximo: data['lote_maximo'],
          loteMinimo: data['lote_minimo'],
          matrizX: data['matriz_x'],
          matrizY: data['matriz_y'],
          matrizial: Parser.toInt(data['matrizial']),
          multiplo: data['multiplo'],
          pesable: Parser.toInt(data['pesable']),
          proveedorId: data['proveedor_id'],
          puntoVenta: Parser.toInt(data['punto_venta']),
          retencion: data['retencion'].toString(),
          productoEquivalencia: productoEquivalencia,
          impuestos: impo,
          atributos: atri,
          modificadores: modi,
          variantes: varia));
    }

    for (var element in getLineas) {
      await db.insert('productos', element.toJson(),
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
    }
  }

  static Future<List<ProductoModel>> getItems() async {
    final db = await database();

    List<ProductoModel> model = [];
    final data = await db.query('productos', orderBy: "descripcion");
    for (var element in data) {
      model.add(ProductoModel.fromJson(element));
    }
    return model;
  }

  /* static Future<List<ProductoModel>> getByX(
      {required String? peticion, required List<int> categorias}) async {
    final db = await database();
    
    var idCategoria = categorias.join(",");
    List<ProductoModel> model = [];
    //String querys ="${peticion == null || peticion == "" ? "" : "descripcion LIKE ? OR codigo_barras = $peticion"}${(peticion != null && peticion != "") && (categorias.isNotEmpty) ? "AND" : ""}${categorias.isNotEmpty ? "categoria_id IN ($idCategoria)" : ""}";

    final data = await db.query(nombreDB,
        where: (peticion != null && peticion != "") || (categorias.isNotEmpty)
            ? "${peticion == null || peticion == "" ? "" : "descripcion LIKE ? OR codigo_barras = ?"}${(peticion != null && peticion != "") && (categorias.isNotEmpty) ? "AND " : ""}${categorias.isNotEmpty ? "categoria_id IN ($idCategoria)" : ""}"
            : null,
        whereArgs: peticion == null || peticion == ""
            ? null
            : ['%$peticion%', peticion],
        orderBy: "descripcion ${Preferencias.ordenamiento ? "DESC" : "ASC"}",
        limit: 100);
    for (var element in data) {
      model.add(ProductoModel.fromJson(element));
    }
    return model;
  } */

  static Future<List<ProductoModel>> getItemServicio() async {
    final db = await database();
    List<ProductoModel> model = [];

    final data = (await db.query(nombreDB, where: "tipo_producto = 2"));
    for (var element in data) {
      model.add(ProductoModel.fromJson(element));
    }
    log("${model.length}");
    return model;
  }

  static Future<ProductoModel?> getItemId({required int id}) async {
    final db = await database();

    final data =
        (await db.query(nombreDB, where: "id = ?", whereArgs: [id], limit: 1))
            .firstOrNull;
    return data == null ? null : ProductoModel.fromJson(data);
  }
}
