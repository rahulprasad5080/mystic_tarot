import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_colors.dart';
import 'divine_loading_widget.dart';

/// Animated loading widget matching the Divine Readings mockup design.
class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const DivineLoadingWidget(showHeader: false);
  }
}

/// Small shimmer for inline loading.
class InlineLoadingShimmer extends StatelessWidget {
  final double width;
  final double height;

  const InlineLoadingShimmer({
    super.key,
    this.width = double.infinity,
    this.height = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.backgroundCardLight,
      highlightColor: AppColors.primaryBlueLight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
