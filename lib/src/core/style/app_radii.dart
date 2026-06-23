import 'package:flutter/material.dart';

/// Corner-radius tokens.
class AppRadii {
  AppRadii._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double pill = 999;

  static final BorderRadius field = BorderRadius.circular(md);
  static final BorderRadius button = BorderRadius.circular(lg);
  static final BorderRadius toggle = BorderRadius.circular(pill);
}
