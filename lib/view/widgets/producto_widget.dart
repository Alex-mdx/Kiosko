import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:kiosko/controllers/producto_controller.dart';
import 'package:kiosko/theme/app_colors.dart';
import 'package:kiosko/utils/main_provider.dart';
import 'package:kiosko/utils/services/dialog_services.dart';
import 'package:kiosko/view/widgets/card_producto_widget.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';
import 'package:sizer/sizer.dart';

class ProductoWidget extends StatefulWidget {
  const ProductoWidget({super.key});

  @override
  State<ProductoWidget> createState() => _ProductoWidgetState();
}

class _ProductoWidgetState extends State<ProductoWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context);
    return FutureBuilder(
        future: ProductosController.getItems(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.isEmpty
                ? Center(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Text("Lista de productos vacia",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.bold)),
                        ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(40),
                            child: Container(
                                color: LightThemeColors.darkBlue,
                                child: RiveAnimatedIcon(
                                    onTap: () async {
                                      await Dialogs.showMorph(
                                          title: "Descargar productos",
                                          description:
                                              "Se va a descargar el catalogo de productos para el kiosko",
                                          loadingTitle: "Descargando",
                                          onAcceptPressed: (context) async {
                                            await ProductosController
                                                .getApiProductos(provider);
                                            setState(() {});
                                          });
                                    },
                                    riveIcon: RiveIcon.refresh,
                                    width: 12.w,
                                    height: 12.w,
                                    color: Colors.green,
                                    strokeWidth: 3.w,
                                    loopAnimation: true)))
                      ]))
                : LiquidPullToRefresh(
                    springAnimationDurationInMilliseconds: 500,
                    onRefresh: () async {
                      
                      await ProductosController.getApiProductos(provider);
                      setState(() {});
                      showToast("Productos actualizados");
                    },
                    child: Scrollbar(
                        child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    childAspectRatio: .8,
                                    crossAxisSpacing: 0),
                            padding: EdgeInsets.symmetric(horizontal: .5.w),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              var producto = snapshot.data![index];
                              return CardProductoWidget(producto: producto);
                            })));
          } else if (snapshot.hasError) {
            return Center(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Text("Error\n${snapshot.error}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.sp)),
                  RiveAnimatedIcon(
                      riveIcon: RiveIcon.warning,
                      width: 18.w,
                      height: 18.w,
                      color: Colors.red,
                      strokeWidth: 3.w,
                      loopAnimation: true)
                ]));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
