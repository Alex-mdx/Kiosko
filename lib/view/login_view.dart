import 'dart:developer';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:kiosko/controllers/user_controller.dart';
import 'package:kiosko/utils/main_provider.dart';
import 'package:kiosko/utils/route/link.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../theme/app_colors.dart';
import '../utils/services/navigation_service.dart';
import '../utils/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var userController = TextEditingController();
  var passwordController = TextEditingController();
  bool hidePassword = true;
  String iniciaSesion = 'idle';
  @override
  Widget build(BuildContext context) {
    OutlineInputBorder enabledBorder = OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(15));
    OutlineInputBorder focusedBorder = OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(15));
    OutlineInputBorder errorBorder = OutlineInputBorder(
        borderSide: const BorderSide(color: Color.fromARGB(255, 192, 36, 36)),
        borderRadius: BorderRadius.circular(15));
    OutlineInputBorder focusedErrorBorder = OutlineInputBorder(
        borderSide: const BorderSide(color: Color.fromARGB(255, 192, 36, 36)),
        borderRadius: BorderRadius.circular(15));
    final provider = Provider.of<MainProvider>(context);

    return SafeArea(
        child: Scaffold(
            body: Stack(children: <Widget>[
      Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
          child: Column(children: [
            TextButton(
                onPressed: () {
                  if (kDebugMode) {}
                },
                child: Text(Link.apiSoferp,
                    style: TextStyle(
                        fontSize: 12.sp, fontWeight: FontWeight.bold))),
            Image.asset('assets/logo_name.png', height: 18.h)
          ])),
      Center(
          child: Card(
              margin: EdgeInsets.only(left: 4.w, right: 4.w, top: 2.h),
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    //Título
                    Text('Cuenta',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp),
                        textAlign: TextAlign.center),

                    SizedBox(height: 1.h),

                    _userTextFormField(
                        enabledBorder: enabledBorder,
                        focusedBorder: focusedBorder,
                        errorBorder: errorBorder,
                        focusedErrorBorder: focusedErrorBorder),
                    SizedBox(height: 1.h),
                    _passwordTextFormField(
                        enabledBorder: enabledBorder,
                        focusedBorder: focusedBorder,
                        errorBorder: errorBorder,
                        focusedErrorBorder: focusedErrorBorder),
                    SizedBox(height: 1.h),
                    _iniciarSesionBoton(provider)
                  ]))))
    ])));
  }

  TextButton _iniciarSesionBoton(MainProvider provider) {
    return TextButton(
        style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(
              LightThemeColors.darkBlue,
            ),
            padding: WidgetStatePropertyAll(EdgeInsets.all(15.sp)),
            shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7))))),
        onPressed: () async {
          if (iniciaSesion == "idle") {
            setState(() {
              iniciaSesion = 'loading';
            });

            showToast("Verificando conexion al internet");
            bool result = (await InternetConnectionCheckerPlus().hasConnection);
            log("$result");

            if (result) {
              if (userController.text.isNotEmpty &&
                  passwordController.text.isNotEmpty) {
                if (iniciaSesion == 'loading') {
                  iniciaSesion = await UserController.login(
                      [userController.text, passwordController.text], provider);
                }
                if (iniciaSesion == 'success') {
                  Preferencias.logeado = true;
                  await Navigation.pushReplacementNamed(routeName: 'home');
                }
                setState(() {});
              } else {
                showToast("Operacion en proceso");
              }
            } else {
              showToast(
                'Los campos para tu usuario y contraseña no pueden estar vacíos',
                dismissOtherToast: true,
              );
            }
          }
        },
        child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: iniciaSesion == 'loading'
                ? Stack(alignment: Alignment.center, children: [
                    const CircularProgressIndicator(color: Colors.white),
                    AnimatedFlipCounter(
                        value: provider.cargaApi,
                        fractionDigits: 2,
                        suffix: "%",
                        duration: const Duration(milliseconds: 500),
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold))
                  ])
                : Text('Iniciar Sesion',
                    style: TextStyle(color: Colors.white, fontSize: 15.sp))));
  }

  TextFormField _passwordTextFormField({
    required OutlineInputBorder enabledBorder,
    required OutlineInputBorder focusedBorder,
    required OutlineInputBorder errorBorder,
    required OutlineInputBorder focusedErrorBorder,
  }) {
    return TextFormField(
      enabled: iniciaSesion == "loading" ? false : true,
      controller: passwordController,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        suffixIcon: IconButton(
          icon: hidePassword
              ? const Icon(
                  Icons.visibility_off_outlined,
                  color: Colors.grey,
                )
              : const Icon(Icons.visibility_outlined, color: Colors.grey),
          onPressed: () {
            setState(() {
              hidePassword = !hidePassword;
            });
          },
        ),
        fillColor: Colors.blueGrey[50],
        labelStyle: TextStyle(fontSize: 15.sp),
        contentPadding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 6.w),
        enabledBorder: enabledBorder,
        focusedBorder: focusedBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: focusedErrorBorder,
      ),
      obscureText: hidePassword,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Escribe tu contraseña';
        } else {
          return null;
        }
      },
    );
  }

  TextFormField _userTextFormField({
    required OutlineInputBorder enabledBorder,
    required OutlineInputBorder focusedBorder,
    required OutlineInputBorder errorBorder,
    required OutlineInputBorder focusedErrorBorder,
  }) {
    return TextFormField(
      enabled: iniciaSesion == "loading" ? false : true,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      controller: userController,
      decoration: InputDecoration(
        labelText: 'Usuario',
        fillColor: Colors.blueGrey[50],
        labelStyle: TextStyle(fontSize: 15.sp),
        contentPadding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 6.w),
        enabledBorder: enabledBorder,
        focusedBorder: focusedBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: focusedErrorBorder,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Escribe tu usuario';
        } else {
          return null;
        }
      },
    );
  }
}
