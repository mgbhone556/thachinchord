import 'package:flutter/material.dart';

class AppColors {
  // ပုံထဲက အဝါရောင် (Header အတွက်)
  static const Color primaryYellow = Color(0xFFFFC107);

  // ခလုတ်အတွက် အနက်ရောင်
  static const Color primaryBlack = Color(0xFF000000);

  // Background အဖြူရောင်
  static const Color white = Color(0xFFFFFFFF);

  // Input fields အတွက် မီးခိုးနုရောင်
  static const Color lightGrey = Color(0xFFF5F5F5);

  // စာသားတွေအတွက် မီးခိုးရင့်ရောင်
  static const Color textGrey = Color(0xFF757575);
}

class AppStyles {
  // ပုံထဲကလို ဝိုင်းဝိုင်းလေးဖြစ်ဖို့ Global BorderRadius
  static BorderRadius cardRadius = const BorderRadius.vertical(
    top: Radius.circular(40),
  );

  static BorderRadius buttonRadius = BorderRadius.circular(30);
}
