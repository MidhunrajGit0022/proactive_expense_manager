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

