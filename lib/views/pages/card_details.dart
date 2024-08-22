import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_font.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

class CardDetails extends StatefulWidget {
  const CardDetails({super.key});

  @override
  State<CardDetails> createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  DateTime _selectedDate = DateTime.now();
  bool defaultCheck = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Add Card'.text.fontFamily(AppFonts.appFont).fontWeight(FontWeight.w600).make(),
        surfaceTintColor: AppColor.primary,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 18,
            )),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.heightBox,
                'Card Number'.text.fontFamily(AppFonts.appFont).fontWeight(FontWeight.w600).make(),
                5.heightBox,
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xffF0F0F0),
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    children: [
                      10.widthBox,
                      Image.asset(
                        'assets/images/mastercard.png',
                        height: 27,
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: '**** **** **** 1562',
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              disabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent))),
                        ),
                      )
                    ],
                  ),
                ),
                20.heightBox,
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          'Expiry Date'.text.fontFamily(AppFonts.appFont).fontWeight(FontWeight.w600).make(),
                          5.heightBox,
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xffF0F0F0),
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              children: [
                                10.widthBox,
                                Expanded(
                                  child: TextFormField(
                                    readOnly: true,
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              //which date will display when user open the picker
                                              firstDate: DateTime(1950),
                                              //what will be the previous supported year in picker
                                              lastDate: DateTime
                                                  .now()) //what will be the up to supported date in picker
                                          .then((pickedDate) {
                                        //then usually do the future job
                                        if (pickedDate == null) {
                                          //if user tap cancel then this function will stop
                                          return;
                                        }
                                        setState(() {
                                          _selectedDate = pickedDate;
                                        });
                                      });
                                    },
                                    initialValue: getFormattedDate(
                                        _selectedDate.toString()),
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent)),
                                        disabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent)),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent))),
                                  ),
                                ),
                                Image.asset(
                                  'assets/images/calendar.png',
                                  height: 24,
                                ),
                                15.widthBox,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    10.widthBox,
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          'CVC/CVV'.text.fontWeight(FontWeight.w600).fontFamily(AppFonts.appFont).make(),
                          5.heightBox,
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xffF0F0F0),
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: TextFormField(
                              initialValue: '****',
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                20.heightBox,
                'Card Holder Name'.text.fontWeight(FontWeight.w600).fontFamily(AppFonts.appFont).make(),
                5.heightBox,
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xffF0F0F0),
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: TextFormField(
                    initialValue: 'Robert Fox',
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)),
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent))),
                  ),
                ),
                15.heightBox,
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            defaultCheck = !defaultCheck;
                          });
                        },
                        icon: defaultCheck? Icon(
                          Icons.check_circle_rounded,
                          color: AppColor.primary,
                        ): Icon(
                          Icons.circle_outlined,
                          color: AppColor.primary,
                        )),
                    'Use as the default payment method'
                        .text.fontFamily(AppFonts.appFont)
                        .fontWeight(FontWeight.w600)
                        .make()
                  ],
                )
              ],
            ).pSymmetric(
              h: 16,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20,right: 20,bottom: 40,top: 10),
            alignment: Alignment.center,
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(100)),
            child: 'Save Card'.text.fontWeight(FontWeight.w600).fontFamily(AppFonts.appFont).color(Colors.white).make(),
          )
        ],
      ),
    );
  }

  String getFormattedDate(String date) {
    /// Convert into local date format.
    var localDate = DateTime.parse(date).toLocal();

    /// inputFormat - format getting from api or other func.
    /// e.g If 2021-05-27 9:34:12.781341 then format must be yyyy-MM-dd HH:mm
    /// If 27/05/2021 9:34:12.781341 then format must be dd/MM/yyyy HH:mm
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(localDate.toString());

    /// outputFormat - convert into format you want to show.
    var outputFormat = DateFormat('MMM dd, yyyy');
    var outputDate = outputFormat.format(inputDate);

    return outputDate.toString();
  }
}
