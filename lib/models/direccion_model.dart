class DireccionModel {
  int id;
  String? nombre;
  String? vialidad;
  String? numeroExterior;
  String? numeroInterior;
  String? cruzamiento1;
  String? cruzamiento2;
  String? codigoPostal;
  String? colonia;
  String? localidad;
  String? municipio;
  String? entidad;
  String? pais;
  String? latitud;
  String? longitud;
  String? coloniaId;
  String? localidadId;
  String? municipioId;
  String? entidadId;
  String? paisId;

  DireccionModel(
    this.id,
    this.nombre,
    this.vialidad,
    this.numeroExterior,
    this.numeroInterior,
    this.cruzamiento1,
    this.cruzamiento2,
    this.codigoPostal,
    this.colonia,
    this.localidad,
    this.municipio,
    this.entidad,
    this.pais,
    this.latitud,
    this.longitud,
    this.coloniaId,
    this.localidadId,
    this.municipioId,
    this.entidadId,
    this.paisId,
  );

  DireccionModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson["id"],
        nombre = parsedJson["nombre"],
        vialidad = parsedJson["vialidad"],
        numeroExterior = parsedJson["numero_exterior"],
        numeroInterior = parsedJson["numero_interior"],
        cruzamiento1 = parsedJson["cruzamiento_1"],
        cruzamiento2 = parsedJson["cruzamiento_2"],
        codigoPostal = parsedJson["codigo_postal"],
        colonia = parsedJson["colonia"],
        localidad = parsedJson["localidad"],
        municipio = parsedJson["municipio"],
        entidad = parsedJson["entidad"],
        pais = parsedJson["pais"],
        latitud = parsedJson["latitud"],
        longitud = parsedJson["longitud"],
        coloniaId = parsedJson["colonia_id"].toString(),
        localidadId = parsedJson["localidad_id"].toString(),
        municipioId = parsedJson["municipio_id"].toString(),
        entidadId = parsedJson["entidad_id"].toString(),
        paisId = parsedJson["pais_id"].toString();

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "vialidad": vialidad,
        "numero_exterior": numeroExterior,
        "numero_interior": numeroInterior,
        "cruzamiento_1": cruzamiento1,
        "cruzamiento_2": cruzamiento2,
        "codigo_postal": codigoPostal,
        "colonia": colonia,
        "localidad": localidad,
        "municipio": municipio,
        "entidad": entidad,
        "pais": pais,
        "latitud": latitud,
        "longitud": longitud,
        "colonia_id": coloniaId,
        "localidad_id": localidadId,
        "municipio_id": municipioId,
        "entidad_id": entidadId,
        "pais_id": paisId,
      };
}
