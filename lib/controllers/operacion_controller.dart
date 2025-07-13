import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kiosko/controllers/user_controller.dart';
import 'package:kiosko/utils/main_provider.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sizer/sizer.dart';
import '../models/venta_detalle_model.dart';
import '../models/venta_model.dart';
import '../models/venta_pago_model.dart';
import '../theme/app_colors.dart';
import '../utils/internet_except.dart';
import '../utils/route/link.dart';
import 'corte_cobro_propio_controller.dart';
import 'empresa_controller.dart';
import 'package:http/http.dart' as http;

class SqlOperaciones {
  static Future<VentaModel> pagoVenta(VentaModel ventaActual) async {
    final user = await UserController.getItem();
    final uri = Uri.parse("${Link.apiCorte}?api_key=${user!.uuid}");
    VentaModel ventaSync = ventaActual.copyWith(
        folio: ventaActual.consecutivo.toString(),
        apiKeyId: user.id,
        userId: user.userId,
        empresaId: user.empresaId,
        almacenId: user.almacenId,
        sucursalId: user.sucursalId,
        cuentaBancariaId: user.cuentaBancariaId);
    String body = jsonEncode([ventaSync]);
    try {
      final response =
          await http.post(uri, body: body, headers: Servidor.bodyHeader);
      if (response.statusCode == 200) {
        showToastWidget(
            Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.black.withAlpha(190),
                    borderRadius: BorderRadius.circular(20)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.attach_money_sharp,
                      color: LightThemeColors.green, size: 18.sp),
                  Icon(Icons.cloud_done,
                      color: LightThemeColors.green, size: 18.sp),
                  Text('Venta sincronizada con exito',
                      style: TextStyle(fontSize: 14.sp, color: Colors.white))
                ])),
            duration: const Duration(seconds: 3),
            position: const ToastPosition(align: Alignment.center));
        debugPrint('sincronizo');

        return ventaSync.copyWith(sincronizado: 1, status: 0, cerrado: 1);
      } else {
        debugPrint('Error ${response.statusCode}\n${response.body}');
        showToastWidget(
            DialogCompra(
                response:
                    "${jsonDecode(response.body)["error"] ?? response.body}"),
            duration: const Duration(seconds: 6),
            position: const ToastPosition(align: Alignment.center),
            dismissOtherToast: true);
        return ventaActual.copyWith(
            errorVenta: response.body, status: response.statusCode);
      }
    } catch (e) {
      debugPrint('Error $e');
      showToastWidget(DialogCompra(response: "$e"),
          duration: const Duration(seconds: 6),
          position: const ToastPosition(align: Alignment.center),
          dismissOtherToast: true);
      return ventaActual.copyWith(errorVenta: '$e', status: -1);
    }
  }

  static Future<bool> pagoTotal(
      MainProvider proNavegar, String trasanccion) async {
    final uri = Uri.parse("${Link.apiCorte}?api_key=${proNavegar.user!.uuid}");

    try {
      final ventaSesion = (await SQLHelperCortePropio.getItem(trasanccion))
          .where((element) => element.sincronizado == 0)
          .toList();
      List<VentaModel> compraVenta = [];
      for (var i = 0; i < ventaSesion.length; i++) {
        List<Detalles> compraDetalles = [];
        List<PagoModel> compraPagos = [];
        if (ventaSesion[i].cerrado == 1) {
          for (var element in ventaSesion[i].detalles) {
            compraDetalles.add(element);
          }
          for (var elemento in ventaSesion[i].pagos) {
            /* Pago newpago = Pago(
                  id: elemento['id'],
                  nombre: elemento['nombre'],
                  databaseId: elemento['database_id'],
                  factorComision: elemento['factor_comision'],
                  codigoSat: elemento['codigo_sat'],
                  cuentaContable: elemento['cuenta_contable'],
                  metodoPago: elemento['metodo_pago'],
                  formaPago: elemento['forma_pago'],
                  moneda: elemento['moneda'],
                  permitirCambio: elemento['permitir_cambio'],
                  importe: elemento['importe'],
                  referencia: elemento['referencia'],
                  cambio: elemento['cambio'],
                  tipoCambio: elemento['tipo_cambio'],
                  cuentaBancariaId: proNavegar.user['cuenta_bancaria_id'],
                  formaPagoId: elemento['forma_pago_id']);
                  compraPagos.add(newpago);*/
            compraPagos.add(elemento);
          }

          VentaModel ventaTotal = VentaModel(
              folio: ventaSesion[i].consecutivo.toString(),
              consecutivo: ventaSesion[i].consecutivo,
              sincronizado: ventaSesion[i].sincronizado,
              apiKeyId: proNavegar.user!.id,
              contactoId: ventaSesion[i].contactoId,
              vendedorId: ventaSesion[i].vendedorId,
              userId: proNavegar.user!.userId,
              empresaId: proNavegar.user!.empresaId,
              almacenId: proNavegar.user!.almacenId,
              sucursalId: proNavegar.user!.sucursalId,
              cuentaBancariaId: proNavegar.user!.cuentaBancariaId,
              moneda: ventaSesion[i].moneda,
              metodoPago: ventaSesion[i].metodoPago,
              razonSocialId: ventaSesion[i].razonSocialId,
              fecha: ventaSesion[i].fecha,
              serie: ventaSesion[i].serie,
              total: double.parse(ventaSesion[i].total.toString()),
              comision: double.parse(ventaSesion[i].comision.toString()),
              tipoCambio: double.parse(ventaSesion[i].tipoCambio.toString()),
              formaPagoId: ventaSesion[i].formaPagoId,
              cerrado: ventaSesion[i].cerrado,
              notas: ventaSesion[i].notas,
              transaccion: ventaSesion[i].transaccion,
              fechaApertura: ventaSesion[i].fechaApertura,
              fechaCierre: ventaSesion[i].fechaCierre,
              detalles: compraDetalles,
              pagos: compraPagos);
          compraVenta.add(ventaTotal);
        }
      }
      String body = jsonEncode(compraVenta);
      try {
        final response =
            await http.post(uri, body: body, headers: Servidor.bodyHeader);
        if (response.statusCode == 200) {
          showToast('Envio exitoso del corte');
          await SQLHelperCortePropio.deleteCorte(trasanccion);
          return true;
        } else {
          showToast('Error->${response.statusCode}\n${response.body}');
          debugPrint('Error->${response.statusCode}\n${response.body}');
          return false;
        }
      } catch (e) {
        showToast('Error\n$e', duration: const Duration(seconds: 4));
        debugPrint('Error\n$e');
        proNavegar.cargaApi = 0;
        return false;
      }
    } catch (e) {
      showToast('Error\n$e', duration: const Duration(seconds: 4));
      proNavegar.cargaApi = 0;
      debugPrint('Error\n$e');
      return false;
    }
  }

  static Future<void> eliminarVenta(
      {required String folio,
      required String fecha,
      required String serie,
      required MainProvider proNavegacion}) async {
    final user = await UserController.getItem();
    debugPrint(serie);
    final uri = Uri.parse(
        "${Link.apiVentaEliminar}/$folio?database_id=${user!.databaseId}&api_key=${user.uuid}");
    String body = jsonEncode({'serie': serie, "fecha": fecha});
    debugPrint('$uri');
    try {
      final response =
          await http.delete(uri, body: body, headers: Servidor.bodyHeader);
      if (response.statusCode == 200) {
        showToast('Eliminacion de la venta: $serie$folio\nEfectuada con exito');
        await SQLHelperCortePropio.deleteItems(folio);
      } else {
        debugPrint('${response.statusCode} ${response.body}');
        showToast('Error status:${response.statusCode}\n${response.body}');
      }
    } catch (e) {
      debugPrint('$e');
      showToast('Error Response\n$e', duration: const Duration(seconds: 4));
    }
  }

  static Future<int?> solicitarPin() async {
    final user = await UserController.getItem();
    final empresa = await EmpresaController.getItem(user!.empresaId!);
    final uri = Uri.parse(
        "${Link.apiPin}?database_id=${user.databaseId}&api_key=${user.uuid}");
    String body = jsonEncode({
      'correo': "${kDebugMode ? "alexarmandomdx@gmail.com" : empresa?.correo}",
      'tipo_operacion': "Autorizacion de eliminacion de venta",
      'user_id': user.userId
    });
    debugPrint("$uri");
    debugPrint("${kDebugMode ? "alexarmandomdx@gmail.com" : empresa?.correo}");
    try {
      final response =
          await http.post(uri, body: body, headers: Servidor.bodyHeader);

      if (response.statusCode == 200) {
        final jasonData = jsonDecode(response.body);
        debugPrint('response: $jasonData');
        showToast("Codigo enviado");
        return jasonData['codigo'];
      } else {
        ExcepcionInternet.errorHttp(
            status: response.statusCode, response: response.body);
        return null;
      }
    } catch (e) {
      debugPrint('$e');
      showToast('Error Response\n$e', duration: const Duration(seconds: 4));
      return null;
    }
  }
}

class DialogCompra extends StatelessWidget {
  final String response;
  const DialogCompra({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.black.withAlpha(190),
            borderRadius: BorderRadius.circular(20)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.attach_money_sharp,
                color: LightThemeColors.primary, size: 18.sp),
            Text('Error al enviar venta',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: Colors.white))
          ]),
          Text(response,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, color: Colors.white))
        ]));
  }
}
