import 'package:kiosko/models/producto_demo_model.dart';
import 'package:kiosko/utils/main_provider.dart';

class VentaGenerar {
  static Future<void> addCarrito(
      {required MainProvider provider,
      required Map<String, dynamic> producto}) async {
    bool coincidencia = false;
    for (var i = 0; i < provider.detalle.length; i++) {
      if (producto['id'] == provider.detalle[i].id) {
        var cantidadTemp = provider.detalle[i].cantidad + 1;
        ProductoDemoModel temp = provider.detalle[i].copyWith(
            cantidad: cantidadTemp, total: producto['monto'] * cantidadTemp);
        provider.detalle[i] = temp;
        coincidencia = true;
      }
    }
    if (!coincidencia) {
      ProductoDemoModel carrito = ProductoDemoModel(
          id: producto['id'],
          concepto: producto['descripcion'],
          cantidad: 1,
          descuento: 0,
          precio: producto['monto'],
          total: producto['monto']);
      provider.detalle.add(carrito);
    }
  }

  static double sumatoria(List<double> montos) {
    var sumador = 0.0;
    for (var element in montos) {
      sumador += element;
    }
    return sumador;
  }
}
