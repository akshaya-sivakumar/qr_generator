import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(this.data,
      {Key? key,
      this.data2,
      this.width,
      this.height,
      this.fontWeight,
      this.fontWeight2,
      this.paddingright,
      this.textAlign,
      this.underline,
      this.fontSize,
      this.fontSize2,
      this.overflow,
      this.color,
      this.color2,
      this.mainAxisAlignment,
      this.maxLine,
      this.fontStyle})
      : super(key: key);
  final String? data;
  final String? data2;
  final double? width;
  final double? paddingright;
  final double? height;
  final FontWeight? fontWeight;
  final FontWeight? fontWeight2;
  final TextAlign? textAlign;
  final bool? underline;
  final double? fontSize;
  final double? fontSize2;
  final TextOverflow? overflow;
  final Color? color;
  final int? maxLine;
  final Color? color2;
  final FontStyle? fontStyle;
  final MainAxisAlignment? mainAxisAlignment;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
      children: [
        Container(
            padding: EdgeInsets.only(right: paddingright ?? 7),
            alignment: Alignment.centerLeft,
            width: width,
            height: height,
            child: RichText(
              softWrap: true,
              overflow: TextOverflow.fade,
              maxLines: maxLine,
              textAlign: textAlign ?? TextAlign.center,
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: data,
                    style: TextStyle(
                        fontSize: fontSize ??
                            MediaQuery.of(context).size.width * 0.04,
                        color: color ?? Colors.black,
                        fontStyle: fontStyle,
                        fontWeight: fontWeight,
                        decoration: underline != null && underline!
                            ? TextDecoration.underline
                            : TextDecoration.none)),
              ]),
            )),
      ],
    );
  }
}
