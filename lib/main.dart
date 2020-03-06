import 'dart:async';
import 'package:flutter/cupertino.dart';
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
  static String message = 'Hii';
  final Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  static LatLng _initialPosition;
  String googleAPIKey = "AAIzaSyAeD5DJVHgXbYnZrCO37KZX3cvmT3Mtysc";
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

    // List<PointLatLng> result = await polylinePoints?.getRouteBetweenCoordinates(
    //     googleAPIKey,
    //     _initialPosition.latitude,
    //     _initialPosition.longitude,
    //     latlng.latitude,
    //     latlng.longitude);
    // if (result.isNotEmpty) {
    //   // loop through all PointLatLng points and convert them
    //   // to a list of LatLng, required by the Polyline
    //   result.forEach((PointLatLng point) {
    //     polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    //   });
    // }
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
    print(message);
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 40.0,
                                    left: 40.0,
                                    right: 40.0,
                                    bottom: 20.0),
                                child: TextField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red, //this has no effect
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    hintText: "Enter Source ...",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40.0),
                                child: TextField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red, //this has no effect
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    hintText: "Enter Destination ...",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(40.0),
                            topRight: const Radius.circular(40.0),
                          ),
                          child: Container(
                            height: 250,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.only(
                                top: 20.0, left: 5.0, right: 5.0),
                            child: Column(
                              children: <Widget>[
                                Text('Select Your Travelling Options'),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 20.0, 0, 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Icon(
                                            Icons.local_taxi,
                                            color: Colors.pink,
                                            size: 42.0,
                                            semanticLabel:
                                                'Text to announce in accessibility modes',
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Text("Rs.200")
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Icon(
                                            Icons.train,
                                            color: Colors.green,
                                            size: 40.0,
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Text("Rs.500")
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Icon(
                                            Icons.airplanemode_active,
                                            color: Colors.blue,
                                            size: 42.0,
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Text("Rs.1000")
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                RaisedButton(
                                  textColor: Colors.white,
                                  color: Colors.black,
                                  child: Text("Buy Tickets"),
                                  padding: EdgeInsets.fromLTRB(
                                      30.0, 20.0, 30.0, 20.0),
                                  onPressed: () {},
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
