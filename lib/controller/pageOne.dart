import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rsb_vaksin/api/koneksi.dart';
import 'package:smart_select/smart_select.dart';
import 'package:http/http.dart' as http;

class PageOneController extends GetxController {
  late TextEditingController nik;
  late TextEditingController nama;
  late TextEditingController telp;
  late TextEditingController tglLahir;
  late TextEditingController pekerjaan;
  late TextEditingController tglGiat;
  late TextEditingController jamGiat;
  late GlobalKey<FormState> key;
  late GlobalKey<FormState> key2;
  var data1 = Map<dynamic, String>().obs;
  var date = DateTime.now();
  var isLoading = false.obs;
  var tglLahirValue = DateTime.now().obs;
  var tglGiatValue = DateTime.now().add(Duration(days: 1)).obs;
  var cekKuota = ''.obs;

  var valueJamGiat = '07.00 - 12.00'.obs;
  var list = S2Choice<String>(value: '', title: '').obs;
  // List<S2Choice<String>> listJamGiat = [
  //   S2Choice<String>(value: '07.00 - 12.00', title: '07.00 - 12.00'),
  // ];

  @override
  void onInit() async {
    nik = new TextEditingController();
    nama = new TextEditingController();
    telp = new TextEditingController();
    tglLahir = new TextEditingController();
    pekerjaan = new TextEditingController();
    tglGiat = new TextEditingController();
    tglGiat.text =
        DateFormat('dd-MM-yyyy').format(DateTime.now().add(Duration(days: 1)));
    jamGiat = new TextEditingController();
    key = new GlobalKey<FormState>();
    key2 = new GlobalKey<FormState>();
    // cekKuota.value = await kuota();
    super.onInit();
  }

  String getDay() {
    var day = DateFormat('EEEE').format(DateTime.now().add(Duration(days: 1)));
    return day;
  }

  reset() {
    nik.text = '';
    nama.text = '';
    telp.text = '';
    tglLahir.text = '';
    pekerjaan.text = '';
    tglGiat.text = '';
    jamGiat.text = '';
  }

  Future<Map<String, dynamic>> kirim() async {
    Future.delayed(
      Duration.zero,
      () => Get.dialog(Center(child: CircularProgressIndicator()),
          barrierDismissible: false),
    );
    try {
      //var tmp = DateTime.parse(tglGiat.text);
      var param = {
        'nik': nik.text,
        'nama': nama.text,
        'tgl_lahir': DateFormat('yyyy-MM-dd').format(tglLahirValue.value),
        'telp': telp.text,
        'pekerjaan': pekerjaan.text,
        'tgl_vaksin': DateFormat('yyyy-MM-dd').format(tglGiatValue.value),
        'jam_vaksin': valueJamGiat.value
      };
      var data = await Koneksi().kirim(
          'https://vaksinasi.rsbhayangkaranganjuk.com/api-rsbnganjuk/api/v1/vaksin/daftar',
          param);
      Get.back();
      return {
        'state': data.body['success'],
        'data': data.body['message'],
      };
    } on Exception catch (e) {
      print(e.toString());
      Get.back();
      return {
        'state': 'false',
        'data': 'Tidak bisa terhubung ke server',
      };
    }
  }

  Future<Map<dynamic, dynamic>> jam() async {
    Future.delayed(
      Duration.zero,
      () => Get.dialog(Center(child: CircularProgressIndicator()),
          barrierDismissible: false),
    );
    try {
      var data = await Koneksi().jam(
        'https://vaksinasi.rsbhayangkaranganjuk.com/api-rsbnganjuk/api/v1/vaksin/jam',
      );

      Get.back();
      return {
        'state': data.body['success'],
        'data': data.body['data'],
      };
    } on Exception catch (e) {
      Get.back();
      return {
        'state': 'false',
        'data': 'Tidak bisa terhubung ke server',
      };
    }
  }

  Future<String> kuota() async {
    Future.delayed(
      Duration.zero,
      () => Get.dialog(Center(child: CircularProgressIndicator()),
          barrierDismissible: false),
    );
    try {
      var data = await Koneksi().kuota(
          'https://vaksinasi.rsbhayangkaranganjuk.com/api-rsbnganjuk/api/v1/vaksin/umur',
          {
            'tgl_vaksin': DateFormat('yyyy-MM-dd')
                .format(DateTime.now().add(Duration(days: 1))),
            'tgl_lahir': DateFormat('yyyy-MM-dd').format(tglLahirValue.value),
          });
      // print(data.body);
      if (data.statusCode == 200) {
        Get.back();
        valueJamGiat.value = data.body["data"]["jam"];
        list.value = S2Choice<String>(
            value: data.body["data"]["jam"], title: data.body["data"]["jam"]);
        return 'tersedia';
      } else {
        Get.back();
        return 'penuh';
      }
    } on Exception catch (e) {
      Get.back();
      return 'Error';
    }
  }

  Future<Map<dynamic, dynamic>> cekPeserta() async {
    Future.delayed(
      Duration.zero,
      () => Get.dialog(Center(child: CircularProgressIndicator()),
          barrierDismissible: false),
    );
    try {
      var data = await Koneksi().kuota(
          'https://vaksinasi.rsbhayangkaranganjuk.com/api-rsbnganjuk/api/v1/vaksin/cek',
          {
            'tgl_lahir': DateFormat('yyyy-MM-dd').format(tglLahirValue.value),
            'nik': nik.text,
          });
      if (data.statusCode == 200) {
        Get.back();
        return {'success': data.body['success'], 'message': data.body['data']};
      } else if (data.statusCode == 404) {
        Get.back();
        return {
          'success': data.body['success'],
          'message': data.body['message']
        };
      } else {
        Get.back();
        return {
          'success': false,
          'message': 'Tidak dapat terhubung dengan server'
        };
      }
    } on Exception catch (e) {
      Get.back();
      return {
        'success': false,
        'message': 'Tidak dapat terhubung dengan server'
      };
    }
  }
}
