library ruler_picker;

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TrianglePainter extends CustomPainter {
  final double lineSize;

  TrianglePainter({this.lineSize = 16});
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(lineSize, 0);
    path.lineTo(lineSize / 2, tan(pi / 3) * lineSize / 2);
    path.close();
    Paint paint = Paint();
    paint.color = Color.fromARGB(255, 118, 165, 248);
    paint.style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class RulerPickerController extends ValueNotifier<double> {
  RulerPickerController({value = 0.0}) : super(value);
  double get value => super.value;
  set value(double newValue) {
    super.value = newValue;
  }
}

typedef void ValueChangedCallback(num value);

/// 标尺选择器
/// [width] 必须是具体的值，包括父级container的width，不能是 double.infinity，
/// 可以传入MediaQuery.of(context).size.width
class RulerPicker extends StatefulWidget {
  final ValueChangedCallback onValueChange;
  final double width;
  double _value;
  int fractionDigits;
  RulerPickerController controller;
  RulerPicker({
    @required this.onValueChange,
    @required this.width,
    this.fractionDigits = 0,
    this.controller,
  });
  @override
  State<StatefulWidget> createState() {
    return RulerPickerState();
  }
}

// todo 实现 animateTo
class RulerPickerState extends State<RulerPicker> {
  double lastOffset = 0;
  bool isOnDrag = false;
  bool isPosFixed = false;
  String value;
  ScrollController scrollController;

  Widget triangle() {
    return SizedBox(
      width: 16,
      height: 16,
      child: CustomPaint(
        painter: TrianglePainter(),
      ),
    );
  }

  Widget mark() {
    return Container(
      child: SizedBox(
        width: 16,
        height: 34,
        child: Stack(
          children: <Widget>[
            triangle(),
            Container(
              width: 3,
              height: 34,
              margin: EdgeInsets.only(left: 6),
              color: Color.fromARGB(255, 118, 165, 248),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 247, 248, 250),
      child: Stack(
        children: <Widget>[
          Listener(
            onPointerDown: (event) {
              isOnDrag = true;
              FocusScope.of(context).requestFocus(new FocusNode());
              isPosFixed = false;
            },
            onPointerUp: (event) {
              isOnDrag = false;
            },
            child: NotificationListener(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollStartNotification) {
                } else if (scrollNotification is ScrollUpdateNotification) {
                } else if (scrollNotification is ScrollEndNotification) {
                  if (!isPosFixed) {
                    isPosFixed = true;
                    // fixPosition(scrollController.offset);
                    scrollController.notifyListeners();
                  }
                }
              },
              child: ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    // constraints: BoxConstraints(maxWidth: 10),
                    padding: index == 0
                        ? EdgeInsets.only(
                            left: widget.width / 2,
                          )
                        : EdgeInsets.zero,
                    child: Container(
                      width: 10,
                      child: Stack(
                        overflow: Overflow.visible,
                        children: <Widget>[
                          Container(
                            width: index % 10 == 0 ? 2 : 1,
                            height: index % 10 == 0 ? 32 : 20,
                            color: Color.fromARGB(255, 188, 194, 203),
                          ),
                          Positioned(
                            bottom: 5,
                            width: 50,
                            left: -25,
                            child: index % 10 == 0
                                ? Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      index.toString(),
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 188, 194, 203),
                                        fontSize: 14,
                                      ),
                                    ),
                                  )
                                : Container(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            left: widget.width / 2 - 6,
            child: mark(),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (!isOnDrag && (scrollController.offset - lastOffset).abs() < 1) {
        fixPosition(scrollController.offset);
        return;
      }
      lastOffset = scrollController.offset;
      setState(() {
        widget._value = double.parse((scrollController.offset / 10)
            .toStringAsFixed(widget.fractionDigits));
        if (widget._value < 0) widget._value = 0;
        if (widget.onValueChange != null) {
          widget.onValueChange(widget._value);
        }
      });
    });
    widget.controller.addListener(() {
      setPositionByValue(widget.controller.value);
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  void didUpdateWidget(RulerPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void fixPosition(double curPos) {
    double targetPos =
        double.parse(curPos.toStringAsFixed(widget.fractionDigits));
    if (targetPos < 0) targetPos = 0;
    // todo animateTo 异步操作
    scrollController.jumpTo(
      targetPos,
      // duration: Duration(milliseconds: 500),
      // curve: Curves.easeOut,
    );
  }

  void setPositionByValue(double value) {
    double targetPos = value * 10;
    if (targetPos < 0) targetPos = 0;
    scrollController.jumpTo(
      targetPos,
      // duration: Duration(milliseconds: 500),
      // curve: Curves.easeOut,
    );
  }
}
