import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:mealknight/widgets/states/empty.state.dart';
import 'package:mealknight/widgets/states/loading.shimmer.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomListView extends StatelessWidget {
  final ScrollController? scrollController;
  final Widget? title;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget? emptyWidget;
  final List<dynamic> dataSet;
  final bool isLoading;
  final bool hasError;
  final bool justList;
  final bool reversed;
  final bool noScrollPhysics;
  final Axis scrollDirection;
  final EdgeInsets? padding;
  final Widget Function(BuildContext, int) itemBuilder;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final bool canRefresh;
  final RefreshController? refreshController;
  final Function? onRefresh;
  final Function? onLoading;
  final bool canPullUp;

  const CustomListView({
    required this.dataSet,
    this.scrollController,
    this.title,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.isLoading = false,
    this.hasError = false,
    this.justList = true,
    this.reversed = false,
    this.noScrollPhysics = false,
    this.scrollDirection = Axis.vertical,
    required this.itemBuilder,
    this.separatorBuilder,
    this.padding,
    this.canRefresh = false,
    this.refreshController,
    this.onRefresh,
    this.onLoading,
    this.canPullUp = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.justList
        ? _getBody(context)
        : VStack(
      [
        this.title ?? UiSpacer.emptySpace(),
        _getBody(context),
      ],
      crossAlignment: CrossAxisAlignment.start,
    );
  }

  Widget _getBody(BuildContext context) {
    final contentBody = this.isLoading
        ? this.loadingWidget ?? LoadingShimmer()
        : this.hasError
        ? this.errorWidget ?? EmptyState(description: "There is an error")
        : (this.dataSet.isEmpty)
        ? this.emptyWidget ?? UiSpacer.emptySpace()
        : this.justList
        ? _getListView(context)
        : Expanded(
      child: _getListView(context),
    );

    return this.canRefresh
        ? SmartRefresher(
      scrollDirection: this.scrollDirection,
      enablePullDown: true,
      enablePullUp: canPullUp,
      controller: this.refreshController!,
      onRefresh: this.onRefresh != null ? () => this.onRefresh!() : null,
      onLoading: this.onLoading != null ? () => this.onLoading!() : null,
      child: contentBody,
    )
        : contentBody;
  }

  Widget _getListView(BuildContext context) {
    return ListView.separated(
      controller: this.scrollController,
      padding: this.padding ?? EdgeInsets.zero,
      shrinkWrap: true,
      reverse: this.reversed,
      physics: this.noScrollPhysics ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
      scrollDirection: this.scrollDirection,
      itemBuilder: this.itemBuilder,
      itemCount: this.dataSet.length,
      separatorBuilder: this.separatorBuilder ??
              (context, index) => this.scrollDirection == Axis.vertical
              ? UiSpacer.verticalSpace()
              : UiSpacer.horizontalSpace(),
    );
  }
}
