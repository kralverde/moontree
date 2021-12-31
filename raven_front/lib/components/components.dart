//import 'package:flutter/material.dart';

import 'alerts.dart';
import 'buttons.dart';
import 'headers.dart';
import 'icons.dart';
import 'empty.dart';
import 'routes.dart';
import 'status.dart';
import 'text.dart';
import 'styles/buttons.dart';

class components {
  static AlertComponents alerts = AlertComponents();
  static ButtonComponents buttons = ButtonComponents();
  static ButtonStyleComponents buttonStyles = ButtonStyleComponents();
  static IconComponents icons = IconComponents();
  static TextComponents text = TextComponents();
  static AppLifecycleReactor status = AppLifecycleReactor();
  static EmptyComponents empty = EmptyComponents();
  static HeaderComponents headers = HeaderComponents();
  //static final RouteObserver<PageRoute> routeObserver =
  //    RouteObserver<PageRoute>();
  // handled by navigator
  static final RouteStack navigator = RouteStack();
}
