import 'package:flutter/material.dart';
import 'package:qr_generator/model/lastlogin_model.dart';
import 'package:qr_generator/ui/screens/last_login.dart';
import 'package:qr_generator/ui/screens/login_page.dart';
import 'package:qr_generator/ui/screens/qr_generator.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const Signin());
      case '/qrgenerator':
        return MaterialPageRoute(
            builder: (_) => QrGenerator(args as QrArguments));
      case '/lastlogin':
        return MaterialPageRoute(
            builder: (_) => LastLogin(args as List<LastloginModel>));

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return const Scaffold(
        body: Center(
          child: Text('Page not Found'),
        ),
      );
    });
  }
}

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<dynamic> navigateTo(String routeName, Object? arg) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arg);
  }
}
