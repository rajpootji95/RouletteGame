

import 'package:flutter/material.dart';

class Constants{
  static  Size screen = const Size(730.0, 360.0);
  static getScreenSize(context){
    screen = MediaQuery.sizeOf(context);
  }
}