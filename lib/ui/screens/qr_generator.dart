import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_ipify/dart_ipify.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:intl/intl.dart';

import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:qr_generator/model/lastlogin_model.dart';
import 'package:qr_generator/ui/widgets/button.dart';
import 'package:qr_generator/ui/widgets/loader_widget.dart';
import 'package:qr_generator/ui/widgets/network_check.dart';

import 'package:qr_generator/ui/widgets/scaffold.dart';

import 'package:qr_generator/ui/widgets/text_widget.dart';

import 'package:screenshot/screenshot.dart';

class QrArguments {
  final String lastLogin, phoneNumber;
  QrArguments(this.lastLogin, this.phoneNumber);
}

class QrGenerator extends StatefulWidget {
  const QrGenerator(this.qrArguments, {Key? key}) : super(key: key);
  final QrArguments qrArguments;
  @override
  State<QrGenerator> createState() => _QrGeneratorState();
}

class _QrGeneratorState extends State<QrGenerator> {
  int generatedNumber = 0;
  List<LastloginModel> lastloginList = [];
  ScreenshotController screenshotController = ScreenshotController();
  File? qrimage;
  bool disableSavebutton = false;
  String? _currentAddress, userId;
  String? ipv6;
  @override
  void initState() {
    super.initState();

    getIp();
    getUserLocation();
    generatedNumber = Random().nextInt(90000) + 9999;
  }

  getUserLocation() async {
    LocationData? myLocation;

    Location location = Location();
    try {
      myLocation = await location.getLocation();

      _getAddressFromLatLng(
          myLocation.latitude ?? 0, myLocation.longitude ?? 0);
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {}
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {}
    }
  }

  _getAddressFromLatLng(double lat, lng) async {
    try {
      List<geo.Placemark> p = await geo.placemarkFromCoordinates(lat, lng);

      geo.Placemark place = p[0];

      setState(() {
        _currentAddress = "${place.locality},${place.administrativeArea}";
      });
      await saveData();
    } catch (e) {
      //debugPrint(e.toString());
    }
  }

  void getIp() async {
    await Future.delayed(const Duration(milliseconds: 50));

    LoaderWidget().showLoader(context, showLoader: true, text: "Saving..");
    ipv6 = await Ipify.ipv4();
  }

  Future<void> getData({bool loading = false}) async {
    lastloginList = [];
    if (loading) {
      LoaderWidget().showLoader(context, showLoader: true, text: "Saving..");
    }
    var data = await FirebaseFirestore.instance
        .collection("login_details")
        .where("phonenumber", isEqualTo: widget.qrArguments.phoneNumber)
        .get();
    lastloginList = [];
    for (var element in data.docs) {
      lastloginList.add(LastloginModel.fromJson(element.data()));
    }

    lastloginList.sort((a, b) =>
        DateTime.parse(b.lastlogin).compareTo(DateTime.parse(a.lastlogin)));
    LoaderWidget().showLoader(context, showLoader: false);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        logout: true,
        heading: "PLUGIN",
        child: Container(
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.033),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.1,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.2,
                        left: 47,
                        child: Image.asset(
                          "assets/rectanglebg.jpg",
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: MediaQuery.of(context).size.width * 0.75,
                        ),
                      ),
                      Positioned(
                        bottom: MediaQuery.of(context).size.height * 0.33,
                        child: InkWell(
                          child: Screenshot(
                            controller: screenshotController,
                            child: QrImage(
                              backgroundColor: Colors.white,
                              data: generatedNumber.toString(),
                              version: QrVersions.auto,
                              size: MediaQuery.of(context).size.width * 0.45,
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.31,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const TextWidget(
                              "Generated Number",
                              color: Colors.white,
                              fontSize: 17,
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.035,
                            ),
                            TextWidget(
                              generatedNumber.toString(),
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    AuthButton(
                        onTap: () async {
                          if (await ConnectivityCheck().checkConnectivity()) {
                            Navigator.of(context).pushNamed("/lastlogin",
                                arguments: lastloginList);
                          } else {
                            Fluttertoast.showToast(
                                msg: "No Internet Connection",
                                backgroundColor: Colors.red);
                          }
                        },
                        text: "Last login at Today, " +
                            DateFormat("hh:mm aa").format(DateTime.now()),
                        bordercolor: Colors.white,
                        color: Colors.transparent),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.0002,
                    ),
                    AuthButton(
                      onTap: () async {
                        if (await ConnectivityCheck().checkConnectivity()) {
                          await getQrimage();
                          if (disableSavebutton == false) {
                            LoaderWidget().showLoader(context,
                                showLoader: true, text: "Saving...");
                            TaskSnapshot uploadTask = await FirebaseStorage
                                .instance
                                .ref("images/qrimage")
                                .putFile(qrimage!);
                            String? url = await uploadTask.ref.getDownloadURL();

                            await FirebaseFirestore.instance
                                .collection("login_details")
                                .doc(userId)
                                .update({
                                  "qrnumber": generatedNumber.toString(),
                                  "qrimage": url
                                })
                                .then((value) => {
                                      setState(() {
                                        disableSavebutton = true;
                                      }),
                                      getData(loading: true),
                                      LoaderWidget().showLoader(context,
                                          showLoader: false),
                                      Fluttertoast.showToast(
                                          msg: "Saved",
                                          backgroundColor: const Color.fromARGB(
                                              255, 65, 50, 131))
                                    })
                                .onError((error, stackTrace) => {
                                      LoaderWidget().showLoader(context,
                                          showLoader: false),
                                      Fluttertoast.showToast(
                                          msg: error.toString(),
                                          backgroundColor: Colors.red)
                                    });
                          } else {
                            Fluttertoast.showToast(
                                msg: "Already saved",
                                backgroundColor:
                                    const Color.fromARGB(255, 65, 50, 131));
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: "No Internet Connection",
                              backgroundColor: Colors.red);
                        }
                      },
                      text: "SAVE",
                      fontweight: FontWeight.bold,
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  Future<void> saveData() async {
    await FirebaseFirestore.instance
        .collection("login_details")
        .add({
          "phonenumber": widget.qrArguments.phoneNumber,
          "lastlogin": widget.qrArguments.lastLogin,
          "userip": ipv6,
          "location": _currentAddress,
        })
        .then((value) => {
              userId = value.id,
              getData(),
              Fluttertoast.showToast(
                  msg: "Login details Saved",
                  backgroundColor: const Color.fromARGB(255, 65, 50, 131))
            })
        .onError((error, stackTrace) => {
              Fluttertoast.showToast(
                  msg: error.toString(), backgroundColor: Colors.red)
            });
  }

  getQrimage() async {
    var capturedImage = await screenshotController.capture(
        delay: const Duration(milliseconds: 10));

    qrimage = File.fromRawPath(capturedImage!);
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = await File('${directory.path}/qrimage.png').create();
    await imagePath.writeAsBytes(capturedImage);

    qrimage = File(imagePath.path);
  }
}
