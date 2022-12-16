// To parse this JSON data, do
//
//     final petsModel = petsModelFromMap(jsonString);

import 'dart:convert';

class Pets {
  Pets({
    required this.age,
    required this.chip,
    this.image,
    required this.name,
    required this.race,
    this.id
  });

  int age;
  bool chip;
  String? image;
  String name;
  String race;
  String? id;

  factory Pets.fromJson(String str) => Pets.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Pets.fromMap(Map<String, dynamic> json) => Pets(
    age: json["age"],
    chip: json["chip"],
    image: json["image"],
    name: json["name"],
    race: json["race"]
  );

  Map<String, dynamic> toMap() => {
    "age": age,
    "chip": chip,
    "image": image,
    "name": name,
    "race": race
  };

  Pets copy() => Pets(
    age: age,
    chip: chip,
    image: image,
    name: name,
    race: race,
    id: id
  );

}
