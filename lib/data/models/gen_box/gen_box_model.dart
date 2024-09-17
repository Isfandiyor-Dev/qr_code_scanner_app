import 'package:flutter/material.dart';


class GenBox {
  final String name;
  final String iconPath;
  final Widget generateContainer;

  GenBox({
    required this.name,
    required this.iconPath,
    required this.generateContainer,
  });
}


class SingleFieldBox extends GenBox {
  final String fieldLabel;
  final String hintText;

  SingleFieldBox({
    required super.name,
    required this.fieldLabel,
    required this.hintText,
    required super.generateContainer,
    required super.iconPath,
  });
}
