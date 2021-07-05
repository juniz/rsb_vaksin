import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'constants.dart';
import 'controller/pageOne.dart';

class LogIn extends StatefulWidget {
  final Function onSignUpSelected;

  LogIn({required this.onSignUpSelected});

  @override
  _LogInState createState() => _LogInState();
}

final controller = Get.put(PageOneController());

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool phone = context.isPhone;
    bool tablet = context.isTablet;

    return Padding(
      padding: EdgeInsets.all(phone
          ? 16
          : tablet
              ? 32
              : 64),
      child: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: phone ? size.height / 1.3 : size.height / 1.5,
            width: phone
                ? size.width
                : tablet
                    ? size.width * 0.9
                    : size.width * 0.5,
            color: Colors.white,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: phone ? 20 : 100,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Sistem Pendaftaran Vaksinasi COVID-19",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: phone ? 14 : 18,
                          color: Colors.grey[700],
                        ),
                      ),
                      Container(
                        width: phone ? size.width / 1.5 : size.width / 2,
                        child: Divider(
                          color: kPrimaryColor,
                          thickness: 2,
                        ),
                      ),
                      Text(
                        "Sistem Pendaftaran Vaksin RS Bhayangkara Nganjuk merupakan sistem yang dibuat untuk masyarakat yang mendapatkan dosis vaksinasi COVID-19, dan ingin melakukan vaksinasi di RS Bhayangkara Nganjuk. Dengan melakukan pendaftaran melalui sistem ini, akan mendapatkan kode reservasi yang akan ditunjukkan saat akan melakukan vaksinasi di hari dan jam yang sudah ditentukan. Sistem ini juga dapat digunakan untuk mengecek bukti pendaftaran dengan klik tombol berikut CEK PENDAFTARAN",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: phone ? 14 : 18,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Form(
                        key: controller.key,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: controller.nik,
                              keyboardType: TextInputType.number,
                              validator: (value) => value!.length != 16
                                  ? 'NIK Harus 16 Digit'
                                  : value.isNumericOnly != true
                                      ? 'NIK harus berupa angka'
                                      : null,
                              maxLength: 16,
                              decoration: InputDecoration(
                                labelText: 'NIK',
                                hintText: 'Masukkan NIK',
                                suffixIcon:
                                    Icon(LineAwesomeIcons.identification_card),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: controller.tglLahir,
                              keyboardType: TextInputType.number,
                              validator: (value) => value!.isEmpty
                                  ? 'Tanggal Lahir tidak boleh kosong'
                                  : null,
                              readOnly: true,
                              onTap: () {
                                DatePicker.showDatePicker(context,
                                    showTitleActions: true,
                                    minTime: DateTime(1900, 3, 5),
                                    maxTime: DateTime.now(),
                                    theme: DatePickerTheme(),
                                    onConfirm: (date) {
                                  controller.tglLahir.text =
                                      DateFormat('dd-MM-yyyy').format(date);
                                  controller.tglLahirValue.value = date;
                                },
                                    currentTime: controller.tglLahirValue.value,
                                    locale: LocaleType.id);
                              },
                              decoration: InputDecoration(
                                labelText: 'Tanggal Lahir',
                                suffixIcon: Icon(LineAwesomeIcons.calendar),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: phone ? 20 : 30,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              if (controller.key.currentState!.validate()) {
                                var data = await controller.cekPeserta();
                                if (data['success'] == true) {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.INFO,
                                    headerAnimationLoop: false,
                                    animType: AnimType.SCALE,
                                    title: 'DATA PESERTA DITEMUKAN',
                                    desc:
                                        'NIK    : ${data["message"]["nik"]}\nNama    : ${data['message']['nama']}\nTgl Lahir  : ${data['message']['tgl_lahir']}\nNo. HP : ${data['message']['telp']}\n Jadwal Vaksin : ${data['message']['jam_vaksin']}\n\n Silahkan rekam layar, tunjukkan pada Petugas',
                                    autoHide: Duration(seconds: 5),
                                  )..show();
                                } else {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.ERROR,
                                    headerAnimationLoop: false,
                                    animType: AnimType.SCALE,
                                    title: 'DATA ERROR',
                                    desc: data['message'],
                                    autoHide: Duration(seconds: 5),
                                  )..show();
                                }
                              }
                            },
                            child: Container(
                              height: phone ? 40 : 50,
                              width: phone ? size.width / 3 : size.width / 5,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: kPrimaryColor.withOpacity(0.2),
                                    spreadRadius: 4,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'CEK PENDAFTARAN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: phone ? 12 : 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //Obx(
                          // () => controller.cekKuota.value == 'tersedia'
                          //?
                          InkWell(
                            onTap: () async {
                              if (controller.key.currentState!.validate()) {
                                // if (controller.getDay() == 'Saturday' ||
                                //     controller.getDay() == 'Sunday') {
                                //   AwesomeDialog(
                                //     context: context,
                                //     dialogType: DialogType.NO_HEADER,
                                //     headerAnimationLoop: false,
                                //     animType: AnimType.SCALE,
                                //     title:
                                //         'JADWAL VAKSIN BESOK TIDAK DITEMUKAN',
                                //     desc:
                                //         'Maaf tidak ada pendaftaran pada hari Sabtu atau Minggu',
                                //     autoHide: Duration(seconds: 5),
                                //   )..show();
                                // } else {
                                var res = await controller.kuota();
                                if (res == 'tersedia') {
                                  widget.onSignUpSelected();
                                } else {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.ERROR,
                                    headerAnimationLoop: false,
                                    animType: AnimType.SCALE,
                                    title: 'KUOTA PENUH',
                                    desc:
                                        'Maaf kuota untuk hari besok sudah penuh, terimakasih atas perhatiannya',
                                    autoHide: Duration(seconds: 5),
                                  )..show();
                                }
                              }
                              //}
                            },
                            child: Container(
                              height: phone ? 40 : 50,
                              width: size.width / 5,
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: kPrimaryColor.withOpacity(0.2),
                                    spreadRadius: 4,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'DAFTAR',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: phone ? 12 : 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                          //       : Container(),
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Obx(
                        () => controller.cekKuota.value == 'penuh'
                            ? Center(
                                child: Text(
                                  'Mohon maaf pendaftaran sementara ditutup karena kuota sudah terpenuhi. Terima Kasih atas perhatiannya.',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: phone ? 15 : 24,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Container(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
