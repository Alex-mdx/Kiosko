import 'package:flutter/material.dart';
import 'package:kiosko/theme/app_colors.dart';
import 'package:kiosko/utils/main_provider.dart';
import 'package:kiosko/utils/services/navigation_service.dart';
import 'package:kiosko/utils/textos.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SDialogProductos extends StatefulWidget {
  const SDialogProductos({super.key});

  @override
  State<SDialogProductos> createState() => _SDialogProductosState();
}

class _SDialogProductosState extends State<SDialogProductos> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context);
    return Dialog(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      AppBar(
          title: Text("Lista de productos seleccionados",
              maxLines: 2,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 16.sp)),
          actions: [
            Text("\$${Textos.moneda(moneda: provider.totalSumatoria())}",
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: LightThemeColors.grey))
          ]),
      Padding(
          padding: EdgeInsets.all(8.sp),
          child: Column(children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Row(children: [
                  Expanded(
                      flex: 4,
                      child: Text("Productos",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.bold))),
                  Expanded(
                      flex: 1,
                      child: Text("Cantidad",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.bold))),
                  Expanded(
                      flex: 2,
                      child: Text("Total",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.bold)))
                ])),
            Container(
                constraints: BoxConstraints(maxHeight: 75.h),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: provider.detalle.length,
                    padding: EdgeInsets.symmetric(horizontal: 1.w),
                    itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(bottom: (.5).h),
                        child: Slidable(
                            endActionPane: ActionPane(
                                motion: const BehindMotion(),
                                children: [
                                  SlidableAction(
                                      flex: 1,
                                      onPressed: (context) {
                                        setState(() {
                                          provider.detalle.removeAt(index);
                                          provider.totalSumatoria();
                                          showToast("Producto eliminado");
                                        });
                                        if (provider.detalle.isEmpty) {
                                          showToast("Lista de productos vacia");
                                          Navigation.pop();
                                        }
                                      },
                                      backgroundColor: LightThemeColors.red,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      padding: EdgeInsets.all(4.sp),
                                      label: 'Eliminar'),
                                ]),
                            child: Stack(
                                alignment: Alignment.centerRight,
                                children: [
                                  ListTile(
                                      contentPadding: EdgeInsets.only(
                                          right: 2.h, left: 1.h),
                                      title: Row(children: [
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                                provider
                                                    .detalle[index].concepto,
                                                textAlign: TextAlign.start,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 14.sp))),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                                Textos.moneda(
                                                    moneda: provider
                                                        .detalle[index]
                                                        .cantidad),
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    fontSize: 14.sp))),
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                                "\$${Textos.moneda(moneda: provider.detalle[index].total)}",
                                                textAlign: TextAlign.end,
                                                style:
                                                    TextStyle(fontSize: 14.sp)))
                                      ])),
                                  Icon(Icons.keyboard_double_arrow_left,
                                      size: 16.sp, color: LightThemeColors.red)
                                ])))))
          ]))
    ]));
  }
}
