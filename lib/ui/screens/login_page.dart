import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:qr_generator/main.dart';
import 'package:qr_generator/ui/screens/qr_generator.dart';
import 'package:qr_generator/ui/widgets/button.dart';

import 'package:qr_generator/ui/widgets/scaffold.dart';
import 'package:qr_generator/ui/widgets/text_field.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _phonenumberController = TextEditingController();
  final _otpController = TextEditingController();

  String get phonenumber => _phonenumberController.text.trim();
  String get otp => _otpController.text.trim();
  String? verifiedId;
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      heading: "LOGIN",
      child: Column(
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
            suffixIcon: const SizedBox(),
            controller: _phonenumberController,
            maxLines: 1,
            textInputAction: TextInputAction.done,
            textInputType: TextInputType.phone,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.029,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AuthButton(
                  width: 100,
                  height: 40,
                  onTap: () async {
                    await FirebaseAuth.instance
                        .verifyPhoneNumber(
                      phoneNumber: _phonenumberController.text,
                      timeout: const Duration(seconds: 5),
                      verificationCompleted:
                          (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException e) {},
                      codeSent: (String verificationId, int? resendToken) {
                        verifiedId = verificationId;
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    )
                        .then((value) {
                      print("then");
                    }).catchError((onError) {
                      debugPrint(onError);
                    });
                  },
                  text: "Send OTP"),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.009,
          ),
          CustomFormField(
            headingText: "OTP",
            maxLines: 1,
            textInputAction: TextInputAction.done,
            textInputType: TextInputType.text,
            obsecureText: true,
            suffixIcon: IconButton(
                icon: const Icon(Icons.visibility), onPressed: () {}),
            controller: _otpController,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
          ),
          AuthButton(
            onTap: () async {
              /*  if (_otpController.text != "" &&
                  _otpController.text.length == 6) {
                await FirebaseAuth.instance
                    .signInWithCredential(PhoneAuthProvider.credential(
                        verificationId:
                            "AJOnW4TRptcsOt71ImtVZQwkgayaojlFzY8TzcAdMIXzVd6WCaMopvz1JqLdyUl0prLNIupzcPVKr94m7qU9e4RLQsZmByrSmHeN6kcpLnAsTO2q2A95k6esgil7ZaMfMf_aIESh7eVs_W7mj37WTW3y-vhOdY1qQLJWeDRguPUzRPyF9EkNTHHuo9o3NjlOZ_cL9gA6EQOHkdB17yBvw9BJ8AHUezqBSKWAe1-6xBKZWWKEcWVryio",
                        smsCode: _otpController.text))
                    .then((value) => {
                          MyApp.arguments = QrArguments(
                              DateTime.now().toString(),
                              _phonenumberController.text),
                          MyApp.navigatorKey.currentState?.pushNamed("/second")
                        });
              } else {
                Fluttertoast.showToast(
                    msg: "Invalid otp", backgroundColor: Colors.red);
              } */
              MyApp.arguments = QrArguments(
                  DateTime.now().toString(), _phonenumberController.text);
              MyApp.navigatorKey.currentState?.pushNamed("/second");
            },
            text: 'LOGIN',
          ),
        ],
      ),
    );
  }
}
