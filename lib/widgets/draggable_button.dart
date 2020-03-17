
import 'package:flutter/material.dart';
import 'package:flutter_remote_control/res/colors.dart';
import 'package:flutter_remote_control/models/draggable_info_model.dart';
import 'package:flutter_remote_control/models/draggable_type.dart';
import 'package:vibrate/vibrate.dart';

/// 四种类型拖动按钮
/// 1 * 1 图片 长宽为 48
/// 1 * 1 文字 长宽为 48
/// 3 * 3 图片 长宽依据屏幕宽度动态计算
/// 1 * 2 图片 宽为 48，宽 115
/// 
/// 默认按钮透明，按下为半透明。
/// 长按触发拖动，并给予振动反馈。
/// 
class DraggableButton extends StatefulWidget {

  const DraggableButton({
    Key key,
    this.data
  }): super(key: key);

  final DraggableInfo data;
  
  @override
  _DraggableButtonState createState() => _DraggableButtonState();
}

class _DraggableButtonState extends State<DraggableButton> {
  
  Color _color = Colors.transparent;
  
  @override
  Widget build(BuildContext context) {
    var child;
    /// 默认 1 * 1 长宽为 48
    double height = 48.0;
    double width = 48.0;
    
    if (widget.data.type == DraggableType.text) {
      child = Material(
        color: Colors.transparent,
        child: Text(
          widget.data.text,
          style: const TextStyle(color: Colors.white, fontSize: 12.0),
        ),
      );
    } else if (widget.data.type == DraggableType.imageOneToOne) {
      child = Image.asset(widget.data.img, width: 24.0, height: 24.0,);
    } else if (widget.data.type == DraggableType.imageOneToTwo) {
      child = Image.asset(widget.data.img, width: 48.0);
      width = 48.0;
      height = 115.0;
    } else if (widget.data.type == DraggableType.imageThreeToThree) {
      /// 计算大按钮高度：高度为小按钮去除上下间距（大按钮与小按钮上下对齐）
      double gap = ((MediaQuery.of(context).size.width / 5 * 2 - 96) / 2);
      double size = MediaQuery.of(context).size.width / 5 * 2 - gap;
      child = Image.asset(widget.data.img, width: size);
      width = size;
      height = size;
    }
    
    child = Container(
      alignment: Alignment.center,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(width / 2),
        border: widget.data.type == DraggableType.imageOneToTwo ? null : Border.all(color: Colours.circleBorder, width: 0.4),
      ),
      child: child,
    );
    
    return Center(
      child: GestureDetector(
        /// 长按触发拖动
        child: LongPressDraggable<DraggableInfo>(
          key: Key(widget.data.id),
          data: widget.data,
          /// 最多同时拖动一个
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
