// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:mealknight/constants/app_routes.dart';
// import 'package:mealknight/models/order.dart';
// import 'package:mealknight/requests/order.request.dart';
// import 'package:mealknight/services/app.service.dart';
// import 'package:mealknight/view_models/payment.view_model.dart';
// import 'package:mealknight/views/pages/order/taxi_order_details.page.dart';
// import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
//
// class OrdersViewModel extends PaymentViewModel {
//   OrdersViewModel(BuildContext context) {
//     viewContext = context;
//   }
//
//   OrderRequest orderRequest = OrderRequest();
//   List<Order> orders = [];
//
//   int queryPage = 1;
//   RefreshController refreshController = RefreshController();
//   StreamSubscription? homePageChangeStream;
//   StreamSubscription? refreshOrderStream;
//
//   void initialise() async {
//     await fetchMyOrders();
//
//     homePageChangeStream = AppService().homePageIndex.stream.listen(
//       (index) {
//         fetchMyOrders();
//       },
//     );
//
//     refreshOrderStream = AppService().refreshAssignedOrders.listen((refresh) {
//       if (refresh) {
//         print("Tharee");
//         fetchMyOrders();
//       }
//     });
//   }
//
//   //
//   dispose() {
//     super.dispose();
//     homePageChangeStream?.cancel();
//     refreshOrderStream?.cancel();
//   }
//
//   //
//   fetchMyOrders({bool initialLoading = true}) async {
//     if (initialLoading) {
//       setBusy(true);
//       refreshController.refreshCompleted();
//       queryPage = 1;
//     } else {
//       queryPage++;
//     }
//
//     try {
//       final mOrders = await orderRequest.getOrders(page: queryPage);
//       if (!initialLoading) {
//         orders.addAll(mOrders);
//         refreshController.loadComplete();
//         print("My Orders: ${mOrders}");
//       } else {
//         orders = mOrders;
//       }
//       clearErrors();
//     } catch (error) {
//       print("Order Error ==> $error");
//       setError(error);
//     }
//
//     setBusy(false);
//   }
//
//   refreshDataSet() {
//     initialise();
//   }
//
//   openOrderDetails(Order order) async {
//     //
//     if (order.taxiOrder != null) {
//       await Navigator.push(
//           viewContext,
//           MaterialPageRoute(
//             builder: (context) => TaxiOrderDetailPage(order: order),
//           ));
//
//       return;
//     }
//
//     final result = await Navigator.of(viewContext).pushNamed(
//       AppRoutes.orderDetailsRoute,
//       arguments: order,
//     );
//
//     //
//     if (result != null && (result is Order || result is bool)) {
//       if (result is Order) {
//         final orderIndex = orders.indexWhere((e) => e.id == result.id);
//         orders[orderIndex] = result;
//         notifyListeners();
//       } else {
//         fetchMyOrders();
//       }
//     }
//   }
//
//   void openLogin() async {
//     await Navigator.of(viewContext).pushNamed(AppRoutes.loginRoute);
//     notifyListeners();
//     fetchMyOrders();
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_routes.dart';
import 'package:mealknight/models/order.dart';
import 'package:mealknight/requests/order.request.dart';
import 'package:mealknight/services/app.service.dart';
import 'package:mealknight/view_models/payment.view_model.dart';
import 'package:mealknight/views/pages/order/taxi_order_details.page.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class OrdersViewModel extends PaymentViewModel {
  OrdersViewModel(BuildContext context) {
    viewContext = context;
  }

  OrderRequest orderRequest = OrderRequest();
  List<Order> orders = [];

  int queryPage = 1;
  RefreshController refreshController = RefreshController();
  StreamSubscription? homePageChangeStream;
  StreamSubscription? refreshOrderStream;

  void initialise() async {
    await fetchMyOrders();

    homePageChangeStream = AppService().homePageIndex.stream.listen(
          (index) {
        fetchMyOrders();
      },
    );

    refreshOrderStream = AppService().refreshAssignedOrders.listen((refresh) {
      if (refresh) {
        print("Refresh Assigned Orders Triggered");
        fetchMyOrders();
      }
    });
  }

  @override
  dispose() {
    homePageChangeStream?.cancel();
    refreshOrderStream?.cancel();
    super.dispose();
  }

    fetchMyOrders({bool initialLoading = true}) async {
      if (initialLoading==true) {
        setBusy(true);
        refreshController.refreshCompleted();
        queryPage = 1;
      }
      else {
        queryPage++;
      }
      try {
        print("Query Page ====> $queryPage");
        final mOrders = await orderRequest.getOrders(page: queryPage);
        if (initialLoading==false) {
          orders.addAll(mOrders);
          refreshController.loadComplete();

        } else {
          orders = mOrders;
        }
        clearErrors();
      } catch (error) {
        print("Order Error ==> $error");
        setError(error);
        rethrow;
      }
      setBusy(false);
      notifyListeners();

       // Notify listeners to update the UI
    }

  refreshDataSet() {
    initialise();
  }

  openOrderDetails(Order order) async {
    //
    if (order.taxiOrder != null) {
      await Navigator.push(
          viewContext,
          MaterialPageRoute(
            builder: (context) => TaxiOrderDetailPage(order: order),
          ));

      return;
    }

    final result = await Navigator.of(viewContext).pushNamed(
      AppRoutes.orderDetailsRoute,
      arguments: order,
    );

    //
    if (result != null && (result is Order || result is bool)) {
      if (result is Order) {
        final orderIndex = orders.indexWhere((e) => e.id == result.id);
        orders[orderIndex] = result;
        notifyListeners();
      } else {
        fetchMyOrders();
      }
    }
  }

  void openLogin() async {
    await Navigator.of(viewContext).pushNamed(AppRoutes.loginRoute);
    notifyListeners();
    fetchMyOrders();
  }
}

