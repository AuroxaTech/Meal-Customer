import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_images.dart';
import 'package:mealknight/view_models/profile.vm.dart';
import 'package:mealknight/widgets/busy_indicator.dart';
import 'package:mealknight/widgets/states/empty.state.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard(this.model, {super.key});

  final ProfileViewModel model;

  @override
  Widget build(BuildContext context) {
    return model.authenticated
        ? VStack(
            [
              if (model.authenticated) ...[
                GestureDetector(
                    onTap: () {
                      model.logoutPressed();
                    },
                    child: Image.asset(
                      'assets/images/power_button.png',
                      height: 55,
                    )),
              ],
              //profile card
              Stack(
                children: [
                  //
                  Container(
                    height: 100,
                    width: 100,
                    color: Colors.grey,
                    child: CachedNetworkImage(
                      imageUrl: model.currentUser?.photo ?? "",
                      errorWidget: (context, imageUrl, _) => Image.asset(
                        AppImages.appLogo,
                        fit: BoxFit.cover,
                      ),
                      fit: BoxFit.cover,
                      progressIndicatorBuilder: (context, imageURL, progress) =>
                          BusyIndicator().centered(),
                    ), /*model
                              .currentUser!.name.capitalized[0].text.xl.semiBold
                              .color(Colors.white)
                              .size(50)
                              .make()
                              .centered()*/
                  ).cornerRadius(60)
                ],
              ).box.makeCentered(),

              15.heightBox,
              //name
              model.currentUser!.name.text.lg.bold
                  .color(AppColor.primary)
                  .size(25)
                  .make()
                  .centered(),
              15.heightBox,
            ],
          )
        : EmptyState(
            auth: true,
            showAction: true,
            actionPressed: model.openLogin,
          ).py12();
  }
}
