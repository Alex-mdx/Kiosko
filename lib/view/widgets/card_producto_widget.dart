import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:kiosko/models/producto_model.dart';
import 'package:kiosko/utils/main_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../theme/app_colors.dart';
import '../../utils/funcion_parser.dart';
import '../../utils/generador_compras.dart';
import '../../utils/textos.dart';

class CardProductoWidget extends StatefulWidget {
  final ProductoModel producto;
  const CardProductoWidget({super.key, required this.producto});

  @override
  State<CardProductoWidget> createState() => CardProductoWidgetState();
}

class CardProductoWidgetState extends State<CardProductoWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context);
    return InkWell(
        hoverColor: LightThemeColors.background,
        onTap: () async {
          await Haptics.vibrate(HapticsType.medium);
          await GeneradorCompras.agregarCarrito(
              provider, widget.producto, null, [], "", []);
        },
        child: Card(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  clipBehavior: Clip.antiAlias,
                  child: SizedBox(
                      width: double.infinity,
                      height: 8.h,
                      child: widget.producto.file == null ||
                              widget.producto.file == "null"
                          ? Image.asset("assets/no_img.jpg",
                              fit: BoxFit.contain)
                          : Image.memory(
                              Parser.toUint8List(widget.producto.file)!,
                              fit: BoxFit.contain,
                              gaplessPlayback: true,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset("assets/no_img.jpg",
                                      fit: BoxFit.contain)))),
              Flexible(
                  child: AutoSizeText(widget.producto.descripcion,
                      maxLines: 2,
                      minFontSize: 8,
                      maxFontSize: 20,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: LightThemeColors.primary,
                          fontWeight: FontWeight.bold))),
              Text(
                  "\$${Textos.moneda(moneda: double.parse(widget.producto.precio ?? "0"))} MXN",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: LightThemeColors.green,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold))
            ])));
  }
}
