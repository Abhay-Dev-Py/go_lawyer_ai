import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 650 &&
      MediaQuery.of(context).size.width < 1100;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    if (size.width >= 1100 && desktop != null) {
      return desktop!;
    }

    if (size.width >= 650 && tablet != null) {
      return tablet!;
    }

    return mobile;
  }
}

// Extension methods for responsive values
extension ResponsiveExtension on num {
  double w(BuildContext context) =>
      MediaQuery.of(context).size.width * (this / 100);

  double h(BuildContext context) =>
      MediaQuery.of(context).size.height * (this / 100);

  double sp(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final baseSize = this;
    if (width > 1100) return baseSize * 1.2; // Desktop
    if (width > 650) return baseSize * 1.1; // Tablet
    return baseSize.toDouble(); // Mobile
  }

  EdgeInsets get all => EdgeInsets.all(toDouble());
  EdgeInsets get horizontal => EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get vertical => EdgeInsets.symmetric(vertical: toDouble());
  EdgeInsets get left => EdgeInsets.only(left: toDouble());
  EdgeInsets get right => EdgeInsets.only(right: toDouble());
  EdgeInsets get top => EdgeInsets.only(top: toDouble());
  EdgeInsets get bottom => EdgeInsets.only(bottom: toDouble());
}
