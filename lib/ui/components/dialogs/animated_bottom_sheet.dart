import 'package:flutter/material.dart';

/// Animated Bottom Sheet Content Wrapper
/// Provides smooth slide-up + fade animation for bottom sheet content
/// Optimized for 60 FPS performance
class AnimatedBottomSheetContent extends StatefulWidget {
  final Widget child;
  
  const AnimatedBottomSheetContent({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedBottomSheetContent> createState() => _AnimatedBottomSheetContentState();
}

class _AnimatedBottomSheetContentState extends State<AnimatedBottomSheetContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1), // Slide up from 10% down
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    // Start animation immediately
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
