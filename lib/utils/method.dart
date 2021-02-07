import 'package:flutter/material.dart';

typedef TaskFunction = Future Function();

/// 节流
void throttle(TaskFunction func, Duration duration) {
  if (func == null) {
    return;
  }
  bool enable = true;
  if (enable) {
    func().then((_) {
      enable = false;
    });
    Future.delayed(duration, () => enable = true);
  } else {
    debugPrint('run throttle >>> $func');
  }
}
