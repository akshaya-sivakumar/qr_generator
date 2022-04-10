import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityCheck {
  Connectivity connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> subscription;
  bool isOnline = true;
  Future<bool> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      isOnline = true;
    } else {
      isOnline = false;
    }
    return isOnline;
  }
}
