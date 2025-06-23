import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/temperature_monitor_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/history_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
  static const String temperatureMonitor = '/temperature-monitor';
  static const String settings = '/settings';
  static const String history = '/history';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => SplashScreen(),
      home: (context) => HomeScreen(),
      temperatureMonitor: (context) => TemperatureMonitorScreen(),
      settings: (context) => SettingsScreen(),
      history: (context) => HistoryScreen(),
    };
  }
}
