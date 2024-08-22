import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/constants/app_font.dart';
import 'package:mealknight/models/order.dart';
import 'package:mealknight/services/location.service.dart';
import 'package:mealknight/utils/utils.dart';
import 'package:mealknight/view_models/order_tracking.vm.dart';
import 'package:mealknight/widgets/base.page.dart';
import 'package:mealknight/widgets/buttons/custom_button.dart';
import 'package:mealknight/widgets/currency_hstack.dart';
import 'package:mealknight/widgets/custom_image.view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderTrackingPage extends StatelessWidget {
   OrderTrackingPage({
    required this.order,
    Key? key,
  }) : super(key: key);

  //
  final Order order;

  final currencySymbol = AppStrings.currencySymbol;
  @override
  Widget build(BuildContext context) {


    //
    return ViewModelBuilder<OrderTrackingViewModel>.reactive(
      viewModelBuilder: () => OrderTrackingViewModel(context, order),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          title: "Order Tracker".tr(),
          showAppBar: true,
          showLeadingAction: true,
          actions: [
            HStack([
              Image.asset("assets/images/icons/helpicon.png",height: 25,width: 25,),
              "Help".text.sm.semiBold.color(AppColor.primaryColor).fontFamily(AppFonts.appFont).make()
            ]).px8().box.withRounded().border(width: 2,color: AppColor.primaryColor).make().py12().px(10)
          ],
          isLoading: vm.isBusy,
          elevation: 0,
          appBarColor: context.theme.colorScheme.background,
          appBarItemColor: AppColor.primaryColor,
          backgroundColor: Color(0xffeefffd),
          body: ListView(children: [
            VStack([
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    "Heading to the store"
                        .tr()
                        .text
                        .lg.semiBold
                        .fontFamily(AppFonts.appFont)
                        .color(AppColor.primaryColor)
                        .make()
                        .py2()
                        .px8(),
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/icons/Clock.png',
                              height: 20,
                            ),
                            "30 min"
                                .text
                                .fontFamily(AppFonts.appFont)
                                .sm
                                .medium
                                .color(AppColor.primary)
                                .make()
                                .pOnly(right: 5),
                          ],
                        ).px12()
                            .py2()
                  ]),

                 Row(
                   children: [
                     "Order Total:"
                         .text
                         .fontFamily(AppFonts.appFont)
                         .sm
                         .medium
                         .color(AppColor.primary)
                         .make()
                         .pOnly(right: 5),
                     CurrencyHStack(
                       [
                         "53.73"
                             .text
                             .fontFamily(AppFonts.appFont)
                             .color(AppColor.primaryColor)
                             .letterSpacing(1.5)
                             .sm
                             .medium
                             .make(),
                         currencySymbol.text
                             .fontFamily(AppFonts.appFont)
                             .color(AppColor.primaryColor)
                             .sm
                             .medium
                             .make(),
                       ],
                     ),
                   ],
                 )
                ],
              ),
              HStack(
                [
                  //driver profile
                  Stack(
                    children: [
                      CustomImage(
                        imageUrl: order.driver?.photo ?? "",
                      )
                          .wh(Vx.dp64, Vx.dp64)
                          .box
                          .roundedFull
                          .clip(Clip.antiAlias)
                          .make(),
                      Positioned(top:0,right:0,child: Image.asset("assets/images/icons/Chat balloon 1.png",height: 15,width: 15,))
                    ],
                  ),

                  //
                  VStack(
                    [
                      "${order.driver?.name ?? "Tom"} is on the way to pickup your order".text.xl.color(AppColor.primaryColor).make().expand().box.make(),
                      Row(
                        children: [
                          Row(
                            children: [
                              "Tip:"
                                  .text
                                  .fontFamily(AppFonts.appFont)
                                  .sm
                                  .medium
                                  .color(AppColor.primary)
                                  .make()
                                  .pOnly(right: 5),
                              CurrencyHStack(
                                [
                                  "3.00"
                                      .text
                                      .fontFamily(AppFonts.appFont)
                                      .color(AppColor.primaryColor)
                                      .letterSpacing(1.5)
                                      .sm
                                      .medium
                                      .make(),
                                  currencySymbol.text
                                      .fontFamily(AppFonts.appFont)
                                      .color(AppColor.primaryColor)
                                      .sm
                                      .medium
                                      .make(),
                                ],
                              ),
                            ],
                          ),
                          HStack([
                            "Add tip".text.sm.semiBold.color(AppColor.primaryColor).fontFamily(AppFonts.appFont).make()
                          ]).px8().box.withRounded().border(width: 2,color: AppColor.primaryColor).make().py12().px(10)
                        ],
                      )
                    ],
                  ).px12().expand(),

                  //call
                  Visibility(
                    visible: false,
                    child: CustomButton(
                      icon: FlutterIcons.phone_call_fea,
                      iconColor: Colors.white,
                      title: "",
                      color: AppColor.primaryColor,
                      shapeRadius: Vx.dp24,
                      onPressed: vm.callDriver,
                    ).wh(Vx.dp64, Vx.dp40).p12(),
                  ),
                ],
              )
                  .box
                  .make()
                  .wFull(context)
                  .p8(),
            ]).box.withRounded().color(Colors.white).withRounded().border(width: 2,color: AppColor.primaryColor).make().centered().py8().px20(),
            ClipRRect(

              child: GoogleMap(
            initialCameraPosition: CameraPosition(
            target: LatLng(
            LocationService.currenctAddress?.coordinates?.latitude ??
            0.00,
            LocationService.currenctAddress?.coordinates?.longitude ??
            0.00,
            ),
            zoom: 50,
            ),
            padding: EdgeInsets.only(bottom: Vx.dp64 * 2),
            myLocationEnabled: true,
            markers: vm.mapMarkers ?? Set<Marker>(),
            polylines: Set<Polyline>.of(vm.polylines.values),
            onMapCreated: vm.setMapController,
            ),

              borderRadius: BorderRadius.circular(15.0),
            ).h(220).w(context.percentWidth*90)
                .box
                .clip(Clip.antiAlias)
                .withRounded(value: 15.0)
                .make().px20(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    "Karakoram Restaurant"
                        .tr()
                        .text
                        .lg
                        .fontFamily(AppFonts.appFont)
                        .semiBold
                        .color(AppColor.primaryColor)
                        .make(),
                    "#a6yy42"
                        .tr()
                        .text
                        .lg
                        .fontFamily(AppFonts.appFont)
                        .color(Utils.isDark(AppColor.deliveryColor)
                        ? Colors.white
                        : AppColor.primaryColor)
                        .make()

                  ],
                ),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      Image.asset(
                        "assets/images/icons/location 1.png",
                        height: 30,
                      ),
                      10.widthBox,
                      Image.asset(
                        "assets/images/icons/Telephone 1.png",
                        height: 30,
                      )
                    ]),
              ],
            )
                .px20().py8(),

            ProductList(),
            Divider(
              thickness: 2,color: Colors.black,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                "Subtotal"
                    .tr()
                    .text
                    .lg
                    .fontFamily(AppFonts.appFont)
                    .color(Utils.isDark(AppColor.deliveryColor)
                    ? Colors.white
                    : AppColor.primaryColor)
                    .make()
                    .py2()
                    .px8(),
                CurrencyHStack(
                  [
                    "44.97".text.lg.color(AppColor.primary).semiBold.make(),
                    currencySymbol.text.lg
                        .color(AppColor.primary)
                        .semiBold
                        .make(),
                  ],
                  crossAlignment: CrossAxisAlignment.end,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                "Service fee"
                    .tr()
                    .text
                    .lg
                    .fontFamily(AppFonts.appFont)
                    .color(Utils.isDark(AppColor.deliveryColor)
                    ? Colors.white
                    : AppColor.primaryColor)
                    .make()
                    .py2()
                    .px8(),
                CurrencyHStack(
                  [
                    "3.00".text.lg.color(AppColor.primary).semiBold.make(),
                    currencySymbol.text.lg
                        .color(AppColor.primary)
                        .semiBold
                        .make(),
                  ],
                  crossAlignment: CrossAxisAlignment.end,
                ),
              ],
            ),
          ],)
          /*Stack(
            children: [
              //
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    LocationService.currenctAddress?.coordinates?.latitude ??
                        0.00,
                    LocationService.currenctAddress?.coordinates?.longitude ??
                        0.00,
                  ),
                  zoom: 15,
                ),
                padding: EdgeInsets.only(bottom: Vx.dp64 * 2),
                myLocationEnabled: true,
                markers: vm.mapMarkers ?? Set<Marker>(),
                polylines: Set<Polyline>.of(vm.polylines.values),
                onMapCreated: vm.setMapController,
              ),

              //
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  child: HStack(
                    [
                      //driver profile
                      CustomImage(
                        imageUrl: order.driver?.photo ?? "",
                      )
                          .wh(Vx.dp56, Vx.dp56)
                          .box
                          .roundedFull
                          .shadowXs
                          .clip(Clip.antiAlias)
                          .make(),

                      //
                      VStack(
                        [
                          "${order.driver?.name}".text.xl.semiBold.make(),
                          "${order.driver?.phone}".text.make(),
                        ],
                      ).px12().expand(),

                      //call
                      Visibility(
                        visible: AppUISettings.canCallDriver,
                        child: CustomButton(
                          icon: FlutterIcons.phone_call_fea,
                          iconColor: Colors.white,
                          title: "",
                          color: AppColor.primaryColor,
                          shapeRadius: Vx.dp24,
                          onPressed: vm.callDriver,
                        ).wh(Vx.dp64, Vx.dp40).p12(),
                      ),
                    ],
                  )
                      .p12()
                      .box
                      .color(context.theme.colorScheme.background)
                      .roundedSM
                      .shadowXl
                      .outerShadow3Xl
                      .make()
                      .wFull(context)
                      .h(Vx.dp64 * 1.3)
                      .p12(),
                ),
              ),
            ],
          ),*/
        );
      },
    );

  }

   Widget ProductList() {
     return Column(
       children: [
         Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     "1. Chikken tikka masala"
                         .tr()
                         .text
                         .lg
                         .fontFamily(AppFonts.appFont)
                         .color(Utils.isDark(AppColor.deliveryColor)
                         ? Colors.white
                         : AppColor.primaryColor)
                         .make()
                         .py2()
                         .px8(),
                     CurrencyHStack(
                       [
                         "17.99".text.lg.color(AppColor.primary).semiBold.make(),
                         currencySymbol.text.lg
                             .color(AppColor.primary)
                             .semiBold
                             .make(),
                       ],
                       crossAlignment: CrossAxisAlignment.end,
                     ),
                   ],
                 ),
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         "1x Mint chutney"
                             .tr()
                             .text
                             .maxFontSize(10)
                             .minFontSize(6)
                             .fontFamily(AppFonts.appFont)
                             .color(Utils.isDark(AppColor.deliveryColor)
                             ? Colors.white
                             : AppColor.primaryColor)
                             .make()
                             .py2()
                             .px8(),
                         CurrencyHStack(
                           [
                             "1.50"
                                 .tr()
                                 .text
                                 .maxFontSize(10)
                                 .minFontSize(6)
                                 .fontFamily(AppFonts.appFont)
                                 .color(Utils.isDark(AppColor.deliveryColor)
                                 ? Colors.white
                                 : AppColor.primaryColor)
                                 .make(),
                             currencySymbol
                                 .tr()
                                 .text
                                 .maxFontSize(10)
                                 .minFontSize(6)
                                 .fontFamily(AppFonts.appFont)
                                 .color(Utils.isDark(AppColor.deliveryColor)
                                 ? Colors.white
                                 : AppColor.primaryColor)
                                 .make(),
                           ],
                           crossAlignment: CrossAxisAlignment.end,
                         ),
                       ],
                     ),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         "1x Tamarind chutney"
                             .tr()
                             .text
                             .maxFontSize(10)
                             .minFontSize(6)
                             .fontFamily(AppFonts.appFont)
                             .color(Utils.isDark(AppColor.deliveryColor)
                             ? Colors.white
                             : AppColor.primaryColor)
                             .make()
                             .py2()
                             .px8(),
                         CurrencyHStack(
                           [
                             "1.50"
                                 .tr()
                                 .text
                                 .maxFontSize(10)
                                 .minFontSize(6)
                                 .fontFamily(AppFonts.appFont)
                                 .color(Utils.isDark(AppColor.deliveryColor)
                                 ? Colors.white
                                 : AppColor.primaryColor)
                                 .make(),
                             currencySymbol
                                 .tr()
                                 .text
                                 .maxFontSize(10)
                                 .minFontSize(6)
                                 .fontFamily(AppFonts.appFont)
                                 .color(Utils.isDark(AppColor.deliveryColor)
                                 ? Colors.white
                                 : AppColor.primaryColor)
                                 .make(),
                           ],
                           crossAlignment: CrossAxisAlignment.end,
                         ),
                       ],
                     ),
                   ],
                 )
               ],
             )
           ],
         ).py8(),
         Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     "2. Chikken tikka masala"
                         .tr()
                         .text
                         .lg
                         .fontFamily(AppFonts.appFont)
                         .color(Utils.isDark(AppColor.deliveryColor)
                         ? Colors.white
                         : AppColor.primaryColor)
                         .make()
                         .py2()
                         .px8(),
                     CurrencyHStack(
                       [
                         "17.99".text.lg.color(AppColor.primary).semiBold.make(),
                         currencySymbol.text.lg
                             .color(AppColor.primary)
                             .semiBold
                             .make(),
                       ],
                       crossAlignment: CrossAxisAlignment.end,
                     ),
                   ],
                 ),
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         "1x Mint chutney"
                             .tr()
                             .text
                             .maxFontSize(10)
                             .minFontSize(6)
                             .fontFamily(AppFonts.appFont)
                             .color(Utils.isDark(AppColor.deliveryColor)
                             ? Colors.white
                             : AppColor.primaryColor)
                             .make()
                             .py2()
                             .px8(),
                         CurrencyHStack(
                           [
                             "1.50"
                                 .tr()
                                 .text
                                 .maxFontSize(10)
                                 .minFontSize(6)
                                 .fontFamily(AppFonts.appFont)
                                 .color(Utils.isDark(AppColor.deliveryColor)
                                 ? Colors.white
                                 : AppColor.primaryColor)
                                 .make(),
                             currencySymbol
                                 .tr()
                                 .text
                                 .maxFontSize(10)
                                 .minFontSize(6)
                                 .fontFamily(AppFonts.appFont)
                                 .color(Utils.isDark(AppColor.deliveryColor)
                                 ? Colors.white
                                 : AppColor.primaryColor)
                                 .make(),
                           ],
                           crossAlignment: CrossAxisAlignment.end,
                         ),
                       ],
                     ),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         "1x Tamarind chutney"
                             .tr()
                             .text
                             .maxFontSize(10)
                             .minFontSize(6)
                             .fontFamily(AppFonts.appFont)
                             .color(Utils.isDark(AppColor.deliveryColor)
                             ? Colors.white
                             : AppColor.primaryColor)
                             .make()
                             .py2()
                             .px8(),
                         CurrencyHStack(
                           [
                             "1.50"
                                 .tr()
                                 .text
                                 .maxFontSize(10)
                                 .minFontSize(6)
                                 .fontFamily(AppFonts.appFont)
                                 .color(Utils.isDark(AppColor.deliveryColor)
                                 ? Colors.white
                                 : AppColor.primaryColor)
                                 .make(),
                             currencySymbol
                                 .tr()
                                 .text
                                 .maxFontSize(10)
                                 .minFontSize(6)
                                 .fontFamily(AppFonts.appFont)
                                 .color(Utils.isDark(AppColor.deliveryColor)
                                 ? Colors.white
                                 : AppColor.primaryColor)
                                 .make(),
                           ],
                           crossAlignment: CrossAxisAlignment.end,
                         ),
                       ],
                     ),
                   ],
                 )
               ],
             )
           ],
         ).py8(),
         Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     "3. Canned pop(355ml)"
                         .tr()
                         .text
                         .lg
                         .fontFamily(AppFonts.appFont)
                         .color(Utils.isDark(AppColor.deliveryColor)
                         ? Colors.white
                         : AppColor.primaryColor)
                         .make()
                         .py2()
                         .px8(),
                     CurrencyHStack(
                       [
                         "2.99".text.lg.color(AppColor.primary).semiBold.make(),
                         currencySymbol.text.lg
                             .color(AppColor.primary)
                             .semiBold
                             .make(),
                       ],
                       crossAlignment: CrossAxisAlignment.end,
                     ),
                   ],
                 ),
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         "1x Coke zero"
                             .tr()
                             .text
                             .maxFontSize(10)
                             .minFontSize(6)
                             .fontFamily(AppFonts.appFont)
                             .color(Utils.isDark(AppColor.deliveryColor)
                             ? Colors.white
                             : AppColor.primaryColor)
                             .make()
                             .py2()
                             .px8(),

                       ],
                     ),

                   ],
                 )
               ],
             )
           ],
         ).py8(),
       ],
     ).px12();
   }

}
