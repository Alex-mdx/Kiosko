import 'package:flutter/material.dart';
import 'package:kiosko/view/banner_view.dart';

import '../../models/menu_model.dart';
import '../../view/home_view.dart';
import '../../view/login_view.dart';
import '../shared_preferences.dart';

class AppRoutes {
  static final rutaInicial = !Preferencias.logeado
          ? 'home'
          : 'login';

  static final menuOpciones = <MenuOpcion>[
    MenuOpcion(ruta: 'home', vista: const HomeView()),
    MenuOpcion(ruta: 'login', vista: const LoginView()),
    MenuOpcion(ruta: 'banner', vista: const BannerView())
  ];

  static Map<String, Widget Function(BuildContext)> getAppRutas() {
    Map<String, Widget Function(BuildContext)> appRutas = {};

    for (var opcion in menuOpciones) {
      appRutas.addAll({opcion.ruta: (BuildContext context) => opcion.vista});
    }
    return appRutas;
  }
}
