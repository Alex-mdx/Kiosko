import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:kiosko/controllers/categoria_controller.dart';
import 'package:kiosko/controllers/contacto_controller.dart';
import 'package:kiosko/controllers/direccion_controller.dart';
import 'package:kiosko/controllers/empresa_controller.dart';
import 'package:kiosko/controllers/forma_pago_controller.dart';
import 'package:kiosko/controllers/grupo_familia_controller.dart';
import 'package:kiosko/utils/main_provider.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../controllers/producto_controller.dart';
import '../../controllers/sucursal_controller.dart';

class SyncPanelSincro extends StatefulWidget {
  const SyncPanelSincro({super.key});
  @override
  State<SyncPanelSincro> createState() => _SyncPanelSincroState();
}

class _SyncPanelSincroState extends State<SyncPanelSincro> {
  int lengthProducto = 0;
  int lengthContactos = 0;
  int lengthCategorias = 0;
  int lengthPagos = 0;
  int lengthEmpresas = 0;

  bool boolProducto = false;
  bool boolContactos = false;
  bool boolCategorias = false;
  bool boolPagos = false;
  bool boolEmpresas = false;
  @override
  void initState() {
    super.initState();
    itemsLength();
  }

  Future<void> itemsLength() async {
    var data1 = (await ContactoController.getItemsContacto()).length;
    var data2 = (await ProductosController.getItems()).length;
    var data4 = (await FormaPagoController.getItems()).length;
    var data6 = (await CategoriaController.getItems()).length;
    var data7 = (await EmpresaController.getItems()).length;
    setState(() {
      lengthContactos = data1;
      lengthProducto = data2;
      lengthPagos = data4;
      lengthCategorias = data6;
      lengthEmpresas = data7;
    });
  }

  @override
  Widget build(BuildContext context) {
    final proNavegacion = Provider.of<MainProvider>(context);
    String? error;
    Future<void> sincronizacion() async {
      try {
        proNavegacion.estadoSincronizacion = true;
        if (boolContactos) {
          error = 'contacto';
          await ContactoController.getApiContactos();
          showToast('guardo contactos');
          boolContactos = false;
        }
        if (boolEmpresas) {
          error = "empresas";
          await EmpresaController.getApiEmpresa(proNavegacion);
          proNavegacion.empresas = await EmpresaController.getItems();
          showToast('guardo empresas');
          for (var element in proNavegacion.empresas) {
            await DireccionController.getApiDireccion(element.direccionId!);
          }

          await SucursalController.getApi();
          final srsal = await SucursalController.getItems();
          for (var element in srsal) {
            await DireccionController.getApiDireccion(
              element.direccionId!,
            );
          }
          proNavegacion.sucursales = await SucursalController.getItems();
          showToast('guardo sucursal');
          //proNavegacion.imagenModel = await SQLHelperImagenInterno.getItems();
          proNavegacion.direcciones = await DireccionController.getItems();
          showToast('guardo direcciones');
          boolEmpresas = false;
        }
        if (boolProducto == true) {
          error = 'producto';
          await ProductosController.getApiProductos(proNavegacion);
          proNavegacion.categorias = await CategoriaController.getItems();
          proNavegacion.listaDetalle.clear();
          boolProducto = false;
        }
        if (boolPagos == true) {
          error = 'forma_pago';
          await FormaPagoController.getApiFormaPago();
          proNavegacion.formaPago = await FormaPagoController.getItems();
          showToast('guardo forma de pago');
          boolPagos = false;
        }
        if (boolCategorias == true) {
          error = 'categoria';
          await CategoriaController.getApiCategoria();
          proNavegacion.categorias = await CategoriaController.getItems();
          await GrupoFamiliaController.getApi();
          proNavegacion.grupoProducto = await GrupoFamiliaController.getItems();
          showToast('guardo grupo familia');
          boolCategorias = false;
        }
        await itemsLength();
        proNavegacion.estadoSincronizacion = false;
        showToast('Sincronizacion finalizada');
      } catch (e) {
        proNavegacion.estadoSincronizacion = false;
        showToast('$e', duration: const Duration(seconds: 4));
        log('$error\n$e');
      }
    }

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        child: Column(children: [
          ExpansionTile(
              initiallyExpanded: true,
              backgroundColor: Colors.grey[60],
              collapsedBackgroundColor: Colors.white,
              controlAffinity: ListTileControlAffinity.leading,
              childrenPadding: const EdgeInsets.symmetric(horizontal: 20),
              title: Text('Sincronización',
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
              children: <Widget>[
                ListTile(
                    title: Text('Productos | Cantidad: $lengthProducto',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: boolProducto == true &&
                            proNavegacion.estadoSincronizacion
                        ? const CircularProgressIndicator()
                        : null,
                    leading: Checkbox(
                        value: boolProducto,
                        onChanged: (value) {
                          setState(() {
                            if (!proNavegacion.estadoSincronizacion) {
                              boolProducto = value!;
                            }
                          });
                        })),
                ListTile(
                    title: Text('Contactos | Cantidad: $lengthContactos',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: boolContactos == true &&
                            proNavegacion.estadoSincronizacion
                        ? const CircularProgressIndicator()
                        : null,
                    leading: Checkbox(
                        value: boolContactos,
                        onChanged: (value) {
                          setState(() {
                            if (!proNavegacion.estadoSincronizacion) {
                              boolContactos = value!;
                            }
                          });
                        })),
                ListTile(
                    title: Text('Categorias | Cantidad: $lengthCategorias',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: boolCategorias == true &&
                            proNavegacion.estadoSincronizacion
                        ? const CircularProgressIndicator()
                        : null,
                    leading: Checkbox(
                        value: boolCategorias,
                        onChanged: (value) {
                          setState(() {
                            if (!proNavegacion.estadoSincronizacion) {
                              boolCategorias = value!;
                            }
                          });
                        })),
                ListTile(
                    title: Text('Formas de pagos | Cantidad: $lengthPagos',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing:
                        boolPagos == true && proNavegacion.estadoSincronizacion
                            ? const CircularProgressIndicator()
                            : null,
                    leading: Checkbox(
                        value: boolPagos,
                        onChanged: (value) {
                          setState(() {
                            if (!proNavegacion.estadoSincronizacion) {
                              boolPagos = value!;
                            }
                          });
                        })),
                ListTile(
                    title: Text('Empresas | Cantidad: $lengthEmpresas',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: boolEmpresas == true &&
                            proNavegacion.estadoSincronizacion
                        ? const CircularProgressIndicator()
                        : null,
                    leading: Checkbox(
                        value: boolEmpresas,
                        onChanged: (value) {
                          setState(() {
                            if (!proNavegacion.estadoSincronizacion) {
                              boolEmpresas = value!;
                            }
                          });
                        })),
                ElevatedButton.icon(
                    onPressed: () async {
                      if (!proNavegacion.estadoSincronizacion) {
                        proNavegacion.estadoSincronizacion = true;

                        await sincronizacion();
                      } else {
                        showToast('Espere un momento');
                      }
                    },
                    icon: const Icon(Icons.sync),
                    label: AnimatedDefaultTextStyle(
                        style: !proNavegacion.estadoSincronizacion
                            ? const TextStyle(color: Colors.black)
                            : const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                        duration: const Duration(milliseconds: 500),
                        child: !proNavegacion.estadoSincronizacion
                            ? const Text('Sincronizar')
                            : const Text('Sincronizando...')))
              ])
        ]));
  }
}
