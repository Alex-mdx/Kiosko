import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kiosko/controllers/user_controller.dart';
import 'package:kiosko/models/familia_producto_model.dart';
import 'package:kiosko/utils/internet_except.dart';
import 'package:http/http.dart' as http;
import '../utils/route/link.dart';

class FamiliasProductoController {
  static Future<List<FamiliaProducto>> getApi() async {
    final user = await UserController.getItem();
    final uri = Uri.parse(
        "${Link.apiFamilia}${user?.databaseId}&api_key=${user?.uuid}");
    debugPrint('$uri');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<FamiliaProducto> familias = [];
        for (var element in data) {
          familias.add(FamiliaProducto.fromJson(element));
        }
        return familias;
      } else {
        ExcepcionInternet.errorHttp(
            status: response.statusCode, response: response.body);
        return [];
      }
    } catch (e) {
      ExcepcionInternet.errorRed(excepcion: e);
      return [];
    }
  }
}
