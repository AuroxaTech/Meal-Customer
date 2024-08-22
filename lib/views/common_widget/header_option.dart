import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_font.dart';
import 'package:mealknight/models/category.dart';
import 'package:velocity_x/velocity_x.dart';

class HeaderOption extends StatefulWidget {
  final List<Category> subCategoryList;
  final Function(Category? category)? onCategorySelected;

  const HeaderOption({
    super.key,
    required this.subCategoryList,
    this.onCategorySelected,
  });

  @override
  State<HeaderOption> createState() => _HeaderOptionState();
}

class _HeaderOptionState extends State<HeaderOption> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: widget.subCategoryList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          Category data = widget.subCategoryList[index];
          Color textColor = AppColor.primary;
          return InkWell(
            onTap: () {
              setState(() {
                if (selectedIndex == index) {
                  selectedIndex = -1; // Unselect if already selected
                  widget.onCategorySelected?.call(null);
                } else {
                  selectedIndex = index;
                  widget.onCategorySelected?.call(data);
                }
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  height: 60,
                  width: 60,
                  // padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: AppColor.primary.withOpacity(
                              (selectedIndex == index) ? 1 : 0.3),
                          width: 2.3)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Opacity(
                      opacity: (selectedIndex == index) ? 1 : 0.3,
                      child: Container(
                          margin: EdgeInsets.all(8),
                          child: Image.network(data.photo ?? "",
                              fit: BoxFit.fill)),
                    ),
                  ),
                ),
                3.heightBox,
                data.name.text
                    .color(textColor)
                    .fontWeight(FontWeight.w600)
                    .fontFamily(AppFonts.appFont)
                    .make()
              ],
            ),
          );
        },
      ),
    );
  }
}
