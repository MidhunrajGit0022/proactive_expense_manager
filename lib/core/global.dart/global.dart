import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

void pr(data) {
  log("------>$data");
}

TextStyle customisedStyle(Colors, FontWeight, fontSize) {
  return GoogleFonts.poppins(
    textStyle: TextStyle(
      fontWeight: FontWeight,
      color: Colors,
      fontSize: fontSize,
    ),
  );
}

String formatDateDDMMYYYY(String inputDate) {
  DateTime date = DateTime.parse(inputDate); // "2026-11-09"
  return DateFormat('dd-MM-yyyy').format(date); // "09-11-2026"
}

String handleNullOrNone(dynamic value) {
  if (value == null || value == 'None' || value == 'null' || value == '') {
    return '-';
  }
  return value.toString();
}

String roundStringWith(String? val) {
  if (val == null || val.isEmpty) {
    return '0.00';
  }

  try {
    var decimal = 2;
    double convertedToDouble = double.parse(val);
    var number = convertedToDouble.toStringAsFixed(decimal);
    return number;
  } catch (e) {
    return '0.00';
  }
}

Container dividerStyle() {
  Color lightgrey = const Color(0xFFE8E8E8);
  Color grey = const Color(0xFFE8E8E8).withOpacity(.3);

  return Container(
    height: 1,
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [grey, lightgrey, grey],
        stops: const [0.1, 0.4, 1.0],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
    ),
  );
}

String convertDate(DateTime time) {
  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  return formatter.format(time);
}

String convertDaterev(DateTime time) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  return formatter.format(time);
}
