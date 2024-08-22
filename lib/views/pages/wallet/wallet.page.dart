import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/view_models/wallet.vm.dart';
import 'package:mealknight/widgets/base.page.dart';
import 'package:mealknight/widgets/custom_list_view.dart';
import 'package:mealknight/widgets/finance/wallet_management.view.dart';
import 'package:mealknight/widgets/list_items/wallet_transaction.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with WidgetsBindingObserver {
  //
  WalletViewModel? vm;
  @override
  void initState() {
    super.initState();
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
      vm?.initialise();
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    vm ??= WalletViewModel(context);

    //
    return BasePage(
      title: "Wallet".tr(),
      showLeadingAction: true,
      showAppBar: true,
      elevation: 0,
      appBarColor: context.theme.colorScheme.background,
      appBarItemColor: AppColor.primaryColor,
      backgroundColor: Color(0xffeefffd),
      body: ViewModelBuilder<WalletViewModel>.reactive(
        viewModelBuilder: () => vm!,
        onViewModelReady: (vm) => vm.initialise(),

        builder: (context, vm, child) {
          return SmartRefresher(
            controller: vm.refreshController,
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: () async {
              await vm.loadWalletData();
              vm.refreshController.refreshCompleted();
            },
            onLoading: () async {
              await vm.getWalletTransactions(initialLoading: false);
              vm.refreshController.loadComplete();
            },
            child: VStack(
              [
                //
                WalletManagementView(
                  viewmodel: vm,
                ),

                //transactions list
                "Wallet Transactions".tr().text.color(AppColor.primary).size(16).semiBold.xl.make().py12(),
                CustomListView(
                  noScrollPhysics: true,
                  isLoading: vm.busy(vm.walletTransactions),
                  onRefresh: vm.getWalletTransactions,
                  onLoading: () => vm.getWalletTransactions(initialLoading: false),
                  dataSet: vm.walletTransactions,
                  itemBuilder: (context, index) {
                    return WalletTransactionListItem(
                        vm.walletTransactions[index]);
                  },
                ),
              ],
            ).p20().scrollVertical(),
          );
        },
      ),
    );
  }
}
