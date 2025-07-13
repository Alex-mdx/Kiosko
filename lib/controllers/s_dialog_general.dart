import 'package:flutter/material.dart';
import 'package:kiosko/utils/main_provider.dart';
import 'package:sizer/sizer.dart';
class DialoGeneral extends StatefulWidget {
  final String encabezado;
  final String? subText;
  final MainProvider? proNavegacion;
  final Widget? child;

  const DialoGeneral(
      {super.key,
      this.child,
      this.proNavegacion,
      required this.encabezado,
      this.subText});

  @override
  State<DialoGeneral> createState() => DialoGeneralState();
}

class DialoGeneralState extends State<DialoGeneral> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(widget.encabezado,
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              if (widget.subText != null)
                Text(widget.subText!,
                    style: TextStyle(fontSize: 14.sp),
                    textAlign: TextAlign.center),
              if (widget.child != null) widget.child!
            ])));
  }
}
