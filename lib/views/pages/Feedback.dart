import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_font.dart';
import 'package:velocity_x/velocity_x.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Feedback'.text.fontWeight(FontWeight.w600).fontFamily(AppFonts.appFont).make(),
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
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.add_circle_outline))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.heightBox,
            'Store'.text.size(16).fontFamily(AppFonts.appFont).fontWeight(FontWeight.w500).make(),
            5.heightBox,
            Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xff504539),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                maxLines: 1,
                keyboardType: TextInputType.text,
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
            20.heightBox,
            'Type'.text.fontFamily(AppFonts.appFont).size(16).make(),
            5.heightBox,
            Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xff504539),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                maxLines: 1,
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
            20.heightBox,
            'Feedback'.text.fontFamily(AppFonts.appFont).size(16).make(),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xff504539),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'Write your concern here...',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent))),
              ),
            )
          ],
        ).pSymmetric(h: 16),
      ),
    );
  }
}
