import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_images.dart';
import 'package:mealknight/constants/app_routes.dart';
import 'package:mealknight/models/profile_list_model.dart';
import 'package:mealknight/view_models/profile.vm.dart';
import 'package:mealknight/widgets/base.page.dart';
import 'package:mealknight/widgets/busy_indicator.dart';
import 'package:mealknight/widgets/states/empty.state.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import 'widget/profile_option_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(context),
      onViewModelReady: (model) => model.initialise(),
      disposeViewModel: false,
      builder: (context, model, child) {
        return BasePage(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                )),
            backgroundColor: AppColor.primary,
            body: VStack(
              [
                if (model.authenticated) ...[
                  const SizedBox(height: 42),
                  GestureDetector(
                      onTap: () {
                        model.logoutPressed();
                      },
                      child: Image.asset(
                        'assets/images/power_button.png',
                        height: 55,
                      )),
                ],
                //
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      model.authenticated
                          ? VStack(
                              [
                                //profile card
                                GestureDetector(
                                  onTap: () async {
                                    var result =
                                        await Navigator.of(context).pushNamed(
                                      AppRoutes.editProfileRoute,
                                    );
                                    if (result == true) {
                                      model.initialise();
                                    }
                                  },
                                  child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    // color: Colors.grey,
                                    child: CachedNetworkImage(
                                      imageUrl: model.currentUser?.photo ?? "",
                                      errorWidget: (context, imageUrl, _) =>
                                          Image.asset(
                                        AppImages.loginUser,
                                        fit: BoxFit.cover,
                                      ),
                                      fit: BoxFit.cover,
                                      progressIndicatorBuilder:
                                          (context, imageURL, progress) =>
                                              const BusyIndicator().centered(),
                                    ),
                                  ),
                                ).centered(),
                                8.heightBox,
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
                            ).py12(),
                      SingleChildScrollView(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: model.profileList.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 6),
                          itemBuilder: (BuildContext context, int index) {
                            ProfileListModel type = model.profileList[index];
                            return ProfileOptionWidget(
                              title: type.name ?? "",
                              icon: type.photo ?? "",
                              onTap: () {
                                type.onTap();
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: GestureDetector(
                          onTap: () {
                            model.openLanguages();
                          },
                          child: Container(
                              height: 65,
                              width: 65,
                              padding: const EdgeInsets.only(
                                  top: 12, bottom: 15, right: 15, left: 12),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                      'assets/images/home-bg-3.png',
                                    ),
                                    fit: BoxFit.contain),
                              ),
                              child: Image.asset(
                                  'assets/images/icons/languages-0.png',
                                  fit: BoxFit.contain)),
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context, true);
                          },
                          child: Image.asset(
                            AppImages.swipeArrows,
                            height: 65,
                          )).pOnly(right: 10),
                    ]),
                // Spacer(),
                // MediaQuery.of(context).padding.bottom.heightBox
              ],
            ).pSymmetric(v: 5, h: 10));
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class Item {
  String title;
  bool isSelected;

  Item({required this.title, this.isSelected = false});
}
