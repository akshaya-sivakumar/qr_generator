import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_generator/ui/widgets/text_widget.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold(
      {Key? key,
      required this.child,
      required this.heading,
      this.logout = false,
      this.back = false})
      : super(key: key);
  final Widget child;
  final bool logout, back;
  final String? heading;
  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String get email => _emailController.text.trim();
  String get password => _passwordController.text.trim();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          SvgPicture.asset("assets/background.svg",
              width: MediaQuery.of(context).size.width, fit: BoxFit.fill),
          /*   CustomHeader(
                    text: 'Log In.',
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => const SignUp()));
                    },
                  ), */
          if (widget.back)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.03,
              left: MediaQuery.of(context).size.width * 0.04,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const TextWidget(
                  "<",
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
          if (widget.logout)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.03,
              right: MediaQuery.of(context).size.width * 0.009,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                },
                child: const TextWidget(
                  "Logout",
                  color: Colors.white,
                ),
              ),
            ),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.09,
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: widget.child)),
          Positioned(
              //left: MediaQuery.of(context).size.width * 0.38,
              top: MediaQuery.of(context).size.height * 0.069,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.heading ?? "",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                  ),
                ),
              )),
        ],
      )),
    );
  }
}
