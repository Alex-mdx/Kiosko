import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:kiosko/models/device_model.dart';
import 'package:kiosko/models/producto_demo_model.dart';
import 'package:kiosko/utils/textos.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class PrintFinal {
  static Future<void> ticketCompra(
      {required PrinterModel? print,
      required List<ProductoDemoModel> carrito}) async {
    final profile = await CapabilityProfile.load();

    final generator = Generator(print!.paper!, profile);
    List<int> bytes = [];
    bytes += generator.reset();
    bytes += generator.text(Textos.normalizar('Carrito de compra'),
        linesAfter: 1,
        styles: const PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.row(multiLine: true, [
      PosColumn(
          text: ' Cantidad',
          width: 2,
          styles: const PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
          text: 'Producto',
          width: 7,
          styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: ' Monto',
          width: 3,
          styles: const PosStyles(align: PosAlign.right, bold: true))
    ]);
    bytes += generator.hr();
    double totalizado = 0.0;
    for (var pr in carrito) {
      totalizado += pr.total;
      bytes += generator.row(multiLine: true, [
        PosColumn(
            text: Textos.moneda(moneda: pr.cantidad),
            width: 2,
            styles: const PosStyles(align: PosAlign.right)),
        PosColumn(
            text: Textos.normalizar(pr.concepto),
            width: 7,
            styles: const PosStyles(align: PosAlign.left)),
        PosColumn(
            text:
                " \$${Textos.moneda(moneda: double.parse(pr.total.toString()))}",
            width: 3,
            styles: const PosStyles(align: PosAlign.right))
      ]);
    }

    bytes += generator.hr();
    bytes += generator.text(
        "Total: \$${Textos.moneda(moneda: double.parse(totalizado.toString()))}",
        linesAfter: 1,
        styles: PosStyles(align: PosAlign.right));
    bytes += generator.text(
        'Usted puede facturar este ticket\nGracias por su compra',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.reset();
    bytes += generator.cut();
    
      await PrintBluetoothThermal.writeBytes(bytes);
    
  }
}
