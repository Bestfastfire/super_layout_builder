library super_layout_builder;

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

abstract class _BlocBase {
  void dispose();
}

class _LayoutMetricBloc with WidgetsBindingObserver implements _BlocBase {
  final _metrics = BehaviorSubject<MediaQueryData>();

  /// Stream with MediaQueryData
  Stream<MediaQueryData> get outStreamMetrics => _metrics.stream;

  /// Current MediaQueryData
  MediaQueryData get getCurrent => _metrics.value;

  static _LayoutMetricBloc _instance;
  factory _LayoutMetricBloc() {
    return _instance ??= _LayoutMetricBloc._internal();
  }

  _LayoutMetricBloc._internal() {
    WidgetsBinding.instance.addObserver(this);
    getData();
  }

  /// Sink MediaQueryData
  getData() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    _metrics.sink.add(data);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    getData();
  }

  @override
  void dispose() {
    _metrics.close();
  }
}

// ignore: must_be_immutable
class SuperLayoutBuilder extends StatefulWidget {
  /// Builder with MediaQueryData
  final Widget Function(BuildContext context, MediaQueryData data) builder;

  /// List of widths to trigger
  final List<double> triggerWidth;

  /// List of heights to trigger
  final List<double> triggerHeight;

  SuperLayoutBuilder(
      {this.triggerWidth = const [],
      this.triggerHeight = const [],
      @required this.builder});

  @override
  _SuperLayoutBuilderState createState() => _SuperLayoutBuilderState();
}

class _SuperLayoutBuilderState extends State<SuperLayoutBuilder> {
  static final _LayoutMetricBloc control = _LayoutMetricBloc();

  /// StreamSubscription
  StreamSubscription<MediaQueryData> listener;

  /// Last MediaQueryData
  MediaQueryData lastTrigger = control.getCurrent;

  /// Last triggered width
  double lastWidth = control.getCurrent.size.width;

  /// Last triggered height
  double lastHeight = control.getCurrent.size.height;
  SuperLayoutBuilder get w => widget;

  @override
  void initState() {
    super.initState();
    listener = control.outStreamMetrics.listen((e) {
      bool need(double v, double current, List<double> check, bool upper) {
        final biggest = check.where((d) => d >= v).toList();
        final smaller = check.where((d) => d < v).toList();

        if (upper) {
          if (smaller.isNotEmpty && smaller.reduce(max) > current) return true;
        } else {
          if (biggest.isNotEmpty && biggest.reduce(min) < current) return true;
        }

        return false;
      }

      if (need(e.size.width, lastTrigger.size.width, w.triggerWidth,
              lastWidth < e.size.width) ||
          need(e.size.height, lastTrigger.size.height, w.triggerHeight,
              lastHeight < e.size.height)) {
        lastTrigger = e;
        setState(() {});
      }

      lastHeight = e.size.height;
      lastWidth = e.size.width;
    });
  }

  @override
  void dispose() {
    super.dispose();
    listener.cancel();
  }

  @override
  Widget build(BuildContext context) => w.builder(context, lastTrigger);
}
