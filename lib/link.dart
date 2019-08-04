import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


class Link {
  final String source;
  String description;
  Icon icon;

  Link(this.source, this.description, this.icon) {
    if (source == null || source.isEmpty) {
      throw ArgumentError("Need source");
    }
    if (description == null || description.isEmpty) {
      description = source;
    }
    if (icon == null) {
      icon = new Icon(MdiIcons.linkVariant);
    }
  }

}