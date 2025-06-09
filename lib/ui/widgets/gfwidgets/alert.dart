import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:pm25_app/core/loggers/log.dart';

class GfAlertProvider extends ChangeNotifier {
  Widget _alertWidget = const SizedBox();
  bool get isVisible => _alertWidget is! SizedBox;
  Widget get alertWidget => _alertWidget;

  final log = AppLogger('gfalert_provider');

  /// 顯示通用樣板彈窗
  /// [title]：標題文字
  /// [content]：內容 Widget
  /// [verticalPosition]：彈窗往下的垂直位移
  /// [alertWidth] / [alertHeight]：可選，指定寬高
  /// [type]：GFAlert 的樣式
  /// [buttonText]：底部按鈕文字
  /// [onPressed]：按鈕回呼，不傳則自動 hideAlert
  void showAlert({
    required BuildContext context,
    required String title,
    required Widget content,
    double verticalPosition = 150,
    double? alertWidth,
    double? alertHeight,
    GFAlertType type = GFAlertType.rounded,
    String buttonText = 'Close',
    VoidCallback? onPressed,
  }) {
    final mq = MediaQuery.of(context).size;
    final width = alertWidth ?? mq.width * 0.8;

    _alertWidget = Stack(
      children: [
        // 半透明背景，點擊也能關閉
        GestureDetector(
          onTap: hideAlert,
          child: Container(
            color: Colors.black.withOpacity(0.3),
            width: mq.width,
            height: mq.height,
          ),
        ),

        // 真正的浮動彈窗
        GFFloatingWidget(
          verticalPosition: verticalPosition,
          showBlurness: false,
          body: Column(
            children: [
              // 留空間給上方
              SizedBox(height: verticalPosition + 20),
              SizedBox(
                width: width,
                height: alertHeight,
                child: Center(
                  child: GFAlert(
                    alignment: Alignment.center,
                    backgroundColor: Colors.white,
                    title: title,
                    content: content,
                    type: type,
                    bottomBar: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GFButton(
                          onPressed: onPressed ?? hideAlert,
                          color: GFColors.LIGHT,
                          child: Text(
                            buttonText,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    notifyListeners();
  }

  /// 隱藏彈窗
  void hideAlert() {
    _alertWidget = const SizedBox();
    notifyListeners();
    log.i('Alert hidden');
  }
}
