import 'package:flutter/material.dart';

const searchBoxColor = Color(0x22EFFBFF);
const backgroundColor = Color(0xFFEFFBFF);
const iconColorHighLight = Color(0xffffffff);
const iconColor = Color(0xff0702fd);
const textColor = Color(0xff0702fd);
const backColor = Color(0xcccccccc);
const circleBtnStyle = ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.zero),backgroundColor: WidgetStatePropertyAll(iconColor), fixedSize: WidgetStatePropertyAll(Size(60, 60)), shape: WidgetStatePropertyAll(CircleBorder()), iconSize: WidgetStatePropertyAll(45), iconColor:  WidgetStatePropertyAll(iconColorHighLight));
const navButtonStyle = ButtonStyle( padding: WidgetStatePropertyAll(EdgeInsets.zero), fixedSize: WidgetStatePropertyAll(Size(90,40)), backgroundColor: WidgetStatePropertyAll(Colors.transparent), shadowColor: WidgetStatePropertyAll(Colors.transparent), iconColor: WidgetStatePropertyAll(iconColor), iconSize: WidgetStatePropertyAll(25));
const navButtonStyleHighLight = ButtonStyle( padding: WidgetStatePropertyAll(EdgeInsets.zero), fixedSize: WidgetStatePropertyAll(Size(90,40)), backgroundColor: WidgetStatePropertyAll(iconColor), shadowColor: WidgetStatePropertyAll(Colors.transparent), iconColor: WidgetStatePropertyAll(iconColorHighLight), iconSize: WidgetStatePropertyAll(25));