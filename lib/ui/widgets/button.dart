import 'package:flutter/material.dart';
import 'package:qr_generator/ui/widgets/text_widget.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final double? width, height;
  const AuthButton(
      {Key? key,
      required this.onTap,
      required this.text,
      this.width,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
