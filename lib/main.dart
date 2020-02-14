import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  static LatLng _initialPosition;
  String googleAPIKey = "AIzaSyB9F6whZU8WRP9eUIxxS4Slub6oWUNBlvk";

  // this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];
// this is the key object - the PolylinePoints
// which generates every polyline between start and finish
  PolylinePoints polylinePoints = PolylinePoints();

  LatLng latlng;
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  addPolyline() async {
    latlng = LatLng(19.1981, 72.8259);
//    _polyline.add(Polyline(
//      polylineId: PolylineId('line1'),
//      visible: true,
//      //latlng is List<LatLng>
//      points: latlng,
//      color: Colors.blue,
//    ));

    List<PointLatLng> result = await polylinePoints?.getRouteBetweenCoordinates(
        googleAPIKey,
        _initialPosition.latitude,
        _initialPosition.longitude,
        latlng.latitude,
        latlng.longitude);
    if (result.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates);

      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);
    });
  }

  void _getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: _initialPosition,
    zoom: 14.4746,
  );

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    addPolyline();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: _initialPosition == null
              ? Container(
                  child: Center(
                    child: Text(
                      'loading map..',
                      style: TextStyle(
                          fontFamily: 'Avenir-Medium', color: Colors.grey[400]),
                    ),
                  ),
                )
              : Container(
                  child: Stack(
                    children: <Widget>[
                      GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: _kGooglePlex,
                        myLocationEnabled: true,
                        compassEnabled: true,
                        myLocationButtonEnabled: false,
                        polylines: _polylines,
                      ),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: TextField(
                              style: TextStyle(backgroundColor: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Enter Place here",
                                hintStyle: TextStyle(
                                  color: Color(0xFF757575),
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
    );
  }
}
