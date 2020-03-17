

import 'package:flutter/material.dart';
import 'package:flutter_remote_control/res/colors.dart';

/// 绘制手机外形
class RemoteControlView extends CustomPainter {

  final int widthCount = 4;
  final int heightCount = 7;

  Paint _mPhonePaint;
  RRect _rRect;
  Path _path;

  RemoteControlView() {
    _mPhonePaint = Paint();
    _path = Path();
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    // 上下间隔
    double gap = 12;
    // 手机高度为View高度减去上下间隔24
    double phoneHeight = size.height - gap * 2;
    // 手机内容区域高 ：手机高度 - 手机头尾（48）- 手机屏幕间距（5） * 2）
    double mPhoneContentHeight = phoneHeight - 58;
    // 手机内容区域宽 ：手机内容区域高/ 7 * 4（手机内容区域为4：7）
    double mPhoneContentWidth = mPhoneContentHeight / heightCount * widthCount;
    // 手机宽度为手机内容区域宽 + 手机屏幕间距 * 2
    double mPhoneWidth = mPhoneContentWidth + 10;
    // 绘制起始点
    double startX = (size.width - mPhoneWidth) / 2;

    _mPhonePaint..color = Colours.line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    // 绘制手机外壳
    _rRect = RRect.fromLTRBR(startX, gap, size.width - startX, size.height - gap, Radius.circular(12.0));
    canvas.drawRRect(_rRect, _mPhonePaint);
    // 绘制手机上下两条线
    Offset lineStartOffset = Offset(startX, gap * 3);
    Offset lineEndOffset = Offset(size.width - startX, gap * 3);
    canvas.drawLine(lineStartOffset, lineEndOffset, _mPhonePaint);
    
    lineStartOffset = Offset(startX, size.height - gap * 3);
    lineEndOffset = Offset(size.width - startX, size.height - gap * 3);
    canvas.drawLine(lineStartOffset, lineEndOffset, _mPhonePaint);
    // 绘制手机上方听筒、摄像头
    _rRect = RRect.fromLTRBR(size.width / 2 - 25, 22, size.width / 2 + 25, 26, Radius.circular(2.0));
    canvas.drawRRect(_rRect, _mPhonePaint);
    
    Offset circleOffset = Offset(size.width / 2 - 40, gap * 2);
    canvas.drawCircle(circleOffset, gap / 3, _mPhonePaint);
    
    circleOffset = Offset(size.width / 2 + 40, gap * 2);
    canvas.drawCircle(circleOffset, gap / 3, _mPhonePaint);
    // 绘制手机下方按键
    // 圆
    circleOffset = Offset(size.width / 2, size.height - gap * 2);
    canvas.drawCircle(circleOffset, gap / 2, _mPhonePaint);
    // 方
    Rect _rect = Rect.fromLTRB(startX + mPhoneWidth / 5, size.height - 29, startX + mPhoneWidth / 5 + 10, size.height - 19);
    canvas.drawRect(_rect, _mPhonePaint);
    // 三角
    _path.moveTo(size.width - startX - mPhoneWidth / 5, size.height - 30);
    _path.lineTo(size.width - startX - mPhoneWidth / 5 - 10, size.height - 24);
    _path.lineTo(size.width - startX - mPhoneWidth / 5, size.height - 18);
    _path.close();
    canvas.drawPath(_path, _mPhonePaint);
    // 绘制网格（4 * 7的田字格）田字格外框为实线，内侧为虚线
    // 手机屏幕间距5pd
    int phoneGap = 5;
    // 格子的宽高
    double gridSize = mPhoneContentHeight / heightCount;

    _mPhonePaint.strokeWidth = 0.3;
    // 横线
    for (int z = 0; z <= heightCount; z++){
      _mPhonePaint.color = Colours.solid_line;
      // 实线
      lineStartOffset = Offset(startX + phoneGap, 41 + z * gridSize);
      lineEndOffset = Offset(size.width - startX - phoneGap, 41 + z * gridSize);
      canvas.drawLine(lineStartOffset, lineEndOffset, _mPhonePaint);

      // 虚线
      if (z != heightCount){
        _mPhonePaint.color = Colours.dashed_line;
        lineStartOffset = Offset(startX + phoneGap, 41 + z * gridSize + gridSize / 2);
        lineEndOffset = Offset(size.width - startX - phoneGap, 41 + z * gridSize + gridSize / 2);
        canvas.drawLine(lineStartOffset, lineEndOffset, _mPhonePaint);
      }
    }

    // 竖线
    for (int z = 0; z <= widthCount; z++){
      _mPhonePaint.color = Colours.solid_line;
      // 实线
      lineStartOffset = Offset(startX + phoneGap + z * gridSize, 41);
      lineEndOffset = Offset(startX + phoneGap + z * gridSize, size.height - 41);
      canvas.drawLine(lineStartOffset, lineEndOffset, _mPhonePaint);
      // 虚线
      if (z != widthCount){
        _mPhonePaint.color = Colours.dashed_line;
        lineStartOffset = Offset(startX + phoneGap + z * gridSize + gridSize / 2, 41);
        lineEndOffset = Offset(startX + phoneGap + z * gridSize + gridSize / 2, size.height - 41);
        canvas.drawLine(lineStartOffset, lineEndOffset, _mPhonePaint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
