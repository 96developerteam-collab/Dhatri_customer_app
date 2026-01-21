import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'icons_map.dart';

class FaCustomIcon {
  static IconData getFontAwesomeIcon(String iconName) {
    if (iconName == '') {
      return FontAwesomeIcons.questionCircle;
    }
    var list = iconName.split(' ');
    if (list.length == 1) {
      iconName = list[0];
    }
    if (list.length >= 2) {
      iconName = list[1];
    }
    iconName = iconName.replaceAll('fa-', '');
    iconName = iconName.replaceAll('-', '');

    final filteredIcons = icons.where((icon) {
      return icon.title
          .toLowerCase()
          .replaceAll('-', '')
          .contains(iconName.toLowerCase());
    }).toList();
    if (filteredIcons.isEmpty) {
      return FontAwesomeIcons.questionCircle;
    } else {
      final iconDef = filteredIcons[0];
      if (iconDef.isAsset) return FontAwesomeIcons.questionCircle;
      return iconDef.iconData ?? FontAwesomeIcons.questionCircle;
    }
  }

  static Widget getIconWidget(String iconName, {double? size, Color? color, BoxFit fit = BoxFit.contain}) {
    if (iconName == '') {
      return Icon(FontAwesomeIcons.questionCircle, size: size, color: color);
    }
    var list = iconName.split(' ');
    if (list.length == 1) iconName = list[0];
    if (list.length >= 2) iconName = list[1];
    iconName = iconName.replaceAll('fa-', '');
    iconName = iconName.replaceAll('-', '');

    final filteredIcons = icons.where((icon) {
      return icon.title
          .toLowerCase()
          .replaceAll('-', '')
          .contains(iconName.toLowerCase());
    }).toList();

    if (filteredIcons.isEmpty) {
      return Icon(FontAwesomeIcons.questionCircle, size: size, color: color);
    } else {
      final iconDef = filteredIcons[0];
      if (iconDef.isAsset && iconDef.assetPath != null) {
        return ImageIcon(
          AssetImage(iconDef.assetPath!),
          size: size,
          color: color,
        );
      } else {
        return Icon(
          iconDef.iconData ?? FontAwesomeIcons.questionCircle,
          size: size,
          color: color,
        );
      }
    }
  }
}
