import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:points_map/models/point.dart';

class PointsRepository{
  Future<List<Point>> getPoints(Category category)async {

    List<Point> listPoints = [];
    if(category == Category.CLOTHING){
      listPoints.add(new Point('Cantinho Da Moda', LatLng(-17.883722080524077, -51.71416583515889), Category.CLOTHING));
      listPoints.add(new Point('Transatom Jeans - Loja Fábrica', LatLng(-17.871120184162535, -51.723158080032064), Category.CLOTHING));
      listPoints.add(new Point('Top 10', LatLng(-17.88584612625579, -51.714443816701475), Category.CLOTHING));
      listPoints.add(new Point('Conserta-Se Roupas Dona Vera,', LatLng(-17.871461894237015, -51.72266600332955), Category.CLOTHING));
      listPoints.add(new Point('Império Do Jeans', LatLng(-17.884028393357752, -51.71385553146758), Category.CLOTHING));
      listPoints.add(new Point('Tramp Modas', LatLng(-17.886964003023422, -51.72443659479639), Category.CLOTHING));
      listPoints.add(new Point('Intuição Modas', LatLng(-17.881447297191006, -51.7162857047655), Category.CLOTHING));
      listPoints.add(new Point('Loja Kamaroty', LatLng(-17.881534783742023, -51.72979231124285), Category.CLOTHING));
      listPoints.add(new Point('Roupas Reformadas', LatLng(-17.88014033975535, -51.71809118429765), Category.CLOTHING));
    }
    else if(category == Category.FOOD){
      listPoints.add(new Point('Temakaria sushi', LatLng(-17.88010917185558, -51.72891699249856), Category.FOOD));
      listPoints.add(new Point('Açaí.com', LatLng(-17.87247562953431, -51.730743961499), Category.FOOD));
      listPoints.add(new Point('Max Burguer', LatLng(-17.8855762750019, -51.730334669451196), Category.FOOD));
      listPoints.add(new Point('Empório Sabor e Vida', LatLng(-17.88247415299513, -51.7285055311365), Category.FOOD));
      listPoints.add(new Point('Pizzaria Jatai', LatLng(-17.884203457674985, -51.725470128881405), Category.FOOD));
      listPoints.add(new Point('Giraffas', LatLng(-17.87255731818039, -51.730841142179834), Category.FOOD));
    }
    else if(category == Category.SUPERMARKET){
      listPoints.add(new Point('Supermercado Jataí', LatLng(-17.884430828185618, -51.72671769364735), Category.SUPERMARKET));
      listPoints.add(new Point('Supermercado Tropical', LatLng(-17.87820421156717, -51.72418104877551), Category.SUPERMARKET));
      listPoints.add(new Point('Frios Jataí', LatLng(-17.874399017759668, -51.7226312726485), Category.SUPERMARKET));
      listPoints.add(new Point('Supermercado Verdão', LatLng(-17.871866338988614, -51.72677027433017), Category.SUPERMARKET));
      listPoints.add(new Point('Tosta Supermercados', LatLng(-17.88834383116281, -51.72324013002999), Category.SUPERMARKET));
      listPoints.add(new Point('Comercial Atacadão', LatLng(-17.87505251880195, -51.721568223223045), Category.SUPERMARKET));
      listPoints.add(new Point('Supermercado e Casa de Carnes Brasil', LatLng(-17.874341543732537, -51.7187053416804), Category.SUPERMARKET));
      listPoints.add(new Point('Bretas', LatLng(-17.87247562953431, -51.73093382286067), Category.SUPERMARKET));
      listPoints.add(new Point('Supermercado Super 1', LatLng(-17.89115584023458, -51.72182625788088), Category.SUPERMARKET));
      listPoints.add(new Point('Comercial Suprilar', LatLng(-17.85632353121076, -51.729682447680624), Category.SUPERMARKET));
    }
    else if(category == Category.VA){
      listPoints.add(new Point('Vantagens Aqui', LatLng(-17.883117569765066, -51.73708499668697), Category.VA));
    }
  
    return listPoints;
  }

}