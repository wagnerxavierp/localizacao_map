import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:points_map/components/item_category.dart';
import 'package:points_map/components/item_point.dart';
import 'package:points_map/components/menu_points.dart';
import 'package:points_map/components/text_field_search.dart';
import 'package:points_map/models/directions_model.dart';
import 'package:points_map/models/point.dart';
import 'package:points_map/repositorys/adress_repository.dart';
import 'package:points_map/repositorys/directions_repository.dart';
import 'package:location/location.dart';
import 'package:points_map/repositorys/points_repository.dart';
import 'dart:ui' as ui;

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController? _mapController;

  LatLng _initialPosition = LatLng(-17.8904935, -51.7301461);
  LatLng? _destinePosition;

  Marker? _destinationMarker;
  List<Marker> _customMarkers = [];
  List<Point> _points = [];

  Directions? _info;

  Location _location = Location();

  bool _routeOn = false;

  TextEditingController _textSearchController = TextEditingController();


  void removeRoutes(){
    _destinePosition = null;
    _customMarkers.remove(_destinationMarker);
    _info = null;
    _points.clear();
    _routeOn = false;
  }


  List<Widget> listPoints(){
    var list = <Widget>[];

    _points.asMap().forEach((index, element) {
      list.add(
        ItemPoint(
          element: element, 
          image: Image.asset(pathCategoryPin(element.category)), 
          onPressed: () async {
            selectPoint(index, element);
          }
        )
      );
    });

    return list;
  }

  void selectPoint(int indexMaker, Point element) async {
    _customMarkers = [_customMarkers[indexMaker]];
    removeRoutes();

    setState(() {
      _mapController!.showMarkerInfoWindow(_customMarkers[0].markerId);
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: element.latLng, zoom: 15, tilt: 50.0),
        ),
      );
    });

    _destinePosition = element.latLng;
    
    var locationData = await _location.getLocation();
      _initialPosition = LatLng(locationData.latitude!, locationData.longitude!);

      final directions = await DirectionsRepository().getDirections(
        origin: _initialPosition, 
        destination: _destinePosition!
      );

    setState(() {
      _info = directions;
    });
  }

  List<Widget> listCategories(){
    var list = <Widget>[];

    Category.values.forEach((element) { 
      list.add(
        ItemCategory(
          element: element, 
          image: Image.asset(pathCategoryPin(element)), 
          onPressed: (){
            _routeOn = false;
            removeRoutes();
            _customMarkers.clear();
            
            PointsRepository().getPoints(element).then((pointsIt) async {
              _points = pointsIt;

              pointsIt.asMap().forEach((index, element) async {
                final Uint8List markerIcon = await getBytesFromAsset(pathCategoryPin(element.category), 70);

                setState(() {
                  _customMarkers.add(
                    markerCategory(index, element, markerIcon)
                  );
                });
              });
            });

          })
      );
    });

    return list;
  }

  Marker markerCategory(int indexMarker, Point elementIt, Uint8List markerIconIt){
    return 
    Marker(
      markerId: MarkerId(elementIt.title),
      position: elementIt.latLng,
      infoWindow: InfoWindow(title: elementIt.title),
      icon: BitmapDescriptor.fromBytes(markerIconIt),
      onTap: () async {
        selectPoint(indexMarker, elementIt);
      },
    );
  }

  String pathCategoryPin(Category category){
    if(category == Category.FOOD) return 'assets/images/pin_food.png';
    if(category == Category.CLOTHING) return 'assets/images/pin_clothing.png';
    if(category == Category.SUPERMARKET) return 'assets/images/pin_supermarket.png';
    if(category == Category.VA) return 'assets/images/pin_va.png';
    return '';
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _mapController = _cntlr;
    focusOnCurrentLocation();
  }

  Future<bool> focusOnCurrentLocation() async {
    try{
    var locationData = await _location.getLocation();
    _initialPosition = LatLng(locationData.latitude!, locationData.longitude!);
    _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _initialPosition, zoom: 15, tilt: 50.0),
      ),
    );
    }catch(e){
      return false;
    }
    return true;
  }

  void _addMarker(LatLng pos) async {
    removeRoutes();
    _customMarkers.clear();
    var locationData = await _location.getLocation();
    _initialPosition = LatLng(locationData.latitude!, locationData.longitude!);
    setState(() {
      _destinePosition = pos;
      _destinationMarker = Marker(
          markerId: const MarkerId('destination'),
          onTap: (){
            setState(() {
              removeRoutes();
            });
          },
          icon:
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos
        );
      _customMarkers.add(
        _destinationMarker!
      );
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: pos, zoom: 15, tilt: 50.0),
        ),
      );
    });

    final directions = await DirectionsRepository().getDirections(
                            origin: _initialPosition, destination: _destinePosition!);
                          setState(() {
                            _info = directions;
                          });
  }

  void _adress(String adress) async {
    if(adress.isNotEmpty){
      final adressResult = await AdressRepository().getAdress(adress: adress);
      final pos = LatLng(adressResult!.results![0].geometry!.location!.lat!, adressResult.results![0].geometry!.location!.lng!);
      _addMarker(pos);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            GoogleMap(
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              initialCameraPosition:
                  CameraPosition(target: _initialPosition, zoom: 13.5, tilt: 50.0),
              onMapCreated: _onMapCreated,
              markers: _customMarkers.toSet(),
              polylines: {
                if (_info != null && _routeOn)
                  Polyline(
                    polylineId: const PolylineId('overview_polyline'),
                    color: Colors.red,
                    width: 5,
                    points: _info!.polyLinePoints
                        .map((e) => LatLng(e.latitude, e.longitude))
                        .toList(),
                  )
              },
              onTap: (posIt){
                if(_points.length == 0){
                  _addMarker(posIt);
                }else{
                  setState(() {
                    removeRoutes();
                    _customMarkers.clear();
                  });
                }
              },
            ),
            if (_info != null)
              Container(
                  margin: EdgeInsets.only(bottom: 20),
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 15.0),
                    decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 6.0)
                        ]),
                    child: Text(
                      '${_info!.totalDistance}, ${_info!.totalDuration}',
                      style: const TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  )
              ),
            TextFieldSearch(
              hint: "Endereço",
              textSearchController: _textSearchController,
              search:(){
                if(_textSearchController.value.text.toString().isNotEmpty){
                  _adress(_textSearchController.value.text.toString());
                }
              }
            ),
            Container(
              margin: EdgeInsets.only(top: 130, right: 10, left: 10),
              height: 46.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: listCategories(),
              ),
            ),
            if(_points.length > 0)
              Positioned(
                left: 0,
                right: 0,
                bottom: 20,
                child: MenuPoints(listWidgets: listPoints()),
              )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                if(_destinePosition != null)
                FloatingActionButton(
                  onPressed: () async{

                    setState(() {
                      if(_routeOn){
                        removeRoutes();
                        _location = Location();
                        _customMarkers.clear();
                      }
                      else{
                        _routeOn = true;
                      }

                      _location.onLocationChanged.listen((l) async {
                        if(_routeOn){
                          _initialPosition = LatLng(l.latitude!, l.longitude!);

                          _mapController?.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                            target: LatLng(l.latitude!, l.longitude!),
                            zoom: 16.5,
                            tilt: 50.0)),
                          );
                        }
                      });
                    });
                  },
                  child: Icon(!_routeOn ? Icons.navigation_rounded : Icons.stop_screen_share_rounded),
                ),
                SizedBox(height: 25),
                FloatingActionButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  onPressed: () {
                    focusOnCurrentLocation();
                  },
                  child: const Icon(Icons.my_location_sharp)
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
 // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
