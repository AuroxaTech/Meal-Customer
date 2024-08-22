import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_font.dart';
import '../../../constants/app_text_styles.dart';
import '../../../services/validator.service.dart';
import '../../../utils/ui_spacer.dart';
import '../../../view_models/delivery_address/edit_delivery_addresses.vm.dart';
import '../../../widgets/base.page.dart';
import '../../../widgets/busy_indicator.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/custom_text_form_field.dart';

class EditDeliveryAddressesPage extends StatefulWidget {
  const EditDeliveryAddressesPage({
    this.deliveryAddress,
    super.key,
  });

  final dynamic deliveryAddress;

  @override
  EditDeliveryAddressesPageState createState() =>
      EditDeliveryAddressesPageState();
}

class EditDeliveryAddressesPageState extends State<EditDeliveryAddressesPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditDeliveryAddressesViewModel>.reactive(
      viewModelBuilder: () =>
          EditDeliveryAddressesViewModel(context, widget.deliveryAddress),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          showAppBar: true,
          showLeadingAction: true,
          title: "Update Delivery Address".tr(),
          appBarColor: context.theme.colorScheme.surface,
          appBarItemColor: AppColor.primaryColor,
          backgroundColor: const Color(0xffeefffd),
          elevation: 0,
          body: Form(
            key: vm.formKey,
            child: VStack(
              [
                CustomTextFormField(
                  labelText: "Name".tr(),
                  textEditingController: vm.nameTEC,
                  validator: FormValidator.validateName,
                ),
                UiSpacer.verticalSpace(space: 15),
                CustomTextFormField(
                  labelText: "Address".tr(),
                  isReadOnly: true,
                  textEditingController: vm.addressTEC,
                  validator: (value) => FormValidator.validateEmpty(
                    value,
                    errorTitle: "Address".tr(),
                  ),
                  onTap: vm.openLocationPicker,
                ),
                UiSpacer.verticalSpace(space: 15),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 4),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: AppColor.primaryColor),
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
                            vm.selectedDeliveryItem = 'Hand it to me directly';
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
                UiSpacer.verticalSpace(space: 15),
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
                                  width: MediaQuery.sizeOf(context).width - 30,
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
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                vm.isSelectedDoor ? UiSpacer.verticalSpace() : const SizedBox(),
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
                            value: vm.selectedDeliveryItem,
                            onChanged: (String? value) {
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
                UiSpacer.verticalSpace(space: 15),

                CustomTextFormField(
                  labelText: "Description".tr(),
                  textEditingController: vm.descriptionTEC,
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  textInputAction: TextInputAction.newline,
                ).py2(),
                //
                vm.isTrue
                    ? HStack(
                        [
                          Checkbox(
                            value: vm.isDefault,
                            onChanged: vm.toggleDefault,
                            activeColor: AppColor.primaryColor,
                            fillColor: MaterialStateColor.resolveWith((states) {
                              // Change the color of the checkbox when unchecked
                              // if (states.contains(MaterialState.selected)) {
                              //   return AppColor.primaryColor; // Use your desired color when checked
                              // }
                              return AppColor
                                  .primaryColor; // Use your desired color when unchecked
                            }),
                          ),
                          //
                          Text('Default',
                              style: TextStyle(
                                  color: AppColor.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15)),
                        ],
                      )
                        .onInkTap(
                          () => vm.toggleDefault(!vm.isDefault),
                        )
                        .wFull(context)
                        .py2()
                    : UiSpacer.verticalSpace(),

                CustomButton(
                  isFixedHeight: true,
                  height: Vx.dp48,
                  title: "Save Address",
                  onPressed: vm.updateDeliveryAddress,
                  loading: vm.isBusy,
                ).centered(),

                UiSpacer.verticalSpace(),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: Colors.red,
                    disabledBackgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Vx.dp4),
                        side: const BorderSide(
                            color: Colors.transparent, width: 2)),
                  ),
                  onPressed: () {
                    vm.deleteDeliveryAddress(vm.deliveryAddress);
                  },
                  child: vm.isBusy
                      ? const BusyIndicator(color: Colors.white)
                      : SizedBox(
                          //double.infinity,
                          height: Vx.dp48,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Delete Address",
                                textAlign: TextAlign.center,
                                style: AppTextStyle.h3TitleTextStyle(
                                  color: Colors.white,
                                ),
                              ).centered()
                            ],
                          ),
                        ),
                ).centered(),
                //vm.deleteDeliveryAddress(deliveryAddress)
              ],
            ).p20().scrollVertical(),
          ),
        );
      },
    );
  }
}
