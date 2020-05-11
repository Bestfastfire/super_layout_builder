library super_layout_builder;

import 'dart:async';
import 'dart:math';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class _LayoutMetricBloc with WidgetsBindingObserver implements BlocBase {
  final _metrics = BehaviorSubject<MediaQueryData>();
  Stream<MediaQueryData> get outStreamMetrics => _metrics.stream;
  MediaQueryData get getCurrent => _metrics.value;

  static _LayoutMetricBloc _instance;
  factory _LayoutMetricBloc() {
    return _instance ??= _LayoutMetricBloc._internal();
  }

  _LayoutMetricBloc._internal() {
    WidgetsBinding.instance.addObserver(this);
    getData();
  }

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

  @override
  void addListener(listener) {}

  @override
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {}

  @override
  void removeListener(listener) {}
}

// ignore: must_be_immutable
class SuperLayoutBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, MediaQueryData data) builder;
  final List<double> triggerWidth;
  final List<double> triggerHeight;

  SuperLayoutBuilder(
      {this.triggerWidth = const [],
      this.triggerHeight = const [],
      @required this.builder});

  @override
  _SuperLayoutBuilderState createState() => _SuperLayoutBuilderState();
}

class _SuperLayoutBuilderState extends State<SuperLayoutBuilder> {
  static final _LayoutMetricBloc bloc = _LayoutMetricBloc();
  StreamSubscription<MediaQueryData> listener;
  MediaQueryData lastTrigger = bloc.getCurrent;
  double lastWidth = bloc.getCurrent.size.width;
  double lastHeight = bloc.getCurrent.size.height;
  SuperLayoutBuilder get w => widget;

  @override
  void initState() {
    super.initState();
    listener = bloc.outStreamMetrics.listen((e) {
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
