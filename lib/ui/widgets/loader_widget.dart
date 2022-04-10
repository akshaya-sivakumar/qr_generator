import 'package:flutter/material.dart';

class LoaderWidget {
  void showLoader(BuildContext context,
      {bool showLoader = false, String? text}) {
    showLoader
        ? showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return WillPopScope(
                  onWillPop: () async => false,
                  child: AlertDialog(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    backgroundColor: Colors.white,
                    content: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: CircularProgressIndicator(
                              strokeWidth: 4,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black)),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          text ?? "",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: const Size.fromHeight(19).height),
                        )
                      ],
                    ),
                  ));
            },
          )
        : Navigator.of(context).pop();
  }
}
