

import 'package:flutter/material.dart';
import 'package:flutter_remote_control/models/draggable_info_model.dart';

class ShadowView extends StatelessWidget {

  const ShadowView({
    Key key,
    this.data,
    this.gridSize,
    this.startOffset,
  }): super(key: key);

  final List<DraggableInfo> data;
  final double gridSize;
  final Offset startOffset;

  @override
  Widget build(BuildContext context) {

    List<Widget> children = List.generate(data.length, (index) {
      print('build: ${data[index].dx} **** ${data[index].dy}');
      Rect rect = compute(data[index]);
      return Positioned.fromRect(
        rect: rect,
        child: Center(
          child: Image.asset(data[index].img, width: 24.0, height: 24.0,),
        ),
      );
    });
    
    return Stack(
      children: children,
    );
  }

  /// 计算控件位置
  Rect compute(DraggableInfo info) {
    double left, top, right, bottom;
    left = info.dx - startOffset.dx;
    top = info.dy - startOffset.dy;
    right = left + gridSize;
    bottom = top + gridSize;
    return Rect.fromLTRB(left, top, right, bottom);
  }
}