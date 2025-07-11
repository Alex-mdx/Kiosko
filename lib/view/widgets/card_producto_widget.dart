import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kiosko/models/producto_model.dart';
import 'package:kiosko/utils/main_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../theme/app_colors.dart';
import '../../utils/funcion_parser.dart';
import '../../utils/generador_compras.dart';
import '../../utils/textos.dart';

class CardProductoWidget extends StatelessWidget {
  final ProductoModel producto;
  const CardProductoWidget({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context);
    return Card(
        child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async => await GeneradorCompras.agregarCarrito(
                provider, producto, null, [], "", []),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox(
                          width: double.infinity,
                          height: 8.h,
                          child: producto.file == null ||
                                  producto.file == "null"
                              ? Image.asset("assets/no_img.jpg",
                                  fit: BoxFit.contain)
                              : Image.memory(Parser.toUint8List(producto.file)!,
                                  fit: BoxFit.contain,
                                  gaplessPlayback: true,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset("assets/no_img.jpg",
                                          fit: BoxFit.contain)))),
                  Flexible(
                      child: AutoSizeText(producto.descripcion,
                          maxLines: 2,
                          minFontSize: 8,
                          maxFontSize: 20,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: LightThemeColors.primary,
                              fontWeight: FontWeight.bold))),
                  Text(
                      "\$${Textos.moneda(moneda: double.parse(producto.precio ?? "0"))} MXN",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: LightThemeColors.green,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold))
                ])));
  }
}
