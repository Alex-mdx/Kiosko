import 'package:flutter/material.dart';
import 'package:kiosko/utils/main_provider.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../theme/app_colors.dart';
import '../../utils/textos.dart';
import '../../utils/venta_generar.dart';

class ProductoWidget extends StatefulWidget {
  final List<Map<String,dynamic>> productos;
  const ProductoWidget({super.key, required this.productos});

  @override
  State<ProductoWidget> createState() => _ProductoWidgetState();
}

class _ProductoWidgetState extends State<ProductoWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context);
    return LiquidPullToRefresh(
        springAnimationDurationInMilliseconds: 500,
        onRefresh: () async {},
        child: Scrollbar(
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: .8,
                    crossAxisSpacing: 0),
                padding: EdgeInsets.symmetric(horizontal: .5.w),
                itemCount: widget.productos.length,
                itemBuilder: (context, index) => Card(
                    child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() {
                            VentaGenerar.addCarrito(
                                provider: provider,
                                producto: widget.productos[index]);
                          });
                        },
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  height: (8).h,
                                  child: Image.asset(
                                      "${widget.productos[index]["img"]}",
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Image.asset("assets/no_img.jpg",
                                                  fit: BoxFit.contain),
                                      fit: BoxFit.contain)),
                              Text("${widget.productos[index]["descripcion"]}",
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      height: .1.h, fontSize: (14).sp)),
                              Text(
                                  "\$${Textos.moneda(moneda: double.parse(widget.productos[index]["monto"].toString()))} MXN",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: LightThemeColors.green,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold))
                            ]))))));
  }
}
