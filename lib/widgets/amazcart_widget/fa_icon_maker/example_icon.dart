import 'package:flutter/widgets.dart';

class IconDefinition implements Comparable {
  final IconData? iconData;
  final String? assetPath;
  final String title;

  /// Regular icon constructor (FontAwesome / IconData)
  IconDefinition(this.iconData, this.title) : assetPath = null;

  /// Asset-based icon constructor (use an image asset)
  IconDefinition.asset(this.assetPath, this.title) : iconData = null;

  bool get isAsset => assetPath != null;

  @override
  String toString() => 'IconDefinition{iconData: $iconData, assetPath: $assetPath, title: $title}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IconDefinition &&
          runtimeType == other.runtimeType &&
          iconData == other.iconData &&
          assetPath == other.assetPath &&
          title == other.title;

  @override
  int get hashCode => (iconData?.hashCode ?? 0) ^ (assetPath?.hashCode ?? 0) ^ title.hashCode;

  @override
  int compareTo(other) => title.compareTo(other.title);
}
