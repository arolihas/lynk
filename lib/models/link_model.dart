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
  int linkID;
  String source;
  String description;
  IconData icon;

  Link({this.linkID, this.source, this.description, this.icon});

  Link.construct(source, description) {
    
    if (source == null || source.isEmpty) {
      throw ArgumentError("Need source");
    } else {
      this.source = source;
    }
    
    if (description == null || description.isEmpty) {
      this.description = source;
      this.icon = MdiIcons.linkVariant;
    } else {
      this.description = description;
      this.icon = iconDict[description];
    }

  }

  factory Link.fromJson(Map<String, dynamic> json) => new Link(
    linkID: json["linkID"],
    source: json["source"],
    description: json["description"]
  );

  Map<String, dynamic> toJson() => {
    "linkID": linkID,
    "source": source,
    "description": description
  };  

}
