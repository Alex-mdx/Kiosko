import 'package:flutter/foundation.dart';
import 'package:kiosko/controllers/MPago_point_controller.dart';
import 'package:kiosko/controllers/empresa_controller.dart';
import 'package:kiosko/controllers/forma_pago_controller.dart';
import 'package:kiosko/controllers/sucursal_controller.dart';
import 'package:kiosko/controllers/user_controller.dart';
import 'package:kiosko/models/MPago_point_model.dart';
import 'package:kiosko/models/direccion_model.dart';
import 'package:kiosko/models/empresa_model.dart';
import 'package:kiosko/models/forma_pago_model.dart';
import 'package:kiosko/models/sucursal_model.dart';
import 'package:kiosko/models/usuario_model.dart';

import '../models/device_model.dart';
import '../models/venta_detalle_model.dart';

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

  //!FUNCIONES
  double totalSumatoria() {
    var monto = 0.0;
    for (var element in listaDetalle) {
      monto += element.total ?? 0;
    }
    return monto;
  }

  Future<void> logeo() async {
    user = await UserController.getItem();
    pointNow = await MpagoPointController.getItem();
    empresas = await EmpresaController.getItems();
    sucursales = await SucursalController.getItems();
    formaPago = await FormaPagoController.getItems();
  }
}
