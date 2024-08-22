import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_font.dart';
import 'package:mealknight/services/validator.service.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/view_models/delivery_address/new_delivery_addresses.vm.dart';
import 'package:mealknight/widgets/base.page.dart';
import 'package:mealknight/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../../constants/app_text_styles.dart';
import '../../../widgets/busy_indicator.dart';

class NewDeliveryAddressesPage extends StatefulWidget {
  const NewDeliveryAddressesPage({super.key, this.isFromRegister});

  final bool? isFromRegister;

  @override
  NewDeliveryAddressesPageState createState() =>
      NewDeliveryAddressesPageState();
}

class NewDeliveryAddressesPageState extends State<NewDeliveryAddressesPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewDeliveryAddressesViewModel>.reactive(
      viewModelBuilder: () => NewDeliveryAddressesViewModel(context),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        vm.isFromRegister = widget.isFromRegister!;
        return BasePage(
          showAppBar: !widget.isFromRegister!,
          showLeadingAction: true,
          isLoading: vm.isBusy,
          elevation: 0,
          title: "New Delivery Address".tr(),
          appBarColor: context.theme.colorScheme.background,
          appBarItemColor: AppColor.primaryColor,
          backgroundColor: const Color(0xffeefffd),
          body: Form(
              key: vm.formKey,
              child: VStack(
                [
                  vm.isFromRegister
                      ? UiSpacer.verticalSpace()
                      : const SizedBox(),
                  vm.isFromRegister
                      ? UiSpacer.verticalSpace()
                      : const SizedBox(),
                  vm.isFromRegister
                      ? "New Delivery Address"
                          .text
                          .size(26)
                          .maxLines(1)
                          .bold
                          .overflow(TextOverflow.ellipsis)
                          .color(AppColor.primaryColor)
                          .make()
                          .centered()
                      : const SizedBox(),
                  vm.isFromRegister
                      ? UiSpacer.verticalSpace()
                      : const SizedBox(),
                  vm.isFromRegister
                      ? UiSpacer.verticalSpace()
                      : const SizedBox(),
                  CustomTextFormField(
                    labelText: "Name".tr(),
                    textEditingController: vm.nameTEC,
                    validator: FormValidator.validateName,
                  ),
                  UiSpacer.verticalSpace(),
                  //what3words
                  /* What3wordsView(vm),*/
                  //
                  CustomTextFormField(
                    labelText: "Address".tr(),
                    isReadOnly: true,
                    textEditingController: vm.addressTEC,
                    validator: (value) => FormValidator.validateEmpty(value,
                        errorTitle: "Address".tr()),
                    onTap: vm.openLocationPicker,
                  ),

                  UiSpacer.verticalSpace(),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 4),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(width: 2, color: AppColor.primaryColor),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        items: vm.homeItems
                            .map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            fontSize: 18,
                                            fontFamily: AppFonts.appFont,
                                            color: AppColor.primary,
                                            fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        value: vm.selectedHomeItem,
                        onChanged: (String? value) {
                          setState(() {
                            vm.selectedHomeItem = value!;

                            if (value.contains('Call When here')) {
                              vm.isSelectedDoor = false;
                              vm.selectedDeliveryItem = 'Meet outside';
                            } else {
                              vm.isSelectedDoor = true;
                              vm.selectedDeliveryItem =
                                  'Hand it to me directly';
                            }
                          });
                          setState(() {});
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: MediaQuery.sizeOf(context).width - 30,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_drop_down,
                          ),
                          iconSize: 18,
                          iconEnabledColor: Colors.black54,
                          iconDisabledColor: Colors.grey,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          padding: const EdgeInsets.only(left: 10),
                          maxHeight: 200,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.white,
                          ),
                          offset: const Offset(0, 0),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all<double>(6),
                            thumbVisibility:
                                MaterialStateProperty.all<bool>(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.only(left: 14, right: 14),
                        ),
                      ),
                    ),
                  ),
                  UiSpacer.verticalSpace(),
                  vm.selectedHomeItem == 'Apartment'
                      ? CustomTextFormField(
                          labelText: "Apartment No ",
                          textEditingController: vm.apartmentNo,
                          validator: FormValidator.validateNumber,
                        )
                      : vm.isSelectedDoor
                          ? Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 4),
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 2, color: AppColor.primaryColor),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  isExpanded: true,
                                  items: vm.doorItems
                                      .map((String item) =>
                                          DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                      fontSize: 18,
                                                      fontFamily:
                                                          AppFonts.appFont,
                                                      color: AppColor.primary,
                                                      fontWeight:
                                                          FontWeight.w600),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                      .toList(),
                                  value: vm.selectedDoorItem,
                                  onChanged: (String? value) {
                                    setState(() {
                                      vm.selectedDoorItem = value!;
                                    });
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: 50,
                                    width:
                                        MediaQuery.sizeOf(context).width - 30,
                                    padding: const EdgeInsets.only(
                                        left: 14, right: 14),
                                  ),
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                    ),
                                    iconSize: 18,
                                    iconEnabledColor: Colors.black54,
                                    iconDisabledColor: Colors.grey,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    padding: const EdgeInsets.only(left: 10),
                                    maxHeight: 200,
                                    width: 300,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color: Colors.white,
                                    ),
                                    offset: const Offset(0, 0),
                                    scrollbarTheme: ScrollbarThemeData(
                                      radius: const Radius.circular(40),
                                      thickness:
                                          MaterialStateProperty.all<double>(6),
                                      thumbVisibility:
                                          MaterialStateProperty.all<bool>(true),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                    padding:
                                        EdgeInsets.only(left: 14, right: 14),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                  vm.isSelectedDoor
                      ? UiSpacer.verticalSpace()
                      : const SizedBox(),
                  vm.selectedHomeItem == 'Apartment'
                      ? CustomTextFormField(
                          labelText: "Buzzer No ",
                          textEditingController: vm.buzzerNo,
                          validator: FormValidator.validateNumber,
                        )
                      : Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 4),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 2, color: AppColor.primaryColor),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: vm.isSelectedDoor,
                              items: vm.deliveryItems
                                  .map((String item) =>
                                      DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                  fontSize: 18,
                                                  fontFamily: AppFonts.appFont,
                                                  color: AppColor.primary,
                                                  fontWeight: FontWeight.w600),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              value: vm.selectedDeliveryItem,
                              onChanged: !vm.isSelectedDoor
                                  ? null
                                  : (String? value) {
                                      setState(() {
                                        vm.selectedDeliveryItem = value!;
                                      });
                                    },
                              buttonStyleData: ButtonStyleData(
                                height: 50,
                                width: MediaQuery.sizeOf(context).width - 30,
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
                              ),
                              iconStyleData: IconStyleData(
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                ),
                                iconSize: 18,
                                iconEnabledColor: vm.isSelectedDoor
                                    ? Colors.black54
                                    : Colors.transparent,
                                iconDisabledColor: vm.isSelectedDoor
                                    ? Colors.grey
                                    : Colors.transparent,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                padding: const EdgeInsets.only(left: 10),
                                maxHeight: 200,
                                width: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Colors.white,
                                ),
                                offset: const Offset(0, 0),
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(40),
                                  thickness:
                                      MaterialStateProperty.all<double>(6),
                                  thumbVisibility:
                                      MaterialStateProperty.all<bool>(true),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                                padding: EdgeInsets.only(left: 14, right: 14),
                              ),
                            ),
                          ),
                        ),
                  UiSpacer.verticalSpace(),
                  // description
                  CustomTextFormField(
                    labelText: "Notes".tr(),
                    textEditingController: vm.descriptionTEC,
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    textInputAction: TextInputAction.newline,
                  ),
                  //
                  HStack(
                    [
                      Checkbox(
                        value: vm.isDefault,
                        onChanged: vm.toggleDefault,
                      ),
                      //
                      "Default".tr().text.make(),
                    ],
                  )
                      .onInkTap(
                        () => vm.toggleDefault(!vm.isDefault),
                      )
                      .wFull(context)
                      .py12(),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: AppColor.primaryColor,
                      disabledBackgroundColor:
                          vm.isBusy ? AppColor.primaryColor : null,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Vx.dp4),
                          side: const BorderSide(
                              color: Colors.transparent, width: 2)),
                    ),
                    onPressed: () {
                      vm.saveNewDeliveryAddress();
                    },
                    child: vm.isBusy
                        ? const BusyIndicator(color: Colors.white)
                        : Container(
                            //double.infinity,
                            height: Vx.dp48,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Save".tr(),
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.h3TitleTextStyle(
                                    color: Colors.white,
                                  ),
                                ).centered()
                              ],
                            ),
                          ),
                  ),
                  // CustomButton(
                  //   isFixedHeight: true,
                  //   height: Vx.dp48,
                  //   title: "Save".tr(),
                  //   onPressed: vm.saveNewDeliveryAddress(),
                  //   loading: vm.isBusy,
                  // ).centered(),
                ],
              )
                  .p20()
                  .scrollVertical()
                  .pOnly(bottom: context.mq.viewInsets.bottom)),
        );
      },
    );
  }
}
