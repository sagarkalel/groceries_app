import 'package:flutter/material.dart';
import 'package:groceries_app/models/category.dart';

const categories = {
  Categories.vegetables:
      Category("Vegetables", Color.fromARGB(255, 162, 245, 164)),
  Categories.fruits: Category("Fruit", Color.fromARGB(255, 224, 255, 137)),
  Categories.meat: Category("Meat", Color.fromARGB(255, 245, 158, 100)),
  Categories.dairy: Category("Dairy", Color.fromARGB(255, 108, 194, 164)),
  Categories.carbs: Category("Carbs", Color.fromARGB(255, 73, 113, 246)),
  Categories.sweets: Category("Sweets", Color.fromARGB(255, 246, 62, 62)),
  Categories.spices: Category("Spices", Color.fromARGB(255, 255, 255, 191)),
  Categories.hygiene: Category("Hygiene", Color.fromARGB(255, 241, 95, 202)),
  Categories.other: Category("Othber", Color.fromARGB(255, 120, 19, 197)),
  Categories.convenience:
      Category("Convenience", Color.fromARGB(255, 138, 246, 235)),
};
