import 'package:esense_flutter/esense.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';

import 'widgets.dart';
import 'constants.dart';
import 'esensehandling.dart';

class WearableWidget extends StatefulWidget {
  const WearableWidget({super.key});

  @override
  State<WearableWidget> createState() => _WearableWidgetState();
}

class _WearableWidgetState extends State<WearableWidget> {
  String text = "Stream connected : ";
  String streaminformation = "No Stream connected. Tap to connect.";
  TextEditingController _textFieldController = TextEditingController();

  String? deviceName = null;
  Stream<ConnectionEvent>? currentStream = null;

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter the name of the device you want to connect:'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  deviceName = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Device name"),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: Padding(
            padding: EdgeInsets.only(top: 30),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width,
              child: Option(
                optionContent: deviceName == null || deviceName == ""
                    ? "No device selected. Tap to enter device name."
                    : "Selected device : ${deviceName}",
                color: notSelected,
                heightModificator: 0.5,
              ),
            ),
          ),
          onTap: () {
            _displayTextInputDialog(context);
          },
        ),
        GestureDetector(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width,
            child: Option(
              optionContent: streaminformation,
              color: notSelected,
              heightModificator: 0.5,
            ),
          ),
          onTap: () {
            //goto widget to manage bluetooth device and stream.
            try {
              geh.connectToEsense("${deviceName}");
            } on Exception catch (e) {
              print("Connection couldn't be established");
            }
            setState(
              () {
                if (geh.isConnected()) {
                  streaminformation = "Connected to ${geh.deviceName}";
                } else {
                  streaminformation = "No Stream connected. Tap to connect";
                }
              },
            );
          },
        ),
      ],
    );
  }
}
