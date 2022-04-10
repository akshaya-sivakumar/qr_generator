import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qr_generator/ui/widgets/text_widget.dart';

class CustomFormField extends StatelessWidget {
  final String headingText;
  final String? hintText;
  final bool obsecureText;
  final Widget suffixIcon;
  final Widget? prefixIcon;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final int maxLines;

  const CustomFormField(
      {Key? key,
      required this.headingText,
      this.hintText,
      this.prefixIcon,
      required this.obsecureText,
      required this.suffixIcon,
      required this.textInputType,
      required this.textInputAction,
      required this.controller,
      required this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
            left: 30,
            right: 30,
            bottom: 15,
          ),
          child: TextWidget(
            headingText,
            mainAxisAlignment: MainAxisAlignment.start,
            color: Colors.white,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
          decoration: BoxDecoration(
            color: HexColor("#2E2C5E"),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            maxLines: maxLines,
            controller: controller,
            textInputAction: textInputAction,
            keyboardType: textInputType,
            obscureText: obsecureText,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                hintText: hintText,
                //  hintStyle: KTextStyle.textFieldHintStyle,
                border: InputBorder.none,
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon),
          ),
        )
      ],
    );
  }
}
