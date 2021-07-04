import 'dart:async';

class ProgressController {
  StreamController controller = new StreamController();

  Stream get stream => controller.stream;

  ///  初始化思维导图
  void setProgress(double progress) {
    controller.sink.add(progress);
  }

  /// 关闭stream流
  closed() {
    controller.close();
  }
}
