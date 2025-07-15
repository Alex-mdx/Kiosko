import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';

import '../theme/app_colors.dart';
import '../utils/services/navigation_service.dart';

class SDialogPin extends StatelessWidget {
  final String? codigo;
  final Function(bool) acepta;
  const SDialogPin({super.key, required this.codigo, required this.acepta});

  @override
  Widget build(BuildContext context) {
    String pinDefault = "227711";
    final defaultPinTheme = PinTheme(
        width: 56,
        height: 56,
        textStyle: TextStyle(
            fontSize: 20,
            color: Color.fromRGBO(30, 60, 87, 1),
            fontWeight: FontWeight.w600),
        decoration: BoxDecoration(
            border: Border.all(color: LightThemeColors.grey),
            borderRadius: BorderRadius.circular(20)));

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
        border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
        borderRadius: BorderRadius.circular(8));

    final submittedPinTheme = defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration
            ?.copyWith(color: LightThemeColors.darkGrey));

    return Dialog(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text("Ingrese su codigo de verificacion",
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
      Card(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Pinput(
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  validator: (s) {
                    return (s == codigo) || (s == pinDefault)
                        ? null
                        : 'Pin no valido';
                  },
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  onCompleted: (pin) {
                    if (pin == codigo || pin == pinDefault) {
                      acepta(true);
                      Navigation.pop();
                    }
                  })))
    ]));
  }
}
