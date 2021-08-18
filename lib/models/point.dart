import 'package:google_maps_flutter/google_maps_flutter.dart';

class Point{
  String title;
  LatLng latLng;
  Category category;

  Point(this.title, this.latLng, this.category);

  
}

enum Category{
    VA, FOOD, SUPERMARKET, CLOTHING
  }

  extension CatExtension on Category {

  String get name {
    switch (this) {
      case Category.FOOD:
        return 'Alimentação';
      case Category.SUPERMARKET:
        return 'Supermercado';
      case Category.CLOTHING:
        return 'Vestuário';
      case Category.VA:
        return 'Vantagens Aqui';
      default:
        return "";
    }
  }

}