import 'package:flutter/material.dart';
import 'package:lynk_mobile/models/link_model.dart';
import 'package:random_string/random_string.dart';

int linkLength = 15;

class User {
  String name;
  String url = randomAlphaNumeric(linkLength);
  Image pic;
  List<Link> links = [];
  
  User({
    this.name,
    this.url,
    this.pic,
    this.links
  });

  User._(name, pic, links) {
    
    if (name == null || name.isEmpty) {
      throw ArgumentError("Need name");
    } else {
      this.name = name;
    }

    if (pic == null || pic.isEmpty) {
      this.pic = Image.asset('images/person.png');
    } else {
      this.pic = pic;
    }

    if (links == null || links.isEmpty) {
      this.links = [];
    } else {
      this.links = links;
    }

  }

  factory User.fromJson(Map<String, dynamic> json) => new User(
    name: json["name"],
    url: json["url"],
    pic: json["pic"],
    links: json["links"]
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "url": url,
    "pic": pic,
    "links": links
  };

}