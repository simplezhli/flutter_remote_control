

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_remote_control/models/draggable_info_model.dart';
import 'package:flutter_remote_control/utils/utils.dart';
import 'package:flutter_remote_control/widgets/my_drag_target.dart';
import 'package:flutter_remote_control/widgets/phone_view.dart';
import 'package:flutter_remote_control/widgets/shadow_view.dart';

class RemoteControl extends StatefulWidget {
  @override
  _RemoteControlState createState() => _RemoteControlState();
}

class _RemoteControlState extends State<RemoteControl> {

  Rect _rect = Rect.zero;
  GlobalKey _key = GlobalKey();
  Offset offset, _startOffset;
  
  List<DraggableInfo> _list = List();

  Duration _durationTime = Duration(milliseconds: 33);
  Timer _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      RenderBox hint = _key.currentContext.findRenderObject();
      double width = hint.size.width;
      double height = hint.size.height;
      offset = Utils.getPhoneSize(height);
      double statusBarHeight = MediaQuery.of(context).padding.top;
      _startOffset = Offset(offset.dx - width / 2, statusBarHeight + 56 + 41); // AppBar高度 56
      
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
              return _list.isEmpty && candidateData.isEmpty ? Center(
                  child: Text(
                    '长按并拖拽下方按钮到这里',
                    style: TextStyle(fontSize: 12.0, color: Colors.white),
                  )
              ) :
              /// 投影
              ShadowView(
                startOffset: _startOffset,
                gridSize: offset.dx / 4,
                data: candidateData,
              );
            },
            onAccept: (data) {
              print('onAccept: ${data.toString()}');
            },
            onLeave: (data) {
              print('onLeave: ${data.toString()}');
            },
            onDrag: (data) {
              /// 减缓重绘频率
//              if (_debounce?.isActive ?? false) {
//                _debounce?.cancel();
//              }
//              _debounce = Timer(_durationTime, () {
                setState(() {

                });
//              });
            },
            onWillAccept: (data) {
              return data != null;
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
