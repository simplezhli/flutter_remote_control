
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_remote_control/models/draggable_info_model.dart';
import 'package:flutter_remote_control/utils/utils.dart';
import 'package:flutter_remote_control/widgets/my_drag_target.dart';
import 'package:flutter_remote_control/widgets/panel_view.dart';
import 'package:flutter_remote_control/widgets/phone_view.dart';

class RemoteControl extends StatefulWidget {
  @override
  _RemoteControlState createState() => _RemoteControlState();
}

class _RemoteControlState extends State<RemoteControl> {

  Rect _rect = Rect.zero;
  GlobalKey _key = GlobalKey();
  Offset offset = Offset.zero;

  GlobalKey<PanelViewState> _panelGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      RenderBox hint = _key.currentContext.findRenderObject();
      double width = hint.size.width;
      double height = hint.size.height;
      offset = Utils.getPhoneSize(height);
      
      _rect = Rect.fromCenter(
          center: Offset(width / 2, height / 2),
          width: offset.dx,
          height: offset.dy
      );
      setState(() {
        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: _key,
      fit: StackFit.expand,
      children: <Widget>[
        RepaintBoundary(
          child: CustomPaint(
            /// 绘制手机外形
            painter: PhoneView()
          ),
        ),
        Positioned.fromRect(
          rect: _rect,
          /// 接收拖动目标区域
          child: MyDragTarget<DraggableInfo>(
            builder: (context, candidateData, rejectedData) {
              return PanelView(
                key: _panelGlobalKey,
                gridSize: offset.dx / 4,
                shadowData: candidateData,
              );
            },
            onAccept: (data) {
              print('onAccept');
              _panelGlobalKey.currentState.addData(data);
            },
            onLeave: (data) {
              _panelGlobalKey.currentState.removeData(data);
            },
            onDrag: (data) {
              setState(() {

              });
            },
            onWillAccept: (data) {
              print(data.toString());
              return data != null;
            },
          ),
        ),
      ],
    );
  }
}
