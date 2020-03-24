

import 'package:flutter/material.dart';
import 'package:flutter_remote_control/models/draggable_info_model.dart';
import 'package:flutter_remote_control/models/draggable_type.dart';
import 'package:flutter_remote_control/widgets/draggable_button.dart';
import 'package:flutter_remote_control/widgets/my_button.dart';

/// 遥控操作面板
class PanelView extends StatefulWidget {

  const PanelView({
    Key key,
    @required this.dropShadowData,
    @required this.gridSize,
  }): super(key: key);
  
  final List<DraggableInfo> dropShadowData;
  final double gridSize;

  @override
  PanelViewState createState() => PanelViewState();
}

class PanelViewState extends State<PanelView> {

  final List<DraggableInfo> data = List();

  addData(DraggableInfo info) {
    /// 避免重复添加同一按钮
    if (!data.contains(info)) {
      data.add(info);
    }
  }

  removeData(DraggableInfo info) {
    data.remove(info);
  }
  
  @override
  Widget build(BuildContext context) {
    if (widget.dropShadowData.isEmpty && data.isEmpty) {
      return Center(
        child: Text(
          '长按并拖拽下方按钮到这里',
          style: TextStyle(fontSize: 12.0, color: Colors.white),
        )
      );
    }
    /// 保存放置按钮的Rect
    List<Rect> rectList = List();
    /// 临时存储Rect
    List<Rect> copyList = List();
    
    /// 移除与投影相同的数据，避免投影与放置按钮重复显示
    widget.dropShadowData.forEach((dropShadow) {
      if (data.contains(dropShadow)) {
        removeData(dropShadow);
      }
    });
    /// 放置的按钮
    List<Widget> children = List.generate(data.length, (index) {
      /// 避免外界对data的增删，导致下标越界
      if (index > data.length - 1) {
        return const SizedBox.shrink();
      }
      Rect rect = computeSize(context, data[index]);
      rect = adjustPosition(data[index], rect);
      rectList.add(rect);

      /// 去除自身判断重叠
      copyList.clear();
      copyList.addAll(rectList);
      copyList.remove(rect);
      bool overlap = isOverlap(rect, copyList);

      if (overlap) {
        /// 重叠数据移除
        removeData(data[index]);
        return const SizedBox.shrink();
      }
      
      return Positioned.fromRect(
        rect: rect,
        child: Center(
          /// 涉及widget移动、删除，注意添加key  https://weilu.blog.csdn.net/article/details/104745624
          key: ObjectKey(data[index]),
          child: DraggableButton(
            data: data[index],
            fontSize: 13.0,
            width1: widget.gridSize - 18,
            width2: widget.gridSize - 18,
            width3: widget.gridSize * 2.5,
            onDragStarted: () {
              /// 开始拖动时，移除面板上的拖动按钮
              removeData(data[index]);
            },
          ),
        ),
      );
    });

    /// 引导指示按钮（投影）
    List<Widget> children1 = List.generate(widget.dropShadowData.length, (index) {
      Rect rect = computeSize(context, widget.dropShadowData[index]);
      rect = adjustPosition(widget.dropShadowData[index], rect);

      bool overlap = isOverlap(rect, rectList);
      
      if (overlap) {
        return const SizedBox.shrink();
      }
      
      var button = MyButton(
          data: widget.dropShadowData[index],
          fontSize: 13.0,
          width1: widget.gridSize - 18, // padding 9
          width2: widget.gridSize - 18, // padding 9
          width3: widget.gridSize * 2.5, // padding gridSize * 0.25
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

  /// 计算拖动目标大小及位置
  Rect computeSize(BuildContext context, DraggableInfo info) {
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
  Rect adjustPosition(DraggableInfo info, Rect mRect) {
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

  /// 是否有重叠
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