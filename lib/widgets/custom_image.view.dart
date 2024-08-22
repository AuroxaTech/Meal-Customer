import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_images.dart';
import 'package:mealknight/views/shared/full_image_preview.page.dart';
import 'package:mealknight/widgets/busy_indicator.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomImage extends StatefulWidget {
  const CustomImage({
    required this.imageUrl,
    this.height = Vx.dp40,
    this.width,
    this.boxFit,
    this.canZoom = false,
    super.key,
  });

  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit? boxFit;
  final bool canZoom;

  @override
  State<CustomImage> createState() => _CustomImageState();
}

class _CustomImageState extends State<CustomImage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      errorWidget: (context, imageUrl, _) => Image.asset(
        AppImages.appLogo,
        fit: widget.boxFit ?? BoxFit.cover,
      ),
      fit: widget.boxFit ?? BoxFit.cover,
      progressIndicatorBuilder: (context, imageURL, progress) =>
          const BusyIndicator().centered(),
    )
        .h(widget.height ?? Vx.dp48)
        .w(widget.width ?? context.percentWidth)
        .onInkTap(widget.canZoom
            ? () {
                //if zooming is allowed
                if (widget.canZoom) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullImagePreviewPage(
                          widget.imageUrl,
                          boxFit: BoxFit.contain,
                        ),
                      ));
                }
              }
            : null);
  }

  @override
  bool get wantKeepAlive => true;
}
