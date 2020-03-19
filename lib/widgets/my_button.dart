
import 'package:flutter/material.dart';
import 'package:flutter_remote_control/models/draggable_info_model.dart';
import 'package:flutter_remote_control/models/draggable_type.dart';

class MyButton extends StatelessWidget {

  const MyButton({
    Key key,
    @required this.data,
    this.width1,
    this.height1,
    this.width2,
    this.height2,
    this.width3,
    this.height3,
    this.fontSize,
  }): super(key: key);

  final DraggableInfo data;
  final double width1;
  final double height1;
  final double width2;
  final double height2;
  final double width3;
  final double height3;
  final double fontSize;
  
  @override
  Widget build(BuildContext context) {
    var child;
    
    if (data.type == DraggableType.text) {
      child = Material(
        color: Colors.transparent,
        child: Text(
          data.text,
          style: TextStyle(color: Colors.white, fontSize: fontSize),
        ),
      );
    } else if (data.type == DraggableType.imageOneToOne) {
      child = Image.asset(data.img, width: width1 / 2, height: height1 / 2,);
    } else if (data.type == DraggableType.imageOneToTwo) {
      child = Image.asset(data.img, width: width2, height: height2,);
    } else if (data.type == DraggableType.imageThreeToThree) {
      child = Image.asset(data.img, width: width3, height: height3,);
    }
    return child;
  }
  
  double getWidth(DraggableType type) {
    double width;
    if (type == DraggableType.text || data.type == DraggableType.imageOneToOne) {
      width = width1;
    }
    if (type == DraggableType.imageOneToTwo) {
      width = width2;
    }
    if (type == DraggableType.imageThreeToThree) {
      width = width3;
    }
    return width;
  }

  double getHeight(DraggableType type) {
    double height;
    if (type == DraggableType.text || data.type == DraggableType.imageOneToOne) {
      height = height1;
    }
    if (type == DraggableType.imageOneToTwo) {
      height = height2;
    }
    if (type == DraggableType.imageThreeToThree) {
      height = height3;
    }
    return height;
  }
}
