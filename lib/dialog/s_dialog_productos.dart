import 'package:flutter/material.dart';
import 'package:kiosko/utils/main_provider.dart';
import 'package:kiosko/utils/textos.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

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
          title: Text("Lista De Productos seleccionados",
              style: TextStyle(fontSize: 16.sp))),
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
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 1,
                    child: Text("Cantidad",
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 14.sp))),
                Expanded(
                    flex: 2,
                    child: Text("Total",
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 14.sp)))
              ]),
            ),
            Container(
                constraints: BoxConstraints(maxHeight: 75.h),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: provider.detalle.length,
                    padding: EdgeInsets.symmetric(horizontal: 1.w),
                    itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(bottom: (.5).h),
                        child: ListTile(
                            title: Row(children: [
                          Expanded(
                              flex: 4,
                              child: Text(provider.detalle[index].concepto,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: 14.sp))),
                          Expanded(
                              flex: 1,
                              child: Text(
                                  Textos.moneda(
                                      moneda: provider.detalle[index].cantidad),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(fontSize: 14.sp))),
                          Expanded(
                              flex: 2,
                              child: Text(
                                  Textos.moneda(
                                      moneda: provider.detalle[index].total),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(fontSize: 14.sp)))
                        ])))))
          ]))
    ]));
  }
}
