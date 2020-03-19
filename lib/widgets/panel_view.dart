

import 'package:flutter/material.dart';
import 'package:flutter_remote_control/models/draggable_info_model.dart';
import 'package:flutter_remote_control/models/draggable_type.dart';
import 'package:flutter_remote_control/widgets/draggable_button.dart';
import 'package:flutter_remote_control/widgets/my_button.dart';

class PanelView extends StatefulWidget {

  const PanelView({
    Key key,
    @required this.shadowData,
    @required this.gridSize,
  }): super(key: key);

  
  final List<DraggableInfo> shadowData;
  final double gridSize;

  @override
  PanelViewState createState() => PanelViewState();
}

class PanelViewState extends State<PanelView> {

  final List<DraggableInfo> data = List();

  addData(DraggableInfo info) {
    /// 避免重复添加
    if (!data.contains(info)) {
      data.add(info);
    }
  }

  removeData(DraggableInfo info) {
    data.remove(info);
  }
  
  @override
  Widget build(BuildContext context) {
    if (widget.shadowData.isEmpty && data.isEmpty) {
      return Center(
        child: Text(
          '长按并拖拽下方按钮到这里',
          style: TextStyle(fontSize: 12.0, color: Colors.white),
        )
      );
    }
    /// 保存放置按钮的Rect
    List<Rect> rectList = List();
    /// 放置的按钮
    List<Widget> children = List.generate(data.length, (index) {
      Rect rect = compute(context,data[index]);
      rect = adjust(data[index], rect);
      rectList.add(rect);

      /// 去除自身判断重叠
      List<Rect> copyList = List();
      copyList.addAll(rectList);
      copyList.remove(rect);
      bool overlap = isOverlap(rect, copyList);

      if (overlap) {
        /// 重叠数据移除
        data.remove(data[index]);
        return const SizedBox.shrink();
      }
      
      return Positioned.fromRect(
        rect: rect,
        child: Center(
          child: DraggableButton(
            data: data[index],
            fontSize: 13.0,
            width1: widget.gridSize - 18,
            height1: widget.gridSize - 18,
            width2: widget.gridSize - 18,
            height2: (widget.gridSize - 18) * 2.4,
            width3: widget.gridSize * 2.5,
            height3: widget.gridSize * 2.5,
            onDragStarted: () {
              //data.remove(data[index]);
            },
          ),
        ),
      );
    });

    /// 引导指示按钮
    List<Widget> children1 = List.generate(widget.shadowData.length, (index) {
      Rect rect = compute(context, widget.shadowData[index]);
      rect = adjust(widget.shadowData[index], rect);

      bool overlap = isOverlap(rect, rectList);
      
      if (overlap) {
        return const SizedBox.shrink();
      }
      
      var button = MyButton(
          data: widget.shadowData[index],
          fontSize: 13.0,
          width1: widget.gridSize - 18, // padding 9
          height1: widget.gridSize - 18,
          width2: widget.gridSize - 18, // padding 9
          height2: (widget.gridSize - 18) * 2.4,
          width3: widget.gridSize * 2.5, // padding gridSize * 0.25
          height3: widget.gridSize * 2.5
      );

      return Positioned.fromRect(
        rect: rect,
        child: Center(
          child: button,
        ),
      );
    });

    children.addAll(children1);
    
    return Stack(
      children: children,
    );
  }

  /// 计算拖动目标位置
  Rect compute(BuildContext context, DraggableInfo info) {
    double width = widget.gridSize;
    double height = widget.gridSize;
    if (info.type == DraggableType.imageOneToTwo) {
      width = widget.gridSize;
      height = widget.gridSize * 2;
    } else if (info.type == DraggableType.imageThreeToThree) {
      width = widget.gridSize * 3;
      height = widget.gridSize * 3;
    }
    
    RenderBox box = context.findRenderObject();
    // 将全局坐标转换为当前Widget的本地坐标。
    Offset center = box.globalToLocal(Offset(info.dx, info.dy));
    return Rect.fromCenter(
      center: center,
      width: width,
      height: height,
    );
  }

  /// 调整拖动目标位置（处于田字格中）
  Rect adjust(DraggableInfo info, Rect mRect) {
    // 最小单元格宽高
    double size = widget.gridSize / 2;

    double left, top, right, bottom;
    // 修正x坐标
    double offsetX = mRect.left % size;
    if (offsetX < size / 2) {
      left = mRect.left - offsetX;
    } else {
      left = mRect.left - offsetX + size;
    }
    // 修正Y坐标
    double offsetY = mRect.top % size;
    if (offsetY < size / 2) {
      top = mRect.top - offsetY;
    } else {
      top = mRect.top - offsetY + size;
    }

    right = left + mRect.width;
    bottom = top + mRect.height;
    
    //超出边界部分修正(因为DragTarget判断长宽大于一半进入就算进入接收区域，也就是面积最小进入四分之一)
    if (top < 0) {
      top = 0;
      bottom = top + mRect.height;
    }

    if (left < 0) {
      left = 0;
      right = left + mRect.width;
    }
    
    if (bottom > widget.gridSize * 7) {
      bottom = widget.gridSize * 7;
      top = bottom - mRect.height;
    }
    
    if (right > widget.gridSize * 4) {
      right = widget.gridSize * 4;
      left = right - mRect.width;
    }
    
    return Rect.fromLTRB(left, top, right, bottom);
  }

  /// 判断指示View是否有重叠
  bool isOverlap(Rect rect, List<Rect> mRectList) {
    for (int i = 0; i < mRectList.length; i++) {
      if (isRectOverlap(mRectList[i], rect)) {
        return true;
      }
    }
    return false;
  }

  /// 判断两Rect是否重叠
  bool isRectOverlap(Rect oldRect, Rect newRect) {
    // 减9为了校验严格度降低, 9是 1 * 1 与 1 * 2 的 padding
    return (
        oldRect.right - 9 > newRect.left &&
        newRect.right - 9 > oldRect.left &&
        oldRect.bottom - 9 > newRect.top &&
        newRect.bottom - 9 > oldRect.top
    );
  }
}