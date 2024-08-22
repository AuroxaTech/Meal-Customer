import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_font.dart';

class CustomDropdownButton<T> extends StatefulWidget {
  const CustomDropdownButton({
    super.key,
    required this.options,
    this.hint,
    this.label,
    this.onItemSelected,
    this.optionsBuilder,
    this.selectedItemBuilder,
    this.borderRadius = 8.0,
    this.widget,
    this.style = const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
    this.padding = const EdgeInsets.symmetric(horizontal: 44, vertical: 8.0),
  });

  final String? hint;
  final String? label;
  final Function(T? value)? onItemSelected;
  final Widget Function(T? item)? optionsBuilder;
  final Widget Function(BuildContext ctx, T? item)? selectedItemBuilder;
  final TextStyle style;
  final double borderRadius;
  final Widget? widget;
  final EdgeInsetsGeometry? padding;
  final List<T> options;

  @override
  State<CustomDropdownButton<T>> createState() =>
      _CustomDropdownButtonState<T>();
}

class _CustomDropdownButtonState<T> extends State<CustomDropdownButton<T>> {
  T? currentChoice;

  @override
  void initState() {
    super.initState();
    currentChoice = widget.options.first;
  }

  @override
  Widget build(BuildContext context) {
    Widget dropDownWidget = InputDecorator(
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 18,
            fontFamily: AppFonts.appFont,
            color: AppColor.primary,
            fontWeight: FontWeight.w600),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.primaryColor, width: 2),
          borderRadius: BorderRadius.all(
            Radius.circular(widget.borderRadius),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.primaryColor, width: 2),
          borderRadius: BorderRadius.all(
            Radius.circular(widget.borderRadius),
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.primaryColor, width: 2),
          borderRadius: BorderRadius.all(
            Radius.circular(widget.borderRadius),
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.primaryColor, width: 2),
          borderRadius: BorderRadius.all(
            Radius.circular(widget.borderRadius),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          icon: const Icon(Icons.expand_more),
          hint: Text(
            widget.hint ?? "",
            style: const TextStyle(
              color: Color(0xFFD2D2D2),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          value: currentChoice,
          selectedItemBuilder: (BuildContext context) =>
              widget.options.map<Widget>((item) {
            return widget.selectedItemBuilder?.call(context, item) ??
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item.toString(),
                    style: TextStyle(
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.appFont,
                    ),
                  ),
                );
          }).toList(),
          items: widget.options
              .map<DropdownMenuItem<T>>((item) => DropdownMenuItem<T>(
                    value: item,
                    child: widget.optionsBuilder?.call(item) ??
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            item.toString(),
                            style: TextStyle(
                              color:
                                  item == currentChoice ? Colors.green : null,
                            ),
                          ),
                        ),
                  ))
              .toList(),
          onChanged: (T? value) {
            widget.onItemSelected?.call(value);
            setState(() => currentChoice = value);
          },
        ),
      ),
    );

    return dropDownWidget;
  }
}
