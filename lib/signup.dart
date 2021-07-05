import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:smart_select/smart_select.dart';

import 'constants.dart';
import 'controller/pageOne.dart';

class SignUp extends StatefulWidget {
  final Function onLogInSelected;
  final Function onPageOneSelected;
  SignUp({required this.onLogInSelected, required this.onPageOneSelected});

  @override
  _SignUpState createState() => _SignUpState();
}

final controller = Get.put(PageOneController());

class _SignUpState extends State<SignUp> {
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
            height: size.height *
                (size.height > 770
                    ? 0.8
                    : size.height > 670
                        ? 0.8
                        : 0.8),
            width: phone
                ? size.width
                : tablet
                    ? size.width * 0.9
                    : size.width * 0.5,
            color: Colors.white,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "PENDAFTARAN VAKSIN",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: size.width / 2,
                        child: Divider(
                          color: kPrimaryColor,
                          thickness: 2,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Form(
                        key: controller.key2,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: controller.nama,
                              keyboardType: TextInputType.name,
                              validator: (value) => value!.isEmpty
                                  ? 'Nama tidak boleh kosong'
                                  : null,
                              decoration: InputDecoration(
                                labelText: 'Nama',
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
                                    currentTime: DateTime.now(),
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
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: controller.telp,
                              keyboardType: TextInputType.phone,
                              maxLength: 15,
                              validator: (value) => value!.isNumericOnly != true
                                  ? 'No. Handphone hanya boleh angka saja'
                                  : value.isEmpty
                                      ? 'No. Handphone tidak boleh kosong'
                                      : null,
                              decoration: InputDecoration(
                                labelText: 'No. Handphone',
                                hintText: '081XXXXXXXXX',
                                suffixIcon: Icon(LineAwesomeIcons.phone),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: controller.pekerjaan,
                              validator: (value) => value!.isEmpty
                                  ? 'Pekerjaan tidak boleh kosong'
                                  : null,
                              decoration: InputDecoration(
                                labelText: 'Pekerjaan',
                                suffixIcon: Icon(Icons.home),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: controller.tglGiat,
                              validator: (value) => value!.isEmpty
                                  ? 'Tanggal Kegiatan tidak boleh kosong'
                                  : null,
                              readOnly: true,
                              // onTap: () {
                              //   DatePicker.showDatePicker(context,
                              //       showTitleActions: true,
                              //       minTime: DateTime(1900, 3, 5),
                              //       maxTime: DateTime.now().add(Duration(days: 5)),
                              //       theme: DatePickerTheme(), onConfirm: (date) {
                              //     controller.tglGiat.text =
                              //         DateFormat('dd-MM-yyyy').format(date);
                              //   },
                              //       currentTime: DateTime.now(),
                              //       locale: LocaleType.id);
                              // },
                              decoration: InputDecoration(
                                labelText: 'Tanggal Vaksin',
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
                        height: 10,
                      ),
                      SmartSelect<String>.single(
                        title: 'Jam Vaksinasi',
                        value: controller.valueJamGiat.value,
                        choiceItems: [controller.list.value],
                        modalType: S2ModalType.popupDialog,
                        onChange: (state) => setState(
                            () => controller.valueJamGiat.value = state.value),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              widget.onLogInSelected();
                            },
                            child: Container(
                              height: 50,
                              width: size.width / 3.5,
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
                                  'Kembali',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              if (controller.key2.currentState!.validate()) {
                                var kuota = await controller.kuota();
                                if (kuota == 'tersedia') {
                                  var data = await controller.kirim();
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.NO_HEADER,
                                    headerAnimationLoop: false,
                                    animType: AnimType.SCALE,
                                    title: data['state'] == true
                                        ? 'BERHASIL DAFTAR'
                                        : 'GAGAL DAFTAR',
                                    desc: data['data'],
                                    autoHide: Duration(seconds: 3),
                                  )..show();
                                  Future.delayed(Duration(seconds: 5), () {
                                    controller.reset();
                                    widget.onLogInSelected();
                                  });
                                } else {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.NO_HEADER,
                                    headerAnimationLoop: false,
                                    animType: AnimType.SCALE,
                                    title: 'GAGAL DAFTAR',
                                    desc: 'Kuota sudah penuh untuk besok',
                                    autoHide: Duration(seconds: 3),
                                  )..show();
                                  Future.delayed(Duration(seconds: 5), () {
                                    controller.reset();
                                    widget.onLogInSelected();
                                  });
                                }
                              }
                            },
                            child: Container(
                              height: 50,
                              width: size.width / 3.5,
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
                                  'KIRIM',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
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
