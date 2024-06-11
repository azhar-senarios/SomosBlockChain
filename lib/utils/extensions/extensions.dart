import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  Size get screenSize => MediaQuery.of(this).size;

  Brightness get brightness => Theme.of(this).brightness;

  // TODO: Test this later
  T provider<T>() => Provider.of<T>(this, listen: false);

  void unFocus() => FocusScope.of(this).unfocus();

  GoRouter get router => GoRouter.of(this);
}

extension DateTimeExtension on DateTime {
  String toSimpleDate() {
    try {
      final dateFormat = DateFormat('MMM d, yyyy');
      return dateFormat.format(this);
    } catch (e) {
      // TODO inform the backend about the invalid date using crashlytics
      final dateFormat = DateFormat('MMM d, yyyy');
      return dateFormat.format(DateTime.now());
    }
  }

  String formatRelativeDate() {
    final now = DateTime.now();
    final dateTime = this;

    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (dateTime.isAfter(today) || dateTime.isAtSameMomentAs(today)) {
      return 'TODAY';
    } else if (dateTime.isAfter(yesterday)) {
      return 'YESTERDAY';
    }

    return toSimpleDate();
  }

  String toYYYYMMDD() {
    final format = DateFormat('yyyy-MM-dd');

    return format.format(this);
  }
}

extension ContextExtension on BuildContext {
  void popUntilPath(String ancestorPath) {
    while (ModalRoute.of(this)?.settings.name != ancestorPath) {
      if (!canPop()) {
        return;
      }
      pop();
    }
  }
}
