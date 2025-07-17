import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiosko/utils/main_provider.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme.dart';
import 'utils/route/app_routes.dart';
import 'utils/services/navigation_key.dart';
import 'utils/shared_preferences.dart';

class PostHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) => super.createHttpClient(context)
    ..badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = PostHttpOverrides();
  await Preferencias.init();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]).then((_) {
    runApp(MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => MainProvider())],
        child: const POS()));
  });
}

class POS extends StatelessWidget {
  const POS({super.key});
  @override
  Widget build(BuildContext context) => Sizer(
      builder: ((context, orientation, deviceType) => OKToast(
          position: ToastPosition.bottom,
          dismissOtherOnShow: true,
          textStyle: TextStyle(fontSize: 15.sp, color: LightThemeColors.grey),
          duration: const Duration(seconds: 4),
          child: MaterialApp(
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate
              ],
              supportedLocales: const [
                Locale('es')
              ],
              debugShowCheckedModeBanner: false,
              title: 'kiosko',
              theme: AppTheme.lightTheme,
              navigatorKey: NavigationKey.navigatorKey,
              initialRoute: AppRoutes.initialRoute,
              routes: AppRoutes.routes))));
}