

import 'package:flutter/material.dart';
import 'package:flutter_remote_control/res/colors.dart';
import 'package:flutter_remote_control/utils/utils.dart';
import 'package:path_drawing/path_drawing.dart';

/// 绘制手机外形
class PhoneView extends CustomPainter {

  final int widthCount = 4;
  final int heightCount = 7;

  Paint _mPhonePaint;
  RRect _rRect;
  // 三角
  Path _path;
  // 网格实线
  Path _solidPath;
  // 网格虚线
  Path _dashPath;

  PhoneView() {
    _mPhonePaint = Paint();
    _path = Path();
    _solidPath = Path();
    _dashPath = Path();
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    // 上下间隔
    double gap = 12;
    // 手机屏幕间距5
    double phoneGap = 5;
   
    Offset offset = Utils.getPhoneSize(size.height);
    double mPhoneContentHeight = offset.dy;
    double mPhoneContentWidth = offset.dx;
    double mPhoneWidth = mPhoneContentWidth + phoneGap * 2;
    // 绘制起始点
    double startX = (size.width - mPhoneWidth) / 2;

    // 绘制手机屏幕
    _mPhonePaint.color = Colours.content;
    Rect rect = Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: mPhoneContentWidth + phoneGap * 2, 
        height: mPhoneContentHeight +  phoneGap * 2
    );
    canvas.drawRect(rect, _mPhonePaint);

    _mPhonePaint..color = Colours.line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    // 绘制手机外壳
    _rRect = RRect.fromLTRBR(startX, gap, size.width - startX, size.height - gap, Radius.circular(12.0));
    canvas.drawRRect(_rRect, _mPhonePaint);
    
    double dx, dy;
    // 绘制手机上下两条线
    dx = startX;
    dy = gap * 3;
    Offset lineStartOffset = Offset(dx, dy);
    Offset lineEndOffset = Offset(size.width - dx, dy);
    canvas.drawLine(lineStartOffset, lineEndOffset, _mPhonePaint);

    dx = startX;
    dy = size.height - gap * 3;
    lineStartOffset = Offset(dx, dy);
    lineEndOffset = Offset(size.width - dx, dy);
    canvas.drawLine(lineStartOffset, lineEndOffset, _mPhonePaint);
    // 绘制手机上方听筒、摄像头
    _rRect = RRect.fromLTRBR(size.width / 2 - 25, 22, size.width / 2 + 25, 26, Radius.circular(2.0));
    canvas.drawRRect(_rRect, _mPhonePaint);

    dx = size.width / 2;
    dy = gap * 2;
    Offset circleOffset = Offset(dx - 40, dy);
    canvas.drawCircle(circleOffset, gap / 3, _mPhonePaint);
    
    circleOffset = Offset(dx + 40, dy);
    canvas.drawCircle(circleOffset, gap / 3, _mPhonePaint);
    // 绘制手机下方按键
    // 圆
    circleOffset = Offset(dx, size.height - dy);
    canvas.drawCircle(circleOffset, gap / 2, _mPhonePaint);
    // 方
    Rect _rect = Rect.fromLTRB(startX + mPhoneWidth / 5, size.height - 29, startX + mPhoneWidth / 5 + 10, size.height - 19);
    canvas.drawRect(_rect, _mPhonePaint);
    // 三角
    dx = size.width - startX - mPhoneWidth / 5;
    dy = size.height;
    _path.moveTo(dx, dy - 30);
    _path.lineTo(dx - 10, dy - 24);
    _path.lineTo(dx, dy - 18);
    _path.close();
    canvas.drawPath(_path, _mPhonePaint);
    
    // 绘制网格（4 * 7的田字格）田字格外框为实线，内侧为虚线
    // 格子的宽高
    double gridSize = mPhoneContentHeight / heightCount;

    _mPhonePaint.strokeWidth = 0.4;
    // 横线
    for (int z = 0; z <= heightCount; z++) {
      // 实线
      dx = startX + phoneGap;
      dy = 41 + z * gridSize;
      _solidPath.moveTo(dx, dy);
      _solidPath.lineTo(size.width - dx, dy);

      // 虚线
      if (z != heightCount) {
        dx = startX + phoneGap;
        dy = 41 + z * gridSize + gridSize / 2;
        _dashPath.moveTo(dx, dy);
        _dashPath.lineTo(size.width - dx, dy);
      }
    }
    
    // 竖线
    for (int z = 0; z <= widthCount; z++) {
      // 实线
      dx = startX + phoneGap + z * gridSize;
      dy = 41;
      _solidPath.moveTo(dx, dy);
      _solidPath.lineTo(dx, size.height - dy);
      // 虚线
      if (z != widthCount) {
        dx = startX + phoneGap + z * gridSize + gridSize / 2;
        dy = 41;
        _dashPath.moveTo(dx, dy);
        _dashPath.lineTo(dx, size.height - dy);
      }
    }
    _mPhonePaint.color = Colours.solid_line;
    canvas.drawPath(_solidPath, _mPhonePaint);
    
    _mPhonePaint.color = Colours.dash_line;
    canvas.drawPath(dashPath(
      _dashPath,
      dashArray: CircularIntervalList<double>(<double>[4, 4]),
    ), _mPhonePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
