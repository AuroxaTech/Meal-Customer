// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'dart:math' hide log;
// import 'package:awesome_notifications/awesome_notifications.dart' hide NotificationModel;
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firestore_chat/firestore_chat.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:mealknight/constants/app_routes.dart';
// import 'package:mealknight/constants/app_ui_settings.dart';
// import 'package:mealknight/models/notification.dart';
// import 'package:mealknight/models/order.dart';
// import 'package:mealknight/models/product.dart';
// import 'package:mealknight/models/service.dart';
// import 'package:mealknight/models/vendor.dart';
// import 'package:mealknight/requests/order.request.dart';
// import 'package:mealknight/services/app.service.dart';
// import 'package:mealknight/services/chat.service.dart';
// import 'package:mealknight/services/notification.service.dart';
// import 'package:mealknight/views/pages/home/home.page.dart';
// import 'package:mealknight/views/pages/service/service_details.page.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:stacked_services/stacked_services.dart';
// import 'firebase_token.service.dart';
//
// class FirebaseService {
//   NotificationModel? notificationModel;
//   FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
//   Map<String, dynamic>? notificationPayloadData;
//
//   Future<void> setUpFirebaseMessaging() async {
//     // Request for notification permission
//     await firebaseMessaging.requestPermission();
//     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     // Subscribing to all topics
//     firebaseMessaging.subscribeToTopic("all");
//     FirebaseTokenService().handleDeviceTokenSync();
//
//     // On notification tap to bring app back to life
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("onMessageOpenedApp: ${message.data}");
//       saveNewNotification(message);
//       selectNotification("From onMessageOpenedApp");
//       refreshOrdersList(message);
//     });
//
//     // Normal notification listener
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       // Log message data and notification details for debugging
//       print("onMessage - Data: ${message.data}");
//       print("onMessage - Notification: ${message.notification?.title}");
//
//       // Check if message has data payload
//       if (message.data.isNotEmpty) {
//         print("Data message received: ${message.data}");
//
//         // Save and show the notification
//         saveNewNotification(message);
//         showNotification(message);
//         refreshOrdersList(message);
//       } else {
//         print("Received a notification with an empty data payload.");
//       }
//
//       // Check if message has notification payload
//       if (message.notification != null) {
//         print("Notification message received: Title: ${message.notification?.title}, Body: ${message.notification?.body}");
//       }
//     });
//   }
//
//   // Write to notification list
//   void saveNewNotification(RemoteMessage? message, {String? title, String? body}) {
//     print("saveNewNotification called with message: ${message?.data}");
//
//     notificationPayloadData = message?.data;
//     print("notificationPayloadData 1 =====> $notificationPayloadData");
//
//     if (notificationPayloadData == null || (message?.notification == null && message?.data["title"] == null && title == null)) {
//       print("Notification data is null or missing required fields.");
//       return;
//     }
//
//     // Saving the notification
//     notificationModel = NotificationModel();
//     notificationModel!.title = message?.notification?.title ?? title ?? message?.data["title"] ?? "";
//     notificationModel!.body = message?.notification?.body ?? body ?? message?.data["body"] ?? "";
//
//     final imageUrl = message?.data["image"] ?? (Platform.isAndroid ? message?.notification?.android?.imageUrl : message?.notification?.apple?.imageUrl);
//     notificationModel!.image = imageUrl;
//
//     notificationModel!.timeStamp = DateTime.now().millisecondsSinceEpoch;
//
//     // Save the notification
//     NotificationService.addNotification(notificationModel!);
//   }
//
//   //
//   void showNotification(RemoteMessage message) async {
//     print("showNotification called with message: ${message.data}");
//
//     notificationPayloadData = message.data;
//     print("Show Notification Payload Data 2 ====> $notificationPayloadData");
//     print("Received message: ${message.toString()}");
//     if (message.data.isNotEmpty) {
//       notificationPayloadData = Map<String, dynamic>.from(message.data);
//     } else {
//       notificationPayloadData = null;
//     }
//
//     if (message.notification == null && message.data["title"] == null) {
//       print("No title found in the notification.");
//       return;
//     }
//
//     try {
//       String? imageUrl;
//       try {
//         imageUrl = message.data["image"] ?? (Platform.isAndroid ? message.notification?.android?.imageUrl : message.notification?.apple?.imageUrl);
//       } catch (error) {
//         if (kDebugMode) {
//           print("error getting notification image");
//         }
//       }
//
//       if (imageUrl != null) {
//         AwesomeNotifications().createNotification(
//           content: NotificationContent(
//             id: Random().nextInt(20),
//             channelKey: NotificationService.appNotificationChannel().channelKey!,
//             title: message.data["title"] ?? message.notification?.title,
//             body: message.data["body"] ?? message.notification?.body,
//             bigPicture: imageUrl,
//             icon: "resource://mipmap/ic_launcher",
//             notificationLayout: NotificationLayout.BigPicture,
//             payload: Map<String, String>.from(message.data),
//           ),
//         );
//       } else {
//         AwesomeNotifications().createNotification(
//           content: NotificationContent(
//             id: Random().nextInt(20),
//             channelKey: NotificationService.appNotificationChannel().channelKey!,
//             title: message.data["title"] ?? message.notification?.title,
//             body: message.data["body"] ?? message.notification?.body,
//             icon: "resource://mipmap/ic_launcher",
//             notificationLayout: NotificationLayout.Default,
//             payload: Map<String, String>.from(message.data),
//           ),
//         );
//       }
//     } catch (error) {
//       if (kDebugMode) {
//         print("Notification Show error ===> $error");
//       }
//     }
//     print("Show Notification Payload Data: $notificationPayloadData");
//   }
//
//   // Handle on notification selected
//   Future<void> selectNotification(String? payload) async {
//     print("selectNotification called with payload: $payload");
//     print("Current notificationPayloadData: $notificationPayloadData");
//     print("payload =====> $payload");
//     if (payload == null) {
//       return;
//     }
//     try {
//       log("NotificationPayload ==> ${jsonEncode(notificationPayloadData)}");
//       if (notificationPayloadData is Map<String, dynamic>) {
//         final isChat = notificationPayloadData!.containsKey("is_chat");
//         final isOrder = notificationPayloadData!.containsKey("is_order") &&
//             (notificationPayloadData?["is_order"].toString() == "1" ||
//                 (notificationPayloadData?["is_order"] is bool &&
//                     notificationPayloadData?["is_order"]));
//
//         final hasProduct = notificationPayloadData!.containsKey("product");
//         final hasVendor = notificationPayloadData!.containsKey("vendor");
//         final hasService = notificationPayloadData!.containsKey("service");
//
//         if (isChat) {
//           dynamic user = jsonDecode(notificationPayloadData!['user']);
//           dynamic peer = jsonDecode(notificationPayloadData!['peer']);
//           String chatPath = notificationPayloadData!['path'];
//
//           Map<String, PeerUser> peers = {
//             '${user['id']}': PeerUser(
//               id: '${user['id']}',
//               name: "${user['name']}",
//               image: "${user['photo']}",
//             ),
//             '${peer['id']}': PeerUser(
//               id: '${peer['id']}',
//               name: "${peer['name']}",
//               image: "${peer['photo']}",
//             ),
//           };
//
//           final peerRole = peer["role"];
//
//           final chatEntity = ChatEntity(
//             onMessageSent: ChatService.sendChatMessage,
//             mainUser: peers['${user['id']}']!,
//             peers: peers,
//             path: chatPath,
//             title: peer["role"] == null
//                 ? "${"Chat with".tr()} ${peer['name']}"
//                 : peerRole == 'vendor'
//                 ? "Chat with vendor".tr()
//                 : "Chat with driver".tr(),
//             supportMedia: AppUISettings.canCustomerChatSupportMedia,
//           );
//
//           if (StackedService.navigatorKey?.currentContext != null) {
//             Navigator.of(StackedService.navigatorKey!.currentContext!).pushNamed(
//               AppRoutes.chatRoute,
//               arguments: chatEntity,
//             );
//           }
//         }
//         // Order
//         else if (isOrder) {
//           try {
//             int orderId = int.parse("${notificationPayloadData!['order_id']}");
//             Order order = await OrderRequest().getOrderDetails(id: orderId);
//             print("order Id =====> $order");
//
//             if (StackedService.navigatorKey?.currentContext != null) {
//               Navigator.of(StackedService.navigatorKey!.currentContext!).pushNamed(
//                 AppRoutes.orderDetailsRoute,
//                 arguments: order,
//               );
//             }
//           } catch (error) {
//             if (AppService().navigatorKey.currentContext != null) {
//               await Navigator.of(AppService().navigatorKey.currentContext!).push(
//                 MaterialPageRoute(
//                   builder: (_) => HomePage(),
//                 ),
//               );
//               AppService().changeHomePageIndex();
//             }
//           }
//         }
//         // Vendor type of notification
//         else if (hasVendor) {
//           final vendor = Vendor.fromJson(
//             jsonDecode(notificationPayloadData?['vendor']),
//           );
//
//           if (StackedService.navigatorKey?.currentContext != null) {
//             Navigator.of(StackedService.navigatorKey!.currentContext!).pushNamed(
//               AppRoutes.vendorDetails,
//               arguments: vendor,
//             );
//           }
//         }
//         // Product type of notification
//         else if (hasProduct) {
//           final product = Product.fromJson(
//             jsonDecode(notificationPayloadData?['product']),
//           );
//
//           if (StackedService.navigatorKey?.currentContext != null) {
//             Navigator.of(StackedService.navigatorKey!.currentContext!).pushNamed(
//               AppRoutes.product,
//               arguments: product,
//             );
//           }
//         }
//         // Service type of notification
//         else if (hasService) {
//           final service = Service.fromJson(
//             jsonDecode(notificationPayloadData!['service']),
//           );
//
//           if (StackedService.navigatorKey?.currentContext != null) {
//             Navigator.of(StackedService.navigatorKey!.currentContext!).push(
//               MaterialPageRoute(
//                 builder: (_) => ServiceDetailsPage(
//                   service,
//                 ),
//               ),
//             );
//           }
//         }
//         // Regular notifications
//         else {
//           if (StackedService.navigatorKey?.currentContext != null) {
//             Navigator.of(StackedService.navigatorKey!.currentContext!).pushNamed(
//               AppRoutes.notificationDetailsRoute,
//               arguments: notificationModel,
//             );
//           }
//         }
//       } else {
//         if (StackedService.navigatorKey?.currentContext != null) {
//           Navigator.of(StackedService.navigatorKey!.currentContext!).pushNamed(
//             AppRoutes.notificationDetailsRoute,
//             arguments: notificationModel,
//           );
//         }
//       }
//     } catch (error) {
//       if (kDebugMode) {
//         print("Error opening Notification ==> $error");
//       }
//     }
//   }
//
//   // Refresh orders list if the notification is about assigned order
//   void refreshOrdersList(RemoteMessage message) async {
//     if (message.data["is_order"] != null) {
//       await Future.delayed(const Duration(seconds: 3));
//       AppService().refreshAssignedOrders.add(true);
//     }
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' hide log;
import 'package:awesome_notifications/awesome_notifications.dart'
    hide NotificationModel;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firestore_chat/firestore_chat.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_routes.dart';
import 'package:mealknight/constants/app_ui_settings.dart';
import 'package:mealknight/models/notification.dart';
import 'package:mealknight/models/order.dart';
import 'package:mealknight/models/product.dart';
import 'package:mealknight/models/service.dart';
import 'package:mealknight/models/vendor.dart';
import 'package:mealknight/requests/order.request.dart';
import 'package:mealknight/services/app.service.dart';
import 'package:mealknight/services/chat.service.dart';
import 'package:mealknight/services/notification.service.dart';
import 'package:mealknight/views/pages/home/home.page.dart';
import 'package:mealknight/views/pages/service/service_details.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked_services/stacked_services.dart';
import 'firebase_token.service.dart';

class FirebaseService {

  NotificationModel? notificationModel;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  Map<String, dynamic>? notificationPayloadData;

  Future<void> setUpFirebaseMessaging() async {
    // Request for notification permission
    await firebaseMessaging.requestPermission();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Subscribing to all topics
    firebaseMessaging.subscribeToTopic("all");
    FirebaseTokenService().handleDeviceTokenSync();

    // On notification tap to bring app back to life
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp: ${message.data}");
      if (message.data.isNotEmpty) {
        saveNewNotification(message);
        selectNotification(message.data);
      }
      refreshOrdersList(message);
    });

    // Normal notification listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Log message data and notification details for debugging
      print("onMessage - Data: ${message.data}");
      print("onMessage - Notification: ${message.notification?.title}");

      // Check if message has data payload
      if (message.data.isNotEmpty) {
        print("Data message received: ${message.data}");

        // Save and show the notification
        saveNewNotification(message);
        showNotification(message);
        refreshOrdersList(message);
      } else {
        print("Received a notification with an empty data payload.");
      }

      // Check if message has notification payload
      if (message.notification != null) {
        print(
            "Notification message received: Title: ${message.notification?.title}, Body: ${message.notification?.body}");
      }
    });
  }

  // Write to notification list
  void saveNewNotification(RemoteMessage? message,
      {String? title, String? body}) {
    print("saveNewNotification called with message: ${message?.data}");

    notificationPayloadData = message?.data;
    print("notificationPayloadData 1 =====> $notificationPayloadData");

    if (notificationPayloadData == null ||
        (message?.notification == null &&
            message?.data["title"] == null &&
            title == null)) {
      print("Notification data is null or missing required fields.");
      return;
    }

    // Saving the notification
    notificationModel = NotificationModel();
    notificationModel!.title =
        message?.notification?.title ?? title ?? message?.data["title"] ?? "";
    notificationModel!.body =
        message?.notification?.body ?? body ?? message?.data["body"] ?? "";

    final imageUrl = message?.data["image"] ??
        (Platform.isAndroid
            ? message?.notification?.android?.imageUrl
            : message?.notification?.apple?.imageUrl);
    notificationModel!.image = imageUrl;

    notificationModel!.timeStamp = DateTime.now().millisecondsSinceEpoch;

    // Save the notification
    NotificationService.addNotification(notificationModel!);
  }

  //
  void showNotification(RemoteMessage message) async {
    print("showNotification called with message: ${message.data}");

    notificationPayloadData = message.data;
    print("Show Notification Payload Data 2 ====> $notificationPayloadData");
    print("Received message: ${message.toString()}");
    if (message.data.isNotEmpty) {
      notificationPayloadData = Map<String, dynamic>.from(message.data);
    } else {
      notificationPayloadData = null;
    }

    if (message.notification == null && message.data["title"] == null) {
      print("No title found in the notification.");
      return;
    }

    try {
      String? imageUrl;
      try {
        imageUrl = message.data["image"] ??
            (Platform.isAndroid
                ? message.notification?.android?.imageUrl
                : message.notification?.apple?.imageUrl);
      } catch (error) {
        if (kDebugMode) {
          print("error getting notification image");
        }
      }

      if (imageUrl != null) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: Random().nextInt(20),
            channelKey:
                NotificationService.appNotificationChannel().channelKey!,
            title: message.data["title"] ?? message.notification?.title,
            body: message.data["body"] ?? message.notification?.body,
            bigPicture: imageUrl,
            icon: "resource://mipmap/ic_launcher",
            notificationLayout: NotificationLayout.BigPicture,
            payload: Map<String, String>.from(message.data),
          ),
        );
      } else {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: Random().nextInt(20),
            channelKey:
                NotificationService.appNotificationChannel().channelKey!,
            title: message.data["title"] ?? message.notification?.title,
            body: message.data["body"] ?? message.notification?.body,
            icon: "resource://mipmap/ic_launcher",
            notificationLayout: NotificationLayout.Default,
            payload: Map<String, String>.from(message.data),
          ),
        );
      }
    } catch (error) {
      if (kDebugMode) {
        print("Notification Show error ===> $error");
      }
    }
    print("Show Notification Payload Data: $notificationPayloadData");
  }

  // Handle on notification selected
  Future<void> selectNotification(Map<String, dynamic>? payload) async {
    print("selectNotification called with payload: $payload");
    print("Current notificationPayloadData: $notificationPayloadData");
    print("payload =====> $payload");
    if (payload == null || payload.isEmpty) {
      return;
    }
    try {
      log("NotificationPayload ==> ${jsonEncode(payload)}");
      notificationPayloadData = payload;
      if (notificationPayloadData is Map<String, dynamic>) {
        final isChat = notificationPayloadData!.containsKey("is_chat");
        final isOrder = notificationPayloadData!.containsKey("is_order") &&
            (notificationPayloadData?["is_order"].toString() == "1" ||
                (notificationPayloadData?["is_order"] is bool &&
                    notificationPayloadData?["is_order"]));

        final hasProduct = notificationPayloadData!.containsKey("product");
        final hasVendor = notificationPayloadData!.containsKey("vendor");
        final hasService = notificationPayloadData!.containsKey("service");

        if (isChat) {
          dynamic user = jsonDecode(notificationPayloadData!['user']);
          dynamic peer = jsonDecode(notificationPayloadData!['peer']);
          String chatPath = notificationPayloadData!['path'];

          Map<String, PeerUser> peers = {
            '${user['id']}': PeerUser(
              id: '${user['id']}',
              name: "${user['name']}",
              image: "${user['photo']}",
            ),
            '${peer['id']}': PeerUser(
              id: '${peer['id']}',
              name: "${peer['name']}",
              image: "${peer['photo']}",
            ),
          };

          final peerRole = peer["role"];

          final chatEntity = ChatEntity(
            onMessageSent: ChatService.sendChatMessage,
            mainUser: peers['${user['id']}']!,
            peers: peers,
            path: chatPath,
            title: peer["role"] == null
                ? "${"Chat with".tr()} ${peer['name']}"
                : peerRole == 'vendor'
                    ? "Chat with vendor".tr()
                    : "Chat with driver".tr(),
            supportMedia: AppUISettings.canCustomerChatSupportMedia,
          );

          if (StackedService.navigatorKey?.currentContext != null) {
            Navigator.of(StackedService.navigatorKey!.currentContext!)
                .pushNamed(
              AppRoutes.chatRoute,
              arguments: chatEntity,
            );
          }
        }
        // Order
        else if (isOrder) {
          try {
            int orderId = int.parse("${notificationPayloadData!['order_id']}");
            Order order = await OrderRequest().getOrderDetails(id: orderId);
            print("order Id =====> $order");

            if (StackedService.navigatorKey?.currentContext != null) {
              Navigator.of(StackedService.navigatorKey!.currentContext!)
                  .pushNamed(
                AppRoutes.orderDetailsRoute,
                arguments: order,
              );
            }
          } catch (error) {
            if (AppService().navigatorKey.currentContext != null) {
              await Navigator.of(AppService().navigatorKey.currentContext!)
                  .push(
                MaterialPageRoute(
                  builder: (_) => HomePage(),
                ),
              );
              AppService().changeHomePageIndex();
            }
          }
        }
        // Vendor type of notification
        else if (hasVendor) {
          final vendor = Vendor.fromJson(
            jsonDecode(notificationPayloadData?['vendor']),
          );

          if (StackedService.navigatorKey?.currentContext != null) {
            Navigator.of(StackedService.navigatorKey!.currentContext!)
                .pushNamed(
              AppRoutes.vendorDetails,
              arguments: vendor,
            );
          }
        }
        // Product type of notification
        else if (hasProduct) {
          final product = Product.fromJson(
            jsonDecode(notificationPayloadData?['product']),
          );

          if (StackedService.navigatorKey?.currentContext != null) {
            Navigator.of(StackedService.navigatorKey!.currentContext!)
                .pushNamed(
              AppRoutes.product,
              arguments: product,
            );
          }
        }
        // Service type of notification
        else if (hasService) {
          final service = Service.fromJson(
            jsonDecode(notificationPayloadData!['service']),
          );

          if (StackedService.navigatorKey?.currentContext != null) {
            Navigator.of(StackedService.navigatorKey!.currentContext!).push(
              MaterialPageRoute(
                builder: (_) => ServiceDetailsPage(
                  service,
                ),
              ),
            );
          }
        }
        // Regular notifications
        else {
          if (StackedService.navigatorKey?.currentContext != null) {
            Navigator.of(StackedService.navigatorKey!.currentContext!)
                .pushNamed(
              AppRoutes.notificationDetailsRoute,
              arguments: notificationModel,
            );
          }
        }
      } else {
        if (StackedService.navigatorKey?.currentContext != null) {
          Navigator.of(StackedService.navigatorKey!.currentContext!).pushNamed(
            AppRoutes.notificationDetailsRoute,
            arguments: notificationModel,
          );
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error opening Notification ==> $error");
      }
    }
  }

  // Refresh orders list if the notification is about assigned order
  void refreshOrdersList(RemoteMessage message) async {
    if (message.data["is_order"] != null) {
      await Future.delayed(const Duration(seconds: 3));
      AppService().refreshAssignedOrders.add(true);
    }
  }
}
