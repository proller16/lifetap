import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class PanicButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const PanicButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  State<PanicButton> createState() => _PanicButtonState();
}

class _PanicButtonState extends State<PanicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  late Animation<double> _scaleAnim;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
    _opacityAnim = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isLoading
          ? null
          : () {
              HapticFeedback.heavyImpact();
              widget.onPressed();
            },
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow ring
              Transform.scale(
                scale: _scaleAnim.value + 0.18,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.emergencyRed
                        .withOpacity(_opacityAnim.value * 0.3),
                  ),
                ),
              ),
              // Middle ring
              Transform.scale(
                scale: _scaleAnim.value + 0.08,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.emergencyRed
                        .withOpacity(_opacityAnim.value * 0.5),
                  ),
                ),
              ),
              // Main button
              Transform.scale(
                scale: _scaleAnim.value,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [
                        Color(0xFFEF5350),
                        AppTheme.emergencyRed,
                        AppTheme.emergencyRedDark,
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.emergencyRed.withOpacity(0.6),
                        blurRadius: 30,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: widget.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.warning_rounded,
                              color: Colors.white,
                              size: 56,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'SOS',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 4,
                                    fontSize: 28,
                                  ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
