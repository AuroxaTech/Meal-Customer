import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/app_colors.dart';

class BannerListItem extends StatelessWidget {
  const BannerListItem({
    required this.imageUrl,
    this.onPressed,
    this.radius = 4,
    this.noMargin = false,
    super.key,
  });

  final String imageUrl;
  final double radius;
  final bool noMargin;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
            ))
        .onInkTap(onPressed)
        .box
        .withRounded(value: radius)
        .clip(Clip.antiAlias)
        .outerShadow
        .border(width: 3, color: AppColor.primary)
        .color(context.theme.colorScheme.background)
        .make();
  }
}
