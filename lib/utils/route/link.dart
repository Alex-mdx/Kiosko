import '../shared_preferences.dart';

class Link {
  static bool defecto = false;
  static final apiSoferp = defecto
      ? Preferencias.servidorLicencia
      : 'https://ceiba.soferp.com'; //https://test2.soferp-10.com
  static String apiLogin = "$apiSoferp/app/login";
  static String apiDireccion = "$apiSoferp/app/direcciones";
  static String apiEmpresa =
      "$apiSoferp/app/empresas/ver_empresas?database_id=";
  static String apiSucursal = "$apiSoferp/app/sucursales?database_id=";
  static String apiUnidad = "$apiSoferp/app/unidades?database_id=";
  static String apiFormasPago = "$apiSoferp/app/formas_pago?database_id=";
  static String apiCategorias = "$apiSoferp/app/categorias?database_id=";
  static String apiImagen = "$apiSoferp/img?file=";
  static String apiUrlProducto =
      "$apiSoferp/app/productos/impuestos?database_id=";
  static String apiUrlPrecios = "$apiSoferp/app/listas_precio";
  static String apiGrupoFamilia = "$apiSoferp/app/grupos_familia?database_id=";

  static String apiCorte = "$apiSoferp/app/ventas/sincronizar";
  static String apiPin = "$apiSoferp/app/autorizaciones/pin";
  static String apiVentaEliminar = "$apiSoferp/app/ventas";
  static String apiUrlContacto = '$apiSoferp/app/contactos?database_id=';
  static String apiFamilia = "$apiSoferp/app/familias_producto?database_id=";
}

class Servidor {
  static var bodyHeader = {'Content-Type': 'application/json; charset=UTF-8'};
}
