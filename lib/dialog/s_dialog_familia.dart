import 'package:flutter/material.dart';
import 'package:kiosko/models/familia_producto_model.dart';
import 'package:kiosko/theme/app_colors.dart';
import 'package:kiosko/utils/services/navigation_service.dart';
import 'package:kiosko/utils/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../controllers/familias_producto_controller.dart';

class SDialogFamilia extends StatefulWidget {
  const SDialogFamilia({super.key});

  @override
  State<SDialogFamilia> createState() => _SDialogFamiliaState();
}

class _SDialogFamiliaState extends State<SDialogFamilia> {
  bool carga = true;
  List<FamiliaProducto> familias = [];

  @override
  void initState() {
    super.initState();
    familia();
  }

  Future<void> familia() async {
    setState(() {
      carga = true;
    });

    var data = await FamiliasProductoController.getApi();
    familias = data;
    setState(() {
      carga = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      AppBar(
          title: Text("Seleccione una familia",
              style: TextStyle(fontSize: 16.sp))),
      carga
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator())
          : familias.isEmpty
              ? Padding(
                  padding: EdgeInsets.all(8.sp),
                  child: Text("No se creo ninguna familia",
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.bold)))
              : ListView.builder(
                  itemCount: familias.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                  itemBuilder: (context, index) {
                    final familia = familias[index];
                    return Padding(
                        padding: EdgeInsets.only(bottom: 1.h),
                        child: ListTile(
                            onTap: () {
                              Preferencias.familiaCat = familia.id;
                              Navigation.pop();
                            },
                            selected: Preferencias.familiaCat == familia.id,
                            selectedTileColor: LightThemeColors.green,
                            leading: Icon(Icons.group_work_outlined,
                                size: 18.sp, color: LightThemeColors.primary),
                            title: Text(familia.nombre,
                                style: TextStyle(fontSize: 16.sp))));
                  })
    ]));
  }
}
