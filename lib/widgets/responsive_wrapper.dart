import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Constrains content to a mobile-width on web/desktop so the app
/// looks correct on large screens, centered with a subtle card shadow.
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  const ResponsiveWrapper({super.key, required this.child});

  static const double _maxWidth = 480;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return child;

    return Scaffold(
      backgroundColor: const Color(0xFFE8EAF6),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: _maxWidth),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 40,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRect(child: child),
        ),
      ),
    );
  }
}
