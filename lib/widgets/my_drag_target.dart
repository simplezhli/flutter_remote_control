

import 'package:flutter/material.dart';
import 'package:flutter_remote_control/models/draggable_info_model.dart';
import 'package:flutter_remote_control/widgets/remote_control.dart';

class MyDragTarget extends StatefulWidget {
  @override
  _MyDragTargetState createState() => _MyDragTargetState();
}

class _MyDragTargetState extends State<MyDragTarget> {
  @override
  Widget build(BuildContext context) {
    return DragTarget<DraggableInfo>(
      onAccept: (DraggableInfo data){

      },
      builder: (context, candidateData, rejectedData){
        return RepaintBoundary(
          child: CustomPaint(
            painter: RemoteControlView()
          ),
        );
      },
    );
  }
}
