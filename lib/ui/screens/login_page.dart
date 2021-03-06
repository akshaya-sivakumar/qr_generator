import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:qr_generator/ui/screens/qr_generator.dart';
import 'package:qr_generator/ui/widgets/button.dart';
import 'package:qr_generator/ui/widgets/network_check.dart';

import 'package:qr_generator/ui/widgets/scaffold.dart';
import 'package:qr_generator/ui/widgets/text_field.dart';
import 'package:qr_generator/ui/widgets/text_widget.dart';
import 'package:qr_generator/ui/widgets/toast_widget.dart';

import '../widgets/loader_widget.dart';


class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _phonenumberController = TextEditingController();
  final _otpController = TextEditingController();
  bool locationAccess = true;
  String get phonenumber => _phonenumberController.text.trim();
  String get otp => _otpController.text.trim();
  String? verifiedId;
  Location location = Location();
  @override
  void initState() {
    super.initState();
    turnonLocation();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      heading: "LOGIN",
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 24,
          ),
          CustomFormField(
            headingText: "Phone Number",
            //hintText: "phonenumber",
            obsecureText: false,
            suffixIcon: AuthButton(
                width: 74,
                height: 18,
                fontsize: 12,
                color: Colors.transparent,
                onTap: () async {
                  if (await ConnectivityCheck().checkConnectivity()) {
                    await FirebaseAuth.instance
                        .verifyPhoneNumber(
                      phoneNumber: "+91" + _phonenumberController.text,
                      timeout: const Duration(seconds: 5),
                      verificationCompleted:
                          (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException e) {
                        Fluttertoast.showToast(
                            msg: e.code.toString(),
                            backgroundColor: Colors.red);
                      },
                      codeSent: (String verificationId, int? resendToken) {
                        verifiedId = verificationId;
                        Fluttertoast.showToast(
                            msg: "Otp Sent",
                            backgroundColor:
                                const Color.fromARGB(255, 65, 50, 131));
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    )
                        .then((value) {
                      Fluttertoast.showToast(
                          msg: "Sending Otp...",
                          backgroundColor:
                              const Color.fromARGB(255, 65, 50, 131));
                    }).catchError((onError) {
                      Fluttertoast.showToast(
                          msg: onError.toString(), backgroundColor: Colors.red);
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: "No Internet Connection",
                        backgroundColor: Colors.red);
                  }
                },
                text: " Send OTP"),
            controller: _phonenumberController,
            maxLines: 1,
            textInputAction: TextInputAction.done,
            textInputType: TextInputType.phone,
            prefixIcon: Container(
              width: 10,
              padding: const EdgeInsets.only(left: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  TextWidget(
                    "+91",
                    color: Colors.white,
                    mainAxisAlignment: MainAxisAlignment.start,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.029,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.009,
          ),
          CustomFormField(
            headingText: "OTP",
            maxLines: 1,
            textInputAction: TextInputAction.done,
            textInputType: TextInputType.number,
            obsecureText: false,
            suffixIcon: const SizedBox(
              width: 3,
            ),
            controller: _otpController,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
          ),
          AuthButton(
            onTap: () async {
              if (await ConnectivityCheck().checkConnectivity()) {
                if (await Permission
                    .locationWhenInUse.serviceStatus.isEnabled) {
                  await updateData(context);
                } else {
                  turnonLocation();
                }
              } else {
                Fluttertoast.showToast(
                    msg: "No Internet Connection", backgroundColor: Colors.red);
              }
            },
            text: 'LOGIN',
            fontweight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  turnonLocation() async {
    await location.requestService();
    await Permission.locationWhenInUse.request();
    if (await Permission.locationWhenInUse.serviceStatus.isDisabled) {
      FlutterToast.showToast("Turn on location to login", color: Colors.red);
    }
  }

  Future<void> updateData(BuildContext context) async {
    if (_otpController.text != "" && _otpController.text.length == 6) {
      LoaderWidget()
          .showLoader(context, showLoader: true, text: "Please wait..");
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: verifiedId ?? "", smsCode: _otpController.text))
          .then((value) => {
                LoaderWidget().showLoader(context, showLoader: false),
                Navigator.of(context).pushNamed("/qrgenerator",
                    arguments: QrArguments(DateTime.now().toString(),
                        "+91" + _phonenumberController.text))
              })
          .onError((error, stackTrace) => {
                LoaderWidget().showLoader(context, showLoader: false),
                Fluttertoast.showToast(
                    msg:
                        "The sms code has expired/OTP is wrong. Please re-send the verification code to try again",
                    backgroundColor: Colors.red)
              });
    } else {
      Fluttertoast.showToast(msg: "Invalid otp", backgroundColor: Colors.red);
    }
  }
}
