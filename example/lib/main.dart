// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ruler_picker/ruler_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Ruler Picker Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RulerPickerController _rulerPickerController;
  TextEditingController _textEditingController;
  num showValue = 0;
  int fractionDigits = 1;
  @override
  void initState() {
    super.initState();
    _rulerPickerController = RulerPickerController(value: 0);
    _textEditingController = TextEditingController(text: '0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RulerPicker(
              controller: _rulerPickerController,
              fractionDigits: fractionDigits,
              onValueChange: (value) {
                print(value);
                setState(() {
                  _textEditingController.text = value.toString();
                });
              },
              width: 300,
              height: 100,
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              width: 300,
              child: CupertinoTextField(
                controller: _textEditingController,
                onChanged: (value) {
                   showValue = num.parse(num.parse(value).toStringAsFixed(fractionDigits));
                },
                onEditingComplete: () {
                  _rulerPickerController.value = showValue;
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
