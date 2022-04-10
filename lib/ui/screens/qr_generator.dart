import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart' as geo;

import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_generator/main.dart';
import 'package:qr_generator/model/lastlogin_model.dart';
import 'package:qr_generator/ui/widgets/button.dart';
import 'package:qr_generator/ui/widgets/loader_widget.dart';

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
  String? _currentAddress;
  String? ipv6;
  @override
  void initState() {
    super.initState();
    getData();
    getIp();
    getUserLocation();
    generatedNumber = Random().nextInt(90000) + 9999;
  }

  getUserLocation() async {
    //call this async method from whereever you need

    LocationData? myLocation;
    String? error;
    Location location = Location();
    try {
      myLocation = await location.getLocation();

      _getAddressFromLatLng(
          myLocation.latitude ?? 0, myLocation.longitude ?? 0);
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
      }
      debugPrint(error);
    }
  }

  _getAddressFromLatLng(double lat, lng) async {
    try {
      List<geo.Placemark> p = await geo.placemarkFromCoordinates(lat, lng);

      geo.Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.locality},${place.administrativeArea},${place.country}";
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void getIp() async {
    ipv6 = await Ipify.ipv4();
  }

  Future<void> getData() async {
    var data = await FirebaseFirestore.instance
        .collection("login_details")
        .where("phonenumber", isEqualTo: widget.qrArguments.phoneNumber)
        .get();
    for (var element in data.docs) {
      lastloginList.add(LastloginModel.fromJson(element.data()));
    }
  }

  @override
  Widget build(BuildContext context) {
    getQrimage();
    return AppScaffold(
        heading: "PLUGIN",
        child: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.1,
              bottom: MediaQuery.of(context).size.height * 0.05),
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
                              data: "1234567890",
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
                    InkWell(
                      onTap: () {
                        MyApp.arguments = lastloginList;
                        MyApp.navigatorKey.currentState
                            ?.pushNamed("/lastlogin");
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: const TextWidget(
                          "Last login at Today, 11pm",
                          textAlign: TextAlign.end,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AuthButton(
                        onTap: () async {
                          if (disableSavebutton == false) {
                            LoaderWidget().showLoader(context,
                                showLoader: true, text: "Saving..");
                            TaskSnapshot uploadTask = await FirebaseStorage
                                .instance
                                .ref("images/qrimage")
                                .putFile(qrimage!);
                            String? url = await uploadTask.ref.getDownloadURL();
                            print("download url : $url");
                            await FirebaseFirestore.instance
                                .collection("login_details")
                                .add({
                              "phonenumber": widget.qrArguments.phoneNumber,
                              "lastlogin": widget.qrArguments.lastLogin,
                              "userip": ipv6,
                              "location": _currentAddress,
                              "qrnumber": generatedNumber.toString(),
                              "qrimage": url
                            }).then((value) => {
                                      setState(() {
                                        disableSavebutton = true;
                                      }),
                                      getData(),
                                      LoaderWidget().showLoader(context,
                                          showLoader: false)
                                    });
                          } else {
                            Fluttertoast.showToast(msg: "Already saved");
                          }
                        },
                        text: "SAVE"),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  void getQrimage() {
    screenshotController
        .capture(delay: const Duration(milliseconds: 10))
        .then((capturedImage) async {
      qrimage = File.fromRawPath(capturedImage!);
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await File('${directory.path}/qrimage.png').create();
      await imagePath.writeAsBytes(capturedImage);

      qrimage = File(imagePath.path);
    }).catchError((onError) {
      debugPrint(onError);
    });
  }
}
