import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localizacao_map/models/directions_model.dart';
import 'package:localizacao_map/repositorys/adress_repository.dart';
import 'package:localizacao_map/repositorys/directions_repository.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController? _mapController;
  LatLng _initialPosition = LatLng(-17.8904935, -51.7301461);
  LatLng _destinePosition = LatLng(-17.8904935, -51.7301461);

  Marker? _destination;

  Directions? _info;

  Location _location = Location();

  bool titleSearch = false;

  TextEditingController textSearchController = TextEditingController();

  void _onMapCreated(GoogleMapController _cntlr) {
    _mapController = _cntlr;
    _location.onLocationChanged.listen((l) {
      _initialPosition = LatLng(l.latitude!, l.longitude!);
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
        ),
      );
    });
  }

  void _addMarker(LatLng pos) async {
    setState(() {
      _destinePosition = pos;
      _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon:
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos);
    });

    final directions = await DirectionsRepository().getDirections(
        origin: _initialPosition, destination: _destinePosition);
    setState(() {
      _info = directions;
    });
  }

  void _adress(String adress) async {
    final adressResult = await AdressRepository().getAdress(adress: adress);
    final pos = LatLng(adressResult!.results![0].geometry!.location!.lat!, adressResult.results![0].geometry!.location!.lng!);
    _addMarker(pos);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: titleSearch ? TextBox(textSearchController) : Text("Adress"),
        leading: IconButton(
          icon: Icon(titleSearch ? Icons.done : Icons.search),
          onPressed: () {
            if(titleSearch){
              _adress(textSearchController.value.text.toString());
            }
            setState(() {
              titleSearch = !titleSearch;
            });
          },
        ),
        actions: [
          if (_destination != null)
            TextButton(
                onPressed: () => _mapController?.animateCamera(
                      CameraUpdate.newCameraPosition(CameraPosition(
                          target: _destination!.position,
                          zoom: 16.5,
                          tilt: 50.0)),
                    ),
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    textStyle: const TextStyle(fontWeight: FontWeight.w600)),
                child: const Text('Destination'))
        ],
      ),
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
                  CameraPosition(target: _initialPosition, zoom: 13.5),
              onMapCreated: _onMapCreated,
              markers: {
                if (_destination != null) _destination!
              },
              polylines: {
                if (_info != null)
                  Polyline(
                    polylineId: const PolylineId('overview_polyline'),
                    color: Colors.red,
                    width: 5,
                    points: _info!.polyLinePoints
                        .map((e) => LatLng(e.latitude, e.longitude))
                        .toList(),
                  )
              },
              onTap: _addMarker,
            ),
            if (_info != null)
              Container(
                  margin: EdgeInsets.only(top: 5),
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey,
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
                          fontSize: 18.0, fontWeight: FontWeight.w600),
                    ),
                  )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        onPressed: () => _mapController?.moveCamera(
          _info != null
              ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0)
              : CameraUpdate.newLatLng(_initialPosition),
        ),
        child: const Icon(Icons.center_focus_strong),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class TextBox extends StatelessWidget {

  TextEditingController? textEditingController;

  TextBox(TextEditingController textController){
    textEditingController = textController;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.white,
      child: TextField(
        controller: textEditingController,
        decoration:
        InputDecoration(border: OutlineInputBorder(), hintText: 'Search'),
      ),
    );
  }
}