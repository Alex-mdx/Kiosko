import 'package:flutter/material.dart';
import 'package:kiosko/view/banner_view.dart';

import '../../models/menu_model.dart';
import '../../view/home_view.dart';
import '../../view/login_view.dart';
import '../shared_preferences.dart';

class AppRoutes {
  static final String initialRoute =  Preferencias.logeado ? 'home' : 'login';

  static final Map<String, Widget Function(BuildContext)> _routes = {
    banner: (_) => const BannerView(),
    login: (_) => const LoginView(),
    home: (_) => const HomeView()
  };

  static get routes => _routes;
  static String get login => 'login';
  static String get home => 'home';
  static String get banner => 'banner';
}
