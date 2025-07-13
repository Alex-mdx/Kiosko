import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:get/utils.dart';
import 'package:kiosko/controllers/MPago_point_controller.dart';
import 'package:kiosko/controllers/categoria_controller.dart';
import 'package:kiosko/controllers/empresa_controller.dart';
import 'package:kiosko/controllers/forma_pago_controller.dart';
import 'package:kiosko/controllers/sucursal_controller.dart';
import 'package:kiosko/controllers/user_controller.dart';
import 'package:kiosko/models/MPago_point_model.dart';
import 'package:kiosko/models/categoria_model.dart';
import 'package:kiosko/models/direccion_model.dart';
import 'package:kiosko/models/empresa_model.dart';
import 'package:kiosko/models/forma_pago_model.dart';
import 'package:kiosko/models/sucursal_model.dart';
import 'package:kiosko/models/usuario_model.dart';
import 'package:oktoast/oktoast.dart';

import '../controllers/corte_cobro_propio_controller.dart';
import '../models/device_model.dart';
import '../models/grupo_producto_model.dart';
import '../models/venta_detalle_model.dart';
import '../models/venta_model.dart';
import 'textos.dart';

class MainProvider with ChangeNotifier {
  double _cargaApi = 0;
  double get cargaApi => _cargaApi;
  set cargaApi(double valor) {
    _cargaApi = valor;
    notifyListeners();
  }

  UsuarioModel? _user;
  UsuarioModel? get user => _user;
  set user(UsuarioModel? valor) {
    _user = valor;
    notifyListeners();
  }

  MPagoPointModel? _pointNow;
  MPagoPointModel? get pointNow => _pointNow;
  set pointNow(MPagoPointModel? valor) {
    _pointNow = valor;
    notifyListeners();
  }

  PrinterModel? _selectDevice;
  PrinterModel? get selectDevice => _selectDevice;
  set selectDevice(PrinterModel? valor) {
    _selectDevice = valor;
    notifyListeners();
  }

  List<PrinterModel> _devices = [];
  List<PrinterModel> get devices => _devices;
  set devices(List<PrinterModel> valor) {
    _devices = valor;
    notifyListeners();
  }

  List<Detalles> _listaDetalle = [];
  List<Detalles> get listaDetalle => _listaDetalle;
  set listaDetalle(List<Detalles> valor) {
    _listaDetalle = valor;
    notifyListeners();
  }

  List<EmpresaModel> _empresas = [];
  List<EmpresaModel> get empresas => _empresas;
  set empresas(List<EmpresaModel> valor) {
    _empresas = valor;
    notifyListeners();
  }

  List<SucursalModel> _sucursales = [];
  List<SucursalModel> get sucursales => _sucursales;
  set sucursales(List<SucursalModel> valor) {
    _sucursales = valor;
    notifyListeners();
  }

  List<DireccionModel> _direcciones = [];
  List<DireccionModel> get direcciones => _direcciones;
  set direcciones(List<DireccionModel> valor) {
    _direcciones = valor;
    notifyListeners();
  }

  List<FormaPagoModel> _formaPago = [];
  List<FormaPagoModel> get formaPago => _formaPago;
  set formaPago(List<FormaPagoModel> valor) {
    _formaPago = valor;
    notifyListeners();
  }

  List<CategoriaModel> _categorias = [];
  List<CategoriaModel> get categorias => _categorias;
  set categorias(List<CategoriaModel> valor) {
    _categorias = valor;
    notifyListeners();
  }

  VentaModel? _cortePropio;
  VentaModel? get cortePropio => _cortePropio;
  set cortePropio(VentaModel? valor) {
    _cortePropio = valor;
    notifyListeners();
  }

  List<VentaModel> _corteinterno = [];
  List<VentaModel> get corteinterno => _corteinterno;
  set corteinterno(List<VentaModel> valor) {
    _corteinterno = valor;
    notifyListeners();
  }

  bool _internet = false;
  bool get internet => _internet;
  set internet(bool valor) {
    _internet = valor;
    notifyListeners();
  }

  List<GrupoProductoModel> _grupoProducto = [];
  List<GrupoProductoModel> get grupoProducto => _grupoProducto;
  set grupoProducto(List<GrupoProductoModel> valor) {
    _grupoProducto = valor;
    notifyListeners();
  }

  bool _estadoSincronizacion = false;
  bool get estadoSincronizacion => _estadoSincronizacion;
  set estadoSincronizacion(bool valor) {
    _estadoSincronizacion = valor;
    notifyListeners();
  }

  //!FUNCIONES
  double totalSumatoria() {
    var monto = 0.0;
    for (var element in listaDetalle) {
      monto += element.total ?? 0;
    }
    return monto;
  }

  Future<void> aperturar() async {
    user = await UserController.getItem();
    log("${user?.toJson()}");
    corteinterno = await SQLHelperCortePropio.getItems();
    final now = DateTime.now();
    final random = math.Random();
    const caracteres =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    String cadenaAleatoria = '';
    for (int i = 0; i < 20; i++) {
      int indice = random.nextInt(caracteres.length);
      cadenaAleatoria += caracteres[indice];
    }

    ///apertura de caja de usuario
    if (corteinterno.isEmpty) {
      VentaModel venta = VentaModel(
          apiKeyId: user!.id,
          consecutivo: user!.consecutivo,
          sincronizado: 0,
          contactoId: user!.clienteId,
          vendedorId: user!.vendedorId,
          userId: user!.userId,
          empresaId: user!.empresaId,
          almacenId: user!.almacenId,
          sucursalId: user!.sucursalId,
          moneda: user!.moneda,
          cuentaBancariaId: user!.cuentaBancariaId,
          metodoPago: null,
          razonSocialId: user!.razonSocialId,
          fecha: Textos.FechaYMD(fecha: now),
          serie: 'C${user!.cuentaBancariaId}${user!.serieVenta}',
          total: 0,
          comision: 0,
          tipoCambio: 0.0000,
          formaPagoId: null,
          cerrado: 0,
          fechaApertura: Textos.FechaYMDHMS(fecha: now),
          transaccion: cadenaAleatoria,
          fechaCierre: null,
          detalles: [],
          pagos: []);
      await SQLHelperCortePropio.insertCorte(venta);
      final corte = await SQLHelperCortePropio.getItems();
      cortePropio = venta;
      corteinterno = (corte).toList();
      showToast('haz abierto caja');
    } else {
      var corteAbierto = corteinterno.firstWhereOrNull((element) =>
          element.cerrado == 0 &&
          Textos.FechaYMD(fecha: DateTime.parse(element.fechaApertura!)) ==
              Textos.FechaYMD(fecha: now));
      var abiertos = corteinterno.where((element) =>
          element.cerrado == 0 &&
          Textos.FechaYMD(fecha: DateTime.parse(element.fechaApertura!)) !=
              Textos.FechaYMD(fecha: now));
      for (var element in abiertos) {
        await SQLHelperCortePropio.deleteCorteItem(element.transaccion!);
      }
      String cierres = abiertos.isNotEmpty
          ? "\nSe han cerrado las aperturas del\n${abiertos.map((e) => e.fechaApertura).join(", ")}"
          : "";
      if (corteAbierto == null) {
        VentaModel venta = VentaModel(
            apiKeyId: user!.id,
            notas: null,
            consecutivo: user!.consecutivo,
            sincronizado: 0,
            contactoId: user!.clienteId,
            vendedorId: user!.vendedorId,
            userId: user!.userId,
            empresaId: user!.empresaId,
            almacenId: user!.almacenId,
            sucursalId: user!.sucursalId,
            moneda: user!.moneda,
            cuentaBancariaId: user!.cuentaBancariaId,
            metodoPago: null,
            razonSocialId: user!.razonSocialId,
            fecha: Textos.FechaYMD(fecha: now),
            serie: 'C${user!.cuentaBancariaId}${user!.serieVenta}',
            total: 0,
            comision: 0,
            tipoCambio: 0,
            formaPagoId: null,
            cerrado: 0,
            fechaApertura: Textos.FechaYMDHMS(fecha: now),
            transaccion: cadenaAleatoria,
            fechaCierre: null,
            detalles: [],
            pagos: []);
        cortePropio = venta;
        await SQLHelperCortePropio.insertCorte(venta);
        corteinterno = await SQLHelperCortePropio.getItems();
        showToast('Haz abierto caja$cierres');
      } else {
        cortePropio = corteAbierto;
        showToast(
            'Se ha reanudado la caja\nApertura: ${cortePropio!.fechaApertura}$cierres');
      }
    }
  }

  Future<void> logeo() async {
    await aperturar();
    user = await UserController.getItem();
    categorias = await CategoriaController.getItems();
    pointNow = await MpagoPointController.getItem();
    empresas = await EmpresaController.getItems();
    sucursales = await SucursalController.getItems();
    formaPago = await FormaPagoController.getItems();
  }
}
