import 'package:flutter/material.dart';
import 'package:qr_generator/ui/widgets/text_widget.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final double? width, height, fontsize;
  final Color? color, bordercolor;
  final FontWeight? fontweight;
  const AuthButton(
      {Key? key,
      required this.onTap,
      required this.text,
      this.fontsize,
      this.width,
      this.fontweight,
      this.color,
      this.bordercolor,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        width: width ?? MediaQuery.of(context).size.width * 0.8,
        height: height ?? MediaQuery.of(context).size.height * 0.06,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              side: BorderSide(
                width: 0.8,
                color: bordercolor ?? Colors.transparent,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0),
              ),
              primary: color ?? Colors.grey[700],
              padding: EdgeInsets.zero // background
              ),
          onPressed: onTap,
          child: TextWidget(
            text,
            textAlign: TextAlign.center,
            color: Colors.white,
            fontWeight: fontweight ?? FontWeight.normal,
            fontSize: fontsize,
          ),
        ) /* Container(
        width: width ?? MediaQuery.of(context).size.width * 0.7,
        height: height ?? MediaQuery.of(context).size.height * 0.06,
        margin: const EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: TextWidget(
          text,
          textAlign: TextAlign.center,
          color: Colors.white,
        ),
      ), */
        );
  }
}
