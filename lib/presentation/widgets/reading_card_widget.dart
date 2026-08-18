import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/text_styles.dart';
import '../../core/constants/reading_types.dart';

/// A reading card for the home screen grid.
/// Shows icon, name, brief description with accent color and hover effect.
class ReadingCardWidget extends StatefulWidget {
  final ReadingType readingType;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final int index;

  const ReadingCardWidget({
    super.key,
    required this.readingType,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.index,
  });

  @override
  State<ReadingCardWidget> createState() => _ReadingCardWidgetState();
}

class _ReadingCardWidgetState extends State<ReadingCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _isPressed = true);
          _controller.forward();
        },
        onTapUp: (_) {
          setState(() => _isPressed = false);
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
          _controller.reverse();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isPressed
                  ? widget.readingType.accentColor
                  : widget.readingType.accentColor.withValues(alpha: 0.3),
              width: _isPressed ? 1.5 : 1,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.backgroundCardLight.withValues(alpha: 0.5),
                AppColors.backgroundCard.withValues(alpha: 0.8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: widget.readingType.accentColor.withValues(alpha: 0.14),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon with accent glow
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: widget.readingType.accentColor.withValues(alpha: 0.12),
                    border: Border.all(
                      color: widget.readingType.accentColor.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    widget.readingType.icon,
                    color: widget.readingType.accentColor,
                    size: 22,
                  ),
                ),
                const Spacer(),
                // Title
                Text(
                  widget.title,
                  style: AppTextStyles.cardTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Subtitle
                Text(
                  widget.subtitle,
                  style: AppTextStyles.cardSubtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
