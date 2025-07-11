import 'dart:convert';

import '../utils/funcion_parser.dart';
import 'atributos_model.dart';
import 'grupo_producto_model.dart';
import 'impuesto_model.dart';
import 'modificadores_model.dart';
import 'variantes_model.dart';

class ProductoModel {
  int id;
  String descripcion;
  String? codigoBarras;
  int? producible;
  int? consumible;
  int? vendible;
  int? inventariable;
  String? numeroParte;
  int? unidadId;
  int? categoriaId;
  int? lineaId;
  int? marcaId;
  int? tipoCosteo;
  int? tipoProducto;
  String? costoEstandar;
  String? ultimoCosto;
  String? precio;
  int? controlarTalla;
  int? controlarColor;
  int? controlarSerie;
  int? controlarLote;
  int? controlarPedimento;
  int? controlarCaducidad;
  int? diasEntrega;
  int? diasCaducidad;
  int? diasProduccion;
  String? peso;
  String? longitud;
  String? volumen;
  String? fraccionArancelaria;
  String? codigoSat;
  String? foto;
  String? file;
  int? databaseId;
  String? cuentaContable1;
  String? cuentaContable2;
  String? loteConfiguracion;
  int? rentable;
  int? publicado;
  String? fichaTecnica;
  String? calificacion;
  int? unidadVentaId;
  int? unidadCompraId;
  int? unidadAdicionalId;
  int? centroCostoId;
  int? proveedorId;
  int? matrizial;
  int? matrizX;
  int? matrizY;
  String? loteMinimo;
  String? loteMaximo;
  String? inventarioMinimo;
  String? inventarioMaximo;
  String? multiplo;
  int? familiaProductoId;
  String? codigoInterno;
  int? pesable;
  int? controlarUbicacion;
  int? puntoVenta;
  String? precioBase;
  String? impuesto;
  String? retencion;
  ProductoModel? productoEquivalencia;
  List<ImpuestosModel> impuestos;
  List<AtributosModel> atributos;
  List<ModificadoresModel> modificadores;
  List<VariantesModel> variantes;
  GrupoProductoModel? grupoProducto;
  int? grupoProductoId;

  ProductoModel(
      {required this.id,
      required this.descripcion,
      required this.codigoBarras,
      required this.producible,
      required this.consumible,
      required this.vendible,
      required this.inventariable,
      required this.numeroParte,
      required this.unidadId,
      required this.categoriaId,
      required this.lineaId,
      required this.marcaId,
      required this.tipoCosteo,
      required this.tipoProducto,
      required this.costoEstandar,
      required this.ultimoCosto,
      required this.precio,
      required this.controlarTalla,
      required this.controlarColor,
      required this.controlarSerie,
      required this.controlarLote,
      required this.controlarPedimento,
      required this.controlarCaducidad,
      required this.diasEntrega,
      required this.diasCaducidad,
      required this.diasProduccion,
      required this.peso,
      required this.longitud,
      required this.volumen,
      required this.fraccionArancelaria,
      required this.codigoSat,
      required this.foto,
      required this.file,
      required this.databaseId,
      required this.cuentaContable1,
      required this.cuentaContable2,
      required this.loteConfiguracion,
      required this.rentable,
      required this.publicado,
      required this.fichaTecnica,
      required this.calificacion,
      required this.unidadVentaId,
      required this.unidadCompraId,
      required this.unidadAdicionalId,
      required this.centroCostoId,
      required this.proveedorId,
      required this.matrizial,
      required this.matrizX,
      required this.matrizY,
      required this.grupoProductoId,
      required this.grupoProducto,
      required this.loteMinimo,
      required this.loteMaximo,
      required this.inventarioMinimo,
      required this.inventarioMaximo,
      required this.multiplo,
      required this.familiaProductoId,
      required this.codigoInterno,
      required this.pesable,
      required this.controlarUbicacion,
      required this.puntoVenta,
      required this.precioBase,
      required this.impuesto,
      required this.retencion,
      required this.productoEquivalencia,
      required this.impuestos,
      required this.atributos,
      required this.modificadores,
      required this.variantes});

  ProductoModel copyWith(
          {int? id,
          String? descripcion,
          String? codigoBarras,
          int? producible,
          int? consumible,
          int? vendible,
          int? inventariable,
          String? numeroParte,
          int? unidadId,
          int? categoriaId,
          int? lineaId,
          int? marcaId,
          int? tipoCosteo,
          int? tipoProducto,
          String? costoEstandar,
          String? ultimoCosto,
          String? precio,
          int? controlarTalla,
          int? controlarColor,
          int? controlarSerie,
          int? controlarLote,
          int? controlarPedimento,
          int? controlarCaducidad,
          int? diasEntrega,
          int? diasCaducidad,
          int? diasProduccion,
          String? peso,
          String? longitud,
          String? volumen,
          String? fraccionArancelaria,
          String? codigoSat,
          String? foto,
          String? file,
          int? databaseId,
          String? cuentaContable1,
          String? cuentaContable2,
          String? loteConfiguracion,
          int? rentable,
          int? publicado,
          String? fichaTecnica,
          String? calificacion,
          int? unidadVentaId,
          int? unidadCompraId,
          int? unidadAdicionalId,
          int? centroCostoId,
          int? proveedorId,
          int? matrizial,
          int? matrizX,
          int? matrizY,
          int? grupoProductoId,
          String? loteMinimo,
          String? loteMaximo,
          String? inventarioMinimo,
          String? inventarioMaximo,
          String? multiplo,
          int? familiaProductoId,
          String? codigoInterno,
          int? pesable,
          int? controlarUbicacion,
          int? puntoVenta,
          String? precioBase,
          String? impuesto,
          String? retencion,
          ProductoModel? productoEquivalencia,
          List<ImpuestosModel>? impuestos,
          List<AtributosModel>? atributos,
          List<ModificadoresModel>? modificadores,
          List<VariantesModel>? variantes}) =>
      ProductoModel(
          id: id ?? this.id,
          descripcion: descripcion ?? this.descripcion,
          codigoBarras: codigoBarras ?? this.codigoBarras,
          producible: producible ?? this.producible,
          consumible: consumible ?? this.consumible,
          vendible: vendible ?? this.vendible,
          inventariable: inventariable ?? this.inventariable,
          numeroParte: numeroParte ?? this.numeroParte,
          unidadId: unidadId ?? this.unidadId,
          categoriaId: categoriaId ?? this.categoriaId,
          lineaId: lineaId ?? this.lineaId,
          marcaId: marcaId ?? this.marcaId,
          tipoCosteo: tipoCosteo ?? this.tipoCosteo,
          tipoProducto: tipoProducto ?? this.tipoProducto,
          costoEstandar: costoEstandar ?? this.costoEstandar,
          ultimoCosto: ultimoCosto ?? this.ultimoCosto,
          precio: precio ?? this.precio,
          controlarTalla: controlarTalla ?? this.controlarTalla,
          controlarColor: controlarColor ?? this.controlarColor,
          controlarSerie: controlarSerie ?? this.controlarSerie,
          controlarLote: controlarLote ?? this.controlarLote,
          controlarPedimento: controlarPedimento ?? this.controlarPedimento,
          controlarCaducidad: controlarCaducidad ?? this.controlarCaducidad,
          diasEntrega: diasEntrega ?? this.diasEntrega,
          diasCaducidad: diasCaducidad ?? this.diasCaducidad,
          diasProduccion: diasProduccion ?? this.diasProduccion,
          peso: peso ?? this.peso,
          longitud: longitud ?? this.longitud,
          volumen: volumen ?? this.volumen,
          fraccionArancelaria: fraccionArancelaria ?? this.fraccionArancelaria,
          codigoSat: codigoSat ?? this.codigoSat,
          foto: foto ?? this.foto,
          file: file ?? this.file,
          databaseId: databaseId ?? this.databaseId,
          cuentaContable1: cuentaContable1 ?? this.cuentaContable1,
          cuentaContable2: cuentaContable2 ?? this.cuentaContable2,
          loteConfiguracion: loteConfiguracion ?? this.loteConfiguracion,
          rentable: rentable ?? this.rentable,
          publicado: publicado ?? this.publicado,
          fichaTecnica: fichaTecnica ?? this.fichaTecnica,
          calificacion: calificacion ?? this.calificacion,
          unidadVentaId: unidadVentaId ?? this.unidadVentaId,
          unidadCompraId: unidadCompraId ?? this.unidadCompraId,
          unidadAdicionalId: unidadAdicionalId ?? this.unidadAdicionalId,
          centroCostoId: centroCostoId ?? this.centroCostoId,
          proveedorId: proveedorId ?? this.proveedorId,
          matrizial: matrizial ?? this.matrizial,
          matrizX: matrizX ?? this.matrizX,
          matrizY: matrizY ?? this.matrizY,
          grupoProductoId: grupoProductoId ?? this.grupoProductoId,
          grupoProducto: grupoProducto ?? grupoProducto,
          loteMinimo: loteMinimo ?? this.loteMinimo,
          loteMaximo: loteMaximo ?? this.loteMaximo,
          inventarioMinimo: inventarioMinimo ?? this.inventarioMinimo,
          inventarioMaximo: inventarioMaximo ?? this.inventarioMaximo,
          multiplo: multiplo ?? this.multiplo,
          familiaProductoId: familiaProductoId ?? this.familiaProductoId,
          codigoInterno: codigoInterno ?? this.codigoInterno,
          pesable: pesable ?? this.pesable,
          controlarUbicacion: controlarUbicacion ?? this.controlarUbicacion,
          puntoVenta: puntoVenta ?? this.puntoVenta,
          precioBase: precioBase ?? this.precioBase,
          impuesto: impuesto ?? this.impuesto,
          retencion: retencion ?? this.retencion,
          productoEquivalencia:
              productoEquivalencia ?? this.productoEquivalencia,
          impuestos: impuestos ?? this.impuestos,
          atributos: atributos ?? this.atributos,
          modificadores: modificadores ?? this.modificadores,
          variantes: variantes ?? this.variantes);

  factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
      id: json['id'],
      descripcion: json['descripcion'],
      codigoBarras: json['codigo_barras'],
      producible: Parser.toInt(json['producible']),
      consumible: Parser.toInt(json['consumible']),
      vendible: Parser.toInt(json['vendible']),
      inventariable: Parser.toInt(json['inventariable']),
      numeroParte: json['numero_parte'],
      unidadId: json['unidad_id'],
      categoriaId: json['categoria_id'],
      lineaId: json['linea_id'],
      marcaId: json['marca_id'],
      tipoCosteo: json['tipo_costeo'],
      tipoProducto: json['tipo_producto'],
      costoEstandar: json['costo_estandar'],
      ultimoCosto: json['ultimo_costo'],
      precio: json['precio'].toString(),
      precioBase: json['precio_base'].toString(),
      controlarTalla: Parser.toInt(json['controlar_talla']),
      controlarColor: Parser.toInt(json['controlar_color']),
      controlarSerie: Parser.toInt(json['controlar_serie']),
      controlarLote: Parser.toInt(json['controlar_lote']),
      controlarPedimento: Parser.toInt(json['controlar_pedimento']),
      controlarCaducidad: Parser.toInt(json['controlar_caducidad']),
      diasEntrega: json['dias_entrega'],
      diasCaducidad: json['dias_caducidad'],
      diasProduccion: json['dias_produccion'],
      peso: json['peso'],
      longitud: json['longitud'],
      volumen: json['volumen'],
      fraccionArancelaria: json['fraccion_arancelaria'],
      codigoSat: json['codigo_sat'],
      foto: json['foto'],
      file: json["file"],
      databaseId: json['databaseId'],
      cuentaContable1: json['cuenta:contable1'],
      cuentaContable2: json['cuenta_contable2'],
      loteConfiguracion: json['lote_configuracion'],
      rentable: Parser.toInt(json['rentable']),
      publicado: Parser.toInt(json['publicado']),
      fichaTecnica: json['ficha_tecnica'],
      calificacion: json['calificacion'].toString(),
      unidadAdicionalId: json['unidad_adicional_id'],
      unidadCompraId: json['unidad_compra_id'],
      unidadVentaId: json['unidad_venta_id'],
      centroCostoId: json['centro_costo_id'],
      codigoInterno: json['codigo_interno'].toString(),
      controlarUbicacion: Parser.toInt(json['controlar_ubicacion']),
      familiaProductoId: json['familia_producto_id'],
      grupoProductoId: json['grupo_producto_id'],
      grupoProducto: json["grupo_producto"].toString() == "null"
          ? null
          : GrupoProductoModel.fromJson(jsonDecode(json["grupo_producto"])),
      impuesto: json['impuesto'].toString(),
      inventarioMaximo: json['inventario_maximo'].toString(),
      inventarioMinimo: json['inventario_minimo'].toString(),
      loteMaximo: json['lote_maximo'].toString(),
      loteMinimo: json['lote_minimo'].toString(),
      matrizX: json['matriz_x'],
      matrizY: json['matriz_y'],
      matrizial: Parser.toInt(json['matrizial']),
      multiplo: json['multiplo'].toString(),
      pesable: Parser.toInt(json['pesable']),
      proveedorId: json['proveedor_id'],
      puntoVenta: Parser.toInt(json['punto_venta']),
      retencion: json['retencion'].toString(),
      productoEquivalencia: json["producto_equivalencia"].toString() == "null"
          ? null
          : ProductoModel.fromJson(
              jsonDecode(json["producto_equivalencia"].toString())),
      impuestos: creadorImpuesto(json["impuestos"].toString()),
      atributos: creadorAtributos(json["atributos"].toString()),
      modificadores: creadorModificadores(json["modificadores"].toString()),
      variantes: creadorVariantes(json["variantes"].toString()));

  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
        "codigo_barras": codigoBarras,
        "producible": producible,
        "consumible": consumible,
        "vendible": vendible,
        "inventariable": inventariable,
        "numero_parte": numeroParte,
        "unidad_id": unidadId,
        "categoria_id": categoriaId,
        "linea_id": lineaId,
        "marca_id": marcaId,
        "tipo_costeo": tipoCosteo,
        "tipo_producto": tipoProducto,
        "costo_estandar": costoEstandar,
        "ultimo_costo": ultimoCosto,
        "precio": precio,
        "controlar_talla": controlarTalla,
        "controlar_color": controlarColor,
        "controlar_serie": controlarSerie,
        "controlar_lote": controlarLote,
        "controlar_pedimento": controlarPedimento,
        "controlar_caducidad": controlarCaducidad,
        "dias_entrega": diasEntrega,
        "dias_caducidad": diasCaducidad,
        "dias_produccion": diasProduccion,
        "peso": peso,
        "longitud": longitud,
        "volumen": volumen,
        "fraccion_arancelaria": fraccionArancelaria,
        "codigo_sat": codigoSat,
        "foto": foto,
        "file": file,
        "database_id": databaseId,
        "cuenta_contable_1": cuentaContable1,
        "cuenta_contable_2": cuentaContable2,
        "lote_configuracion": loteConfiguracion,
        "rentable": rentable,
        "publicado": publicado,
        "ficha_tecnica": fichaTecnica,
        "calificacion": calificacion,
        "unidad_venta_id": unidadVentaId,
        "unidad_compra_id": unidadCompraId,
        "unidad_adicional_id": unidadAdicionalId,
        "centro_costo_id": centroCostoId,
        "proveedor_id": proveedorId,
        "matrizial": matrizial,
        "matriz_x": matrizX,
        "matriz_y": matrizY,
        "grupo_producto_id": grupoProductoId,
        "grupo_producto": jsonEncode(grupoProducto),
        "lote_minimo": loteMinimo,
        "lote_maximo": loteMaximo,
        "inventario_minimo": inventarioMinimo,
        "inventario_maximo": inventarioMaximo,
        "multiplo": multiplo,
        "familia_producto_id": familiaProductoId,
        "codigo_interno": codigoInterno,
        "pesable": pesable,
        "controlar_ubicacion": controlarUbicacion,
        "punto_venta": puntoVenta,
        "precio_base": precioBase,
        "impuesto": impuesto,
        "retencion": retencion,
        "producto_equivalencia": jsonEncode(productoEquivalencia),
        "impuestos": jsonEncode(impuestos.map((r) => r.toJson()).toList()),
        "atributos": jsonEncode(atributos.map((r) => r.toJson()).toList()),
        "modificadores":
            jsonEncode(modificadores.map((r) => r.toJson()).toList()),
        "variantes": jsonEncode(variantes.map((r) => r.toJson()).toList())
      };
}

List<ImpuestosModel> creadorImpuesto(String json) {
  List<ImpuestosModel> object = [];
  if (json != "null") {
    final jsonData = jsonDecode(json);
    for (var element in jsonData) {
      object.add(ImpuestosModel.fromJson(element));
    }
  }
  return object;
}

List<AtributosModel> creadorAtributos(String json) {
  List<AtributosModel> object = [];
  if (json != "null") {
    final jsonData = jsonDecode(json);
    for (var element in jsonData) {
      object.add(AtributosModel.fromJson(element));
    }
  }
  return object;
}

List<ModificadoresModel> creadorModificadores(String json) {
  List<ModificadoresModel> object = [];
  if (json != "null") {
    final jsonData = jsonDecode(json);
    for (var element in jsonData) {
      object.add(ModificadoresModel.fromJson(element));
    }
  }

  return object;
}

List<VariantesModel> creadorVariantes(String json) {
  List<VariantesModel> object = [];
  if (json != "null") {
    final jsonData = jsonDecode(json);
    for (var element in jsonData) {
      object.add(VariantesModel.fromJson(element));
    }
  }
  return object;
}
