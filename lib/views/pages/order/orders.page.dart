// import 'package:flutter/material.dart';
// import 'package:mealknight/constants/app_colors.dart';
// import 'package:mealknight/services/order.service.dart';
// import 'package:mealknight/utils/ui_spacer.dart';
// import 'package:mealknight/view_models/orders.vm.dart';
// import 'package:mealknight/widgets/base.page.dart';
// import 'package:mealknight/widgets/custom_list_view.dart';
// import 'package:mealknight/widgets/list_items/order.list_item.dart';
// import 'package:mealknight/widgets/list_items/taxi_order.list_item.dart';
// import 'package:mealknight/widgets/states/empty.state.dart';
// import 'package:mealknight/widgets/states/error.state.dart';
// import 'package:mealknight/widgets/states/order.empty.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:stacked/stacked.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// class OrdersPage extends StatefulWidget {
//   const OrdersPage({super.key});
//
//   @override
//   State<OrdersPage> createState() => _OrdersPageState();
// }
//
// class _OrdersPageState extends State<OrdersPage>
//     with AutomaticKeepAliveClientMixin<OrdersPage>, WidgetsBindingObserver {
//
//   late OrdersViewModel vm;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       vm.fetchMyOrders();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     vm = OrdersViewModel(context);
//     super.build(context);
//     return BasePage(
//       showAppBar: true,
//       title: 'Order History'.tr(),
//       showLeadingAction: true,
//       isLoading: vm.isBusy,
//       elevation: 0,
//       appBarColor: context.theme.colorScheme.background,
//       appBarItemColor: AppColor.primaryColor,
//       backgroundColor: const Color(0xffeefffd),
//       body: SafeArea(
//         child: ViewModelBuilder<OrdersViewModel>.reactive(
//           viewModelBuilder: () => vm,
//           onViewModelReady: (vm) => vm.initialise(),
//           builder: (context, vm, child) {
//             return VStack(
//               [
//                 vm.isAuthenticated()
//                     ? CustomListView(
//                         padding: const EdgeInsets.all(0),
//                         canRefresh: true,
//                         canPullUp: true,
//                         refreshController: vm.refreshController,
//                         onRefresh: vm.fetchMyOrders,
//                         onLoading: () =>
//                             vm.fetchMyOrders(initialLoading: false),
//                         isLoading: vm.isBusy,
//                         dataSet: vm.orders,
//                         hasError: vm.hasError,
//                         errorWidget: LoadingError(
//                           onrefresh: vm.fetchMyOrders,
//                         ),
//                         //
//                         emptyWidget: const EmptyOrder(),
//                         itemBuilder: (context, index) {
//                           //
//                           final order = vm.orders[index];
//                           //for taxi tye of order
//                           if (order.taxiOrder != null) {
//                             return TaxiOrderListItem(
//                               order: order,
//                               orderPressed: () => vm.openOrderDetails(order),
//                             );
//                           }
//                           return OrderListItem(
//                             order: order,
//                             orderPressed: () {
//                               vm.openOrderDetails(order);
//                             },
//                             onPayPressed: () {
//                               OrderService.openOrderPayment(order, vm);
//                             },
//                           );
//                         },
//                         separatorBuilder: (context, index) =>
//                             UiSpacer.verticalSpace(space: 2),
//                       ).expand()
//                     : EmptyState(
//                         auth: true,
//                         showAction: true,
//                         actionPressed: vm.openLogin,
//                       ).py12().centered().expand(),
//               ],
//             ).px20().pOnly(top: Vx.dp20);
//           },
//         ),
//       ),
//     );
//   }
//
//   @override
//   bool get wantKeepAlive => true;
// }

import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/services/order.service.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/view_models/orders.vm.dart';
import 'package:mealknight/widgets/base.page.dart';
import 'package:mealknight/widgets/custom_list_view.dart';
import 'package:mealknight/widgets/list_items/order.list_item.dart';
import 'package:mealknight/widgets/list_items/taxi_order.list_item.dart';
import 'package:mealknight/widgets/states/empty.state.dart';
import 'package:mealknight/widgets/states/error.state.dart';
import 'package:mealknight/widgets/states/order.empty.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../widgets/states/loading.shimmer.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with AutomaticKeepAliveClientMixin<OrdersPage>, WidgetsBindingObserver {

  late OrdersViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = OrdersViewModel(context); // Initialize vm here
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      vm.fetchMyOrders();
    }
  }


  @override
  Widget build(BuildContext context) {
    vm = OrdersViewModel(context);
    super.build(context);
    return BasePage(
      showAppBar: true,
      title: 'Order History'.tr(),
      showLeadingAction: true,
      isLoading: vm.isBusy,
      elevation: 0,
      appBarColor: context.theme.colorScheme.background,
      appBarItemColor: AppColor.primaryColor,
      backgroundColor: const Color(0xffeefffd),
      body: SafeArea(
        child: ViewModelBuilder<OrdersViewModel>.reactive(
          viewModelBuilder: () => vm,
          onViewModelReady: (vm) => vm.initialise(),
          builder: (context, vm, child) {
            return    VStack(
              [
                vm.isAuthenticated()
                    ?vm.isBusy?const LoadingShimmer():
                CustomListView(
                  padding: const EdgeInsets.all(0),
                  canRefresh: true,
                  canPullUp: true,
                  refreshController: vm.refreshController,
                  onRefresh: vm.fetchMyOrders,
                  onLoading: () =>
                      vm.fetchMyOrders(initialLoading: false),
                  isLoading: vm.isBusy,
                  dataSet: vm.orders,
                  hasError: vm.hasError,
                  errorWidget: LoadingError(
                    onrefresh: vm.fetchMyOrders,
                  ),
                  //
                  emptyWidget: const EmptyOrder(),
                  itemBuilder: (context, index) {
                    //
                    final order = vm.orders[index];
                    //for taxi type of order
                    if (order.taxiOrder != null) {
                      return TaxiOrderListItem(
                        order: order,
                        orderPressed: () => vm.openOrderDetails(order),
                      );
                    }
                    return OrderListItem(
                      order: order,
                      orderPressed: () {
                        vm.openOrderDetails(order);
                      },
                      onPayPressed: () {
                        OrderService.openOrderPayment(order, vm);
                      },
                    );
                  },
                  separatorBuilder: (context, index) =>
                      UiSpacer.verticalSpace(space: 2),
                ).expand()
                    : EmptyState(
                  auth: true,
                  showAction: true,
                  actionPressed: vm.openLogin,
                ).py12().centered().expand(),
              ],
            ).px20().pOnly(top: Vx.dp20);
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
