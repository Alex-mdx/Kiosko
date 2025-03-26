import 'package:flutter/foundation.dart';
import 'package:kiosko/controllers/MPago_point_controller.dart';
import 'package:kiosko/controllers/user_controller.dart';
import 'package:kiosko/models/MPago_point_model.dart';
import 'package:kiosko/models/usuario_model.dart';

import '../models/device_model.dart';

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

  Future<void> logeo() async {
    user = await UserController.getItem();
    pointNow = await MpagoPointController.getItem();
  }
}
