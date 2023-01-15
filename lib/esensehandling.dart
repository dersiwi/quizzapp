import 'package:flutter/material.dart';
import 'dart:io';

import 'package:esense_flutter/esense.dart';
import 'package:permission_handler/permission_handler.dart';

//global variable for every other class to use
GlobalEsenseHandler geh = GlobalEsenseHandler();

/*
  Basically a wrapper for the ESenseManager
*/
class GlobalEsenseHandler {
  ConnectionType status = ConnectionType.unknown;
  ESenseManager? manager = null;
  String? deviceName = null;

  bool isConnected() {
    return status == ConnectionType.connected;
  }

  Future<void> _askForPermissions() async {
    //code from https://pub.dev/packages/esense_flutter/example - apparently necessary
    if (!(await Permission.bluetooth.request().isGranted)) {
      print(
          'WARNING - no permission to use Bluetooth granted. Cannot access eSense device.');
    }
    if (!(await Permission.locationWhenInUse.request().isGranted)) {
      print(
          'WARNING - no permission to access location granted. Cannot access eSense device.');
    }
  }

  Future<void> connectToEsense(String deviceName) async {
    if (Platform.isAndroid) await _askForPermissions();

    this.deviceName = deviceName;
    manager = ESenseManager(deviceName);
    if (manager == null) {
      return;
    }
    await manager!.disconnect();
    manager!.connectionEvents.listen((event) {
      status = event.type;
    });
    await manager?.connect();
  }
}
