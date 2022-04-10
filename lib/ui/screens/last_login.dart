import 'dart:math';

import 'package:flutter/material.dart';

import 'package:qr_generator/model/lastlogin_model.dart';

import 'package:qr_generator/ui/widgets/scaffold.dart';

class LastLogin extends StatefulWidget {
  const LastLogin(this.lastloginlist, {Key? key}) : super(key: key);
  final List<LastloginModel> lastloginlist;
  @override
  State<LastLogin> createState() => _LastLoginState();
}

class _LastLoginState extends State<LastLogin> {
  int generatedNumber = 0;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String get email => _emailController.text.trim();
  String get password => _passwordController.text.trim();
  @override
  void initState() {
    super.initState();
    generatedNumber = Random().nextInt(90000) + 9999;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        heading: "LAST LOGIN",
        child: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.05,
              bottom: MediaQuery.of(context).size.height * 0.05),
          child: Center(
            child: ListView.builder(
                itemCount: widget.lastloginlist.length,
                itemBuilder: (BuildContext context, int index) {
                  return listCard(widget.lastloginlist[index]);
                }),
          ),
        ));
  }

  Widget listCard(LastloginModel details) {
    return SizedBox(
      height: 150,
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          Positioned(
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.82,
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              height: 80,
              decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          details.lastlogin,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          details.userip,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          details.location,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ]),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 55,
            left: 260,
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(50)),
              child: Image.network(
                details.qrimage,
                width: 85,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
