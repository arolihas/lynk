import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:lynk_mobile/socialIcons.dart';

const iconDict = <String, IconData>{
  'Facebook': SocialIcons.facebook_rect,
  'Twitter': SocialIcons.twitter_bird,
  'Instagram': SocialIcons.instagram_filled,
  'Github': SocialIcons.github,
  'Email': SocialIcons.gmail,
  'LinkedIn': SocialIcons.linkedin_rect
};

class Link {
  String source;
  String description;
  IconData icon;

  Link(this.source, this.description) {
    if (source == null || source.isEmpty) {
      throw ArgumentError("Need source");
    } else {
      source = this.source;
    }
    if (description == null || description.isEmpty) {
      description = source;
      icon = MdiIcons.linkVariant;
    } else {
      description = this.description;
      icon = iconDict[description];
    }
  }

}
