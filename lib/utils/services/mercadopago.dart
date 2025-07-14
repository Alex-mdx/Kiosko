import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kiosko/controllers/user_controller.dart';
import 'package:kiosko/models/MPago_intent_model.dart';
import 'package:kiosko/utils/route/link.dart';
import 'package:kiosko/utils/shared_preferences.dart';
import 'package:mercadopago_sdk/mercadopago_sdk.dart';
import 'package:oktoast/oktoast.dart';

import '../../models/MPago_payment_model.dart';
import '../../models/MPago_point_model.dart';
import '../../models/Mpago_pay_intent_model.dart';

class Mercadopago {
  static String clienteId = "4929852312805237";
  static String clienteSecret = "q8udcOSpKTXkDSG1cXs87yQQfTv2XJvf";

  static Future<List<MPagoPointModel>> getTPoint() async {
    try {
      var mp = MP(clienteId, clienteSecret);
      var result = await mp.get("/point/integration-api/devices");
      log("$result");
      if (result['status'] == 200 || result['status'] == 201) {
        var device = result['response']['devices'];
        log("$device");
        List<MPagoPointModel> devices = [];
        for (var element in device) {
          devices.add(MPagoPointModel.fromJson(element));
        }
        return devices;
      } else {
        showToast(
            "${result["response"]["code"]}\n${result["response"]["message"]}");
        return [];
      }
    } catch (e) {
      log("$e");
      return [];
    }
  }

  static Future<MPagoIntentModel?> cancelarIntencion(
      String deviceId, String idIntent) async {
    try {
      var mp = MP(clienteId, clienteSecret);
      var response = await mp.delete(
          "/point/integration-api/devices/$deviceId/payment-intents/$idIntent",
          params: {"status": "CANCELLED"});
      if (response['status'] == 200 || response['status'] == 201) {
        log("${response["response"]}");
        return MPagoIntentModel.fromJson(response["response"]);
      } else {
        showToast(
            "${response["response"]["code"]}\n${response["response"]["message"]}");
        return null;
      }
    } catch (e) {
      log("$e");
      return null;
    }
  }

  static Future<MPagoIntentModel?> sendIntencion(
      String deviceId, double amount) async {
    //try {
    var mp = MP(clienteId, clienteSecret);
    var convertir = (double.parse(amount.toStringAsFixed(2)) * 100);
    final user = await UserController.getItem();
    debugPrint("monto = $convertir");
    final response = await mp.post(
        "/point/integration-api/devices/$deviceId/payment-intents",
        data: {
          "amount": convertir,
          "additional_info": {
            "external_reference": "${Link.apiSoferp}-${user?.usuario}",
            "print_on_terminal": Preferencias.imprimirMP
          }
        });
    if (response['status'] == 200 || response['status'] == 201) {
      log("${response["response"]}");
      return MPagoIntentModel.fromJson(response["response"]);
    } else {
      showToast(
          "${response["response"]["code"]}\n${response["response"]["message"]}");
      debugPrint(
          "sendIntencion: ${response["response"]["code"]}\n${response["response"]["message"]}");
      return null;
    }
    /* } catch (e) {
      log("$e");
      return null;
    } */
  }

  static Future<MPagoPayIntentModel?> findIntencion(
      {required String id}) async {
    try {
      var mp = MP(clienteId, clienteSecret);
      final response =
          await mp.get("/point/integration-api/payment-intents/$id");
      if (response['status'] == 200 || response['status'] == 201) {
        log("${response["response"]}");
        var pagoIntento = MPagoPayIntentModel(
            id: response["response"]["id"].toString(),
            state: response["response"]["state"].toString(),
            amount: double.parse(response["response"]["amount"].toString()),
            deviceId: response["response"]["deviceId"].toString(),
            payment: Payment(
                id: response["response"]["payment"]?["id"],
                type: response["response"]["payment"]?["type"]));
        return pagoIntento;
      } else {
        showToast(
            "${response["response"]["code"]}\n${response["response"]["message"]}");
        return null;
      }
    } catch (e) {
      log("$e");
      return null;
    }
  }

  static Future<MPagoPaymentModel?> findPay({required String id}) async {
    try {
      var mp = MP(clienteId, clienteSecret);
      final response = await mp.getPayment(id);
      if (response['status'] == 200 || response['status'] == 201) {
        log("${response["response"]}");
        return MPagoPaymentModel.fromJson(response["response"]);
      } else {
        showToast(
            "${response["response"]["code"]}\n${response["response"]["message"]}");
        return null;
      }
    } catch (e) {
      log("$e");
      return null;
    }
  }

  static string({required String state}) {
    String newValor = "En espera";
    switch (state) {
      case "ON_TERMINAL":
        newValor = "En terminal";
        break;
      case "CANCELED":
        newValor = "Cancelado";
        break;
      case "FINISHED":
        newValor = "Finalizado";
        break;
      case "PROCESSING":
        newValor = "PROCESANDO";
        break;

      default:
        newValor = "En espera";
        break;
    }
    return newValor;
  }
}
