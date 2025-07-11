import 'dart:developer';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'route/link.dart';

class Parser {
  static int? toInt(var variableBool) {
    if (variableBool != null) {
      int parseo = variableBool == true
          ? 1
          : variableBool == false
              ? 0
              : variableBool;
      return parseo;
    }
    return null;
  }

  static Uint8List? toUint8List(String? byte8list) {
    if (byte8list != null && byte8list != "null") {
      byte8list = byte8list.replaceAll("[", "").replaceAll("]", "");

      List<String> stringValues = byte8list.split(", ");

      Uint8List uint8List =
          Uint8List.fromList(stringValues.map(int.parse).toList());
      return uint8List;
    } else {
      return null;
    }
  }

  static Uint8List? reducirUint8List(
      {required Uint8List imgBytes, int? relacion, int? calidad}) {
    try {
      final img.Image image = img.decodeImage(imgBytes)!;

      final img.Image resizedImage = img.copyResize(image,
          width: relacion == null
              ? image.width
              : (image.width * (relacion / 100)).toInt(),
          height: relacion == null
              ? image.height
              : (image.height * (relacion / 100)).toInt());

      // Codificar la imagen redimensionada a un nuevo array de bytes
      final Uint8List newImgBytes =
          img.encodeJpg(resizedImage, quality: calidad ?? 100);

      // Guardar o utilizar los nuevos bytes de la imagen
      return newImgBytes;
    } catch (e) {
      log('reducirUint8List: $e');
      return null;
    }
  }

  static Future<Uint8List?> descargaImagen(String urlImangen) async {
    final uri = Uri.parse("${Link.apiImagen}$urlImangen");
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final dataReduce = Parser.reducirUint8List(
          imgBytes: response.bodyBytes, relacion: 50, calidad: 50);
      log('${response.bodyBytes.length} - ${dataReduce == null ? 'error' : dataReduce.length}');
      return dataReduce;
    } else {
      log('nada');
      return null;
    }
  }
}
