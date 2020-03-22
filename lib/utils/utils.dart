import 'package:flutter/material.dart';

class Utils {

  /// 计算手机实际内容区域
  static Offset getPhoneContentSize(double height) {
    // 上下间隔
    double gap = 12;
    // 手机屏幕间距5
    double phoneGap = 5;
    // 手机高度为Widget高度减去上下间隔24
    double phoneHeight = height - gap * 2;
    // 手机内容区域高 ：手机高度 - 手机头尾（48）- 手机屏幕间距（5 * 2）
    double mPhoneContentHeight = phoneHeight - 48 - phoneGap * 2;
    // 手机内容区域宽 ：手机内容区域高/ 7 * 4（手机内容区域为4：7）
    double mPhoneContentWidth = mPhoneContentHeight / 7 * 4;

    return Offset(mPhoneContentWidth, mPhoneContentHeight);
  }

}