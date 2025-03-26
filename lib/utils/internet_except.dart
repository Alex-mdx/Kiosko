import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:oktoast/oktoast.dart';

class ExcepcionInternet {
  static void errorHttp({required int status, required String response}) {
    switch (status) {
      case 300:
        showToast(
            '$status Multiple eleccion\nEsta solicitud tiene más de una posible respuesta. User-Agent o el usuario debe escoger uno de ellos. No hay forma estandarizada de seleccionar una de las respuestas.');
        break;
      case 301:
        showToast(
            '$status Permanenmente movido\nEste código de respuesta significa que la URI del recurso solicitado ha sido cambiado. Probablemente una nueva URI sea devuelta en la respuesta.');
        break;
      case 302:
        showToast(
            '$status Encontrado\nla URI solicitada ha sido cambiado temporalmente');
        break;
      case 303:
        showToast(
            '$status Ver otros\nEl servidor envía esta respuesta para dirigir al cliente a un nuevo recurso solicitado a otra dirección usando una petición GET');
        break;
      case 304:
        showToast('$status No modificado\nLa respuesta no ha sido modificada');
        break;
      case 305:
        showToast(
            '$status Uso de proxy obsoleto\nLa respuesta solicitada debe ser accedida desde un proxy');
        break;
      case 306:
        showToast(
            '$status Sin uso\nEste código de respuesta ya no es usado más. Actualmente se encuentra reservado');
        break;
      case 307:
        showToast(
            '$status Redirección temporal\nEl recurso solicitado se encuentra en otra URI con el mismo método que se usó la petición anterior');
        break;
      case 308:
        showToast(
            '$status Redirección permanente\nEl recurso ahora se encuentra permanentemente en otra URI, especificada por la respuesta de encabezado HTTP Location');
        break;
      case 400:
        showToast(
            '${jsonDecode(response)["error"] ?? response}\n$status La solicitud no es correcta');
        break;
      case 401:
        showToast(
            '$status Sin autorizacion\n${jsonDecode(response)["error"] ?? response}');
        break;
      case 402:
        showToast('$status Pago requerido\n$response');
        break;
      case 403:
        showToast('$response\n$status Prohibido');
        break;
      case 404:
        showToast(
            '$status No encontrado\n${jsonDecode(response)["error"] ?? response}');
        break;
      case 405:
        showToast('$response\n$status Metodo no permitido');
        break;
      case 406:
        showToast('$response\n$status No aceptable');
        break;
      case 407:
        showToast('$response\n$status Autentificacion de proxy requerida');
        break;
      case 408:
        showToast('$response\n$status Solicitud fuera de tiempo');
        break;
      case 409:
        showToast('$response\n$status Conflicto');
        break;
      case 410:
        showToast(
            '$status Desaparecido\nEl contenido solicitado ha sido borrado del servidor\n$response');
        break;
      case 411:
        showToast(
            '$status Tamaño requerido\nEl campo de encabezado Content-Length no esta definido y el servidor lo requiere\n$response');
        break;
      case 412:
        showToast(
            '$status Condición previa falló\nEl cliente ha indicado pre-condiciones en sus encabezados la cual el servidor no cumple\n$response');
        break;
      case 413:
        showToast(
            '$status Carga útil demasiado grande\nLa entidad de petición es más larga que los límites definidos por el servidor\n$response');
        break;
      case 414:
        showToast(
            '$status URL demasiado larga\nLa URI solicitada por el cliente es más larga de lo que el servidor está dispuesto a interpretar\n$response');
        break;
      case 415:
        showToast(
            '$status Tipo de Multimedia no soportada\nEl formato multimedia de los datos solicitados no está soportado por el servidor\n$response');
        break;
      case 416:
        showToast(
            '$status Rango solicitado no satisfecho\nEl rango especificado por el campo de encabezado Range en la solicitud no cumple\n$response');
        break;
      case 417:
        showToast(
            '$status Expectativa fallida\nLa expectativa indicada por el campo de encabezado Expect solicitada no puede ser cumplida por el servidor\n$response');
        break;
      case 418:
        showToast('$response\n$status Soy una tetera\n(\n)\nc[]');
        break;
      case 421:
        showToast('$response\n$status Solicitud mal dirigida');
        break;
      case 422:
        showToast('$response\n$status Entidad no procesable');
        break;
      case 423:
        showToast('$response\n$status Bloqueado');
        break;
      case 424:
        showToast('$response\n$status Dependencia fallida');
        break;
      case 426:
        showToast('$response\n$status Actualizacion requerida');
        break;
      case 428:
        showToast('$response\n$status Condición previa requerida');
        break;
      case 429:
        showToast('$response\n$status Demasiadas solicitudes');
        break;
      case 431:
        showToast(
            '$response\n$status Campos del encabezado de solicitud son demasiado grandes');
        break;
      case 451:
        showToast('$response\n$status Invalido por razones legales');
        break;
      case 500:
        showToast(
            '$status Error Interno del Servidor\nEl servidor ha encontrado una situación que no sabe cómo manejarla');
        break;
      case 501:
        showToast(
            '$status No implementado\nEl método solicitado no está soportado por el servidor y no puede ser manejado');
        break;
      case 502:
        showToast(
            '$status Mal Gateway\nEl servidor, mientras trabaja como una puerta de enlace para obtener una respuesta necesaria para manejar la petición, obtuvo una respuesta inválida');
        break;
      case 503:
        showToast(
            '$status Servicio invalido\nEl servidor no está listo para manejar la petición');
        break;
      case 504:
        showToast(
            '$status Gateway fuera de tiempo\nEl servidor está actuando como una puerta de enlace y no puede obtener una respuesta a tiempo');
        break;
      case 505:
        showToast(
            '$status Version de http no soportada\nLa versión de HTTP usada en la petición no está soportada por el servidor');
        break;
      case 506:
        showToast(
            '$status Variantes agendadas\nEl servidor tiene un error de configuración interna');
        break;
      case 507:
        showToast(
            '$status Espacio insuficiente\nEl servidor tiene un error de configuración interna');
        break;
      case 508:
        showToast(
            '$status Loop detectado\nEl servidor detectó un ciclo infinito mientras procesaba la solicitud');
        break;
      case 510:
        showToast(
            '$status No extendido\nExtensiones adicionales para la solicitud son requeridas para que el servidor las cumpla');
        break;
      case 511:
        showToast(
            '$status Autorizacion de red requerida\nEl cliente necesita autenticar para obtener acceso a la red');
        break;

      default:
        showToast('Desconocido\n¿como le hiciste?ඞ');
        break;
    }
  }

  static void errorRed({required Object excepcion}) {
    if (excepcion is SocketException) {
      showToast('Falta de conexión a Internet o servidor no disponible');
    } else if (excepcion is FormatException) {
      showToast('Formato de envio de datos (JSON) no valido');
    } else if (excepcion is TimeoutException) {
      showToast('Error por tiempo de espera llego al limite');
    } else if (excepcion is ClientException) {
      showToast('Error de conexion a la red');
    } else {
      showToast('Error desconocido revise LOG\n$excepcion');
    }
  }
}
