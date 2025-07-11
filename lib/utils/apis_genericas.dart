import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'internet_except.dart';

class ApisGenericas {
  static Future<void> paginado(
      {required int lasIndex,
      required Uri url,
      required Function(dynamic) fun}) async {
    for (var i = 2; i <= lasIndex; i++) {
      final ulr = Uri.parse("$url&page=$i");
      debugPrint("$ulr");
      var response = await http.get(ulr);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        fun(data["data"]);
      } else {
        ExcepcionInternet.errorHttp(
            status: response.statusCode, response: response.body);
        log("${response.statusCode} - ${response.body}");
      }
    }
  }
}
