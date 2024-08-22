import 'package:currency_formatter/currency_formatter.dart';
import 'package:intl/intl.dart';
import 'package:mealknight/constants/app_strings.dart';

extension NumberParsing on dynamic {
  //
  String currencyFormat([String? currencySymbol]) {
    final uiConfig = AppStrings.uiConfig;
    if (uiConfig != null && uiConfig["currency"] != null) {
      //
      final thousandSeparator = uiConfig["currency"]["format"] ?? ",";
      final decimalSeparator = uiConfig["currency"]["decimal_format"] ?? ".";
      final decimals = uiConfig["currency"]["decimals"];
      final currencyLOCATION = uiConfig["currency"]["location"] ?? 'left';
      final decimalsValue =
          "".padLeft(int.tryParse(decimals.toString()) ?? 0, "0");

      final values = toString()
          .split(" ")
          .join("")
          .split(currencySymbol ?? AppStrings.currencySymbol);

      //
      CurrencyFormatterSettings currencySettings = CurrencyFormatterSettings(
        symbol: currencySymbol ?? AppStrings.currencySymbol,
        symbolSide: currencyLOCATION.toLowerCase() == "left"
            ? SymbolSide.left
            : SymbolSide.right,
        thousandSeparator: thousandSeparator,
        decimalSeparator: decimalSeparator,
      );

      return CurrencyFormatter.format(
        values[1],
        currencySettings,
        decimal: decimalsValue.length,
        enforceDecimals: true,
      );
    } else {
      return toString();
    }
  }

  //
  String currencyValueFormat() {
    final uiConfig = AppStrings.uiConfig;
    if (uiConfig != null && uiConfig["currency"] != null) {
      final thousandSeparator = uiConfig["currency"]["format"] ?? ",";
      final decimalSeparator = uiConfig["currency"]["decimal_format"] ?? ".";
      final decimals = uiConfig["currency"]["decimals"];
      final decimalsValue =
          "".padLeft(int.tryParse(decimals.toString()) ?? 0, "0");
      final values = toString().split(" ").join("");

      //
      CurrencyFormatterSettings currencySettings = CurrencyFormatterSettings(
        symbol: "",
        symbolSide: SymbolSide.right,
        thousandSeparator: thousandSeparator,
        decimalSeparator: decimalSeparator,
      );
      return CurrencyFormatter.format(
        values,
        currencySettings,
        decimal: decimalsValue.length,
        enforceDecimals: true,
      );
    } else {
      return toString();
    }
  }

  bool get isNotDefaultImage {
    return !toString().contains("default");
  }

  String maskString({int start = 3, int? end, String mask = "*"}) {
    final String value = toString();
    // make sure start and end are within the string length
    if (start < 0) {
      start = 0;
    }

    int endPoint = end ?? value.length;
    if (endPoint > value.length) {
      endPoint = value.length;
    }

    // get the front and end of the string
    final String frontString = start == 0 ? "" : value.substring(0, start);
    final String endString = value.substring(endPoint);
    final String maskedString = mask.padLeft(
      value.substring(start, endPoint).length,
      mask,
    );
    return "$frontString$maskedString$endString";
  }
}

String formatCurrency(double value) {
  // Create a NumberFormat object configured for currency.
  // Setting symbol to an empty string if not provided to avoid displaying any currency symbol.
  NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'en_US', // You can set this to any locale you need
      symbol: "",  // Use the symbol passed in or default to an empty string
      decimalDigits: 2  // You can specify the number of decimal places here
  );

  // Use the format method of NumberFormat to format the double value.
  return currencyFormat.format(value);
}