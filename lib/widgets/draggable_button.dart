
import 'package:flutter/material.dart';
import 'package:flutter_remote_control/res/colors.dart';
import 'package:flutter_remote_control/models/draggable_info_model.dart';
import 'package:flutter_remote_control/models/draggable_type.dart';
import 'package:flutter_remote_control/widgets/my_button.dart';
import 'package:flutter_remote_control/widgets/my_drag_target.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

/// 四种类型拖动按钮
/// 1 * 1 图片 长宽为 48
/// 1 * 1 文字 长宽为 48
/// 3 * 3 图片 长宽依据屏幕宽度动态计算
/// 1 * 2 图片 宽为 48，高 48.0 * 2.4
/// 
/// 默认按钮透明，按下为半透明。
/// 长按触发拖动，并给予振动反馈。
/// 
class DraggableButton extends StatefulWidget {

  const DraggableButton({
    Key key,
    @required this.data,
    this.onDragStarted,
    this.width1: 48.0,
    this.width2: 48.0,
    this.width3,
    this.fontSize: 12.0,
  }): super(key: key);

  final DraggableInfo data;
  final Function onDragStarted;
  final double width1;
  final double width2;
  final double width3;
  final double fontSize;
  
  @override
  _DraggableButtonState createState() => _DraggableButtonState();
}

class _DraggableButtonState extends State<DraggableButton> {
  
  Color _color = Colors.transparent;
  
  @override
  Widget build(BuildContext context) {
    /// 计算大按钮高度：高度为小按钮去除上下间距（大按钮与小按钮上下对齐）
    double gap = ((MediaQuery.of(context).size.width / 5 * 2 - 96) / 2);
    double size = MediaQuery.of(context).size.width / 5 * 2 - gap;
    /// 默认 1 * 1 长宽为 48
    var button = MyButton(
      data: widget.data,
      fontSize: widget.fontSize,
      width1: widget.width1,
      width2: widget.width2,
      width3: widget.width3 ?? size,
    );

    var child = Container(
      alignment: Alignment.center,
      height: button.getHeight(widget.data.type),
      width: button.getWidth(widget.data.type),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(button.getWidth(widget.data.type) / 2),
        border: widget.data.type == DraggableType.imageOneToTwo ? null : Border.all(color: Colours.circleBorder, width: 0.4),
      ),
      child: button,
    );
    
    return Center(
      child: GestureDetector(
        /// 长按触发拖动
        child: MyLongPressDraggable<DraggableInfo>(
          data: widget.data,
          dragAnchor: MyDragAnchor.center,
          /// 最多拖动一个
          maxSimultaneousDrags: 1,
          /// 拖动控件时的样式，这里添加一个透明度
          feedback: Opacity(
            opacity: 0.5,
            child: child,
          ),
          child: child,
          onDragStarted: () {
            /// 开始拖动, 给予振动反馈
            Vibrate.feedback(FeedbackType.light);
            if (widget.onDragStarted != null) {
              widget.onDragStarted();
            }
          },
          /// 拖动中实时位置回调
          onDrag: (offset) {
            /// 返回点为拖动目标左上角位置（相对于全屏）
            /// 这里根据目标大小，将位置调整为目标中心点，便于后面计算。
            widget.data.setOffset(offset.dx + button.getWidth(widget.data.type) / 2, offset.dy + button.getHeight(widget.data.type) / 2);
          },
        ),
        onTapDown: (_) {
          /// 按下按钮背景变化
          setState(() {
            _color = Colours.pressed;
          });
        },
        onTapUp: (_) {
          setState(() {
            _color = Colors.transparent;
          });
        },
        onTapCancel: () {
          setState(() {
            _color = Colors.transparent;
          });
        },
      ),
    );
  }
}
