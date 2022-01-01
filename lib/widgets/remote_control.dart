

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
  GlobalKey<PanelViewState> _panelGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((callback) {
      RenderBox? hint = _key.currentContext!.findRenderObject() as RenderBox?;
      double width = hint!.size.width;
      double height = hint.size.height;
      Size size = Utils.getPhoneContentSize(height);
      
      _rect = Rect.fromCenter(
          center: Offset(width / 2, height / 2),
          width: size.width,
          height: size.height
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
        /// RepaintBoundary： https://weilu.blog.csdn.net/article/details/103452637
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
            builder: (_, candidateData, __) {
              return PanelView(
                /// key： https://weilu.blog.csdn.net/article/details/104745624
                key: _panelGlobalKey,
                gridSize: _rect.width / 4,
                dropShadowData: candidateData,
              );
            },
            onAccept: (data) {
              /// 目标被区域接收
              _panelGlobalKey.currentState?.addData(data);
            },
            onLeave: (data) {
              /// 目标移出区域
              _panelGlobalKey.currentState?.removeData(data);
            },
            onDrag: (data) {
              /// 监测到有目标在拖动，绘制指示投影。
              setState(() {

              });
            },
            onWillAccept: (data) {
              /// 判断目标是否可以被接收
              return data != null;
            },
          ),
        ),
      ],
    );
  }
}
