import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:qr_generator/model/lastlogin_model.dart';

import 'package:qr_generator/ui/widgets/scaffold.dart';

class LastLogin extends StatefulWidget {
  const LastLogin(this.lastloginlist, {Key? key}) : super(key: key);
  final List<LastloginModel> lastloginlist;
  @override
  State<LastLogin> createState() => _LastLoginState();
}

class _LastLoginState extends State<LastLogin> {
  @override
  void initState() {
    super.initState();
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
      height: 120,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Positioned(
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.82,
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              height: 80,
              decoration: BoxDecoration(
                  color: Color.fromARGB(137, 46, 45, 45),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat("hh:mm aa")
                              .format(DateTime.parse(details.lastlogin)),
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          "IP:" + details.userip,
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
            bottom: 25,
            right: MediaQuery.of(context).size.height * 0.0499,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                child: Image.network(
                  details.qrimage,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null)
                      return Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(3.0),
                        child: Container(child: child),
                      );
                    return Container(
                      margin: EdgeInsets.only(left: 30, bottom: 20),
                      alignment: Alignment.topLeft,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  },
                  width: 85,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
