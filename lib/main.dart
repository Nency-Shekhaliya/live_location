import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(Live_location());
}

class Live_location extends StatefulWidget {
  const Live_location({Key? key}) : super(key: key);

  @override
  State<Live_location> createState() => _Live_locationState();
}

class _Live_locationState extends State<Live_location> {
  Getlocationpermission() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isDenied) {
      Permission.location.request();
    }
  }

  @override
  void initState() {
    super.initState();
    Getlocationpermission();
  }

  double lat = 0;
  double long = 0;
  Placemark placemark = Placemark();
  Completer<GoogleMapController> mapcontroller = Completer();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Live Location1"),
            centerTitle: true,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 20,
                    child: GoogleMap(
                      onMapCreated: (con) {
                        setState(() {
                          mapcontroller.complete(con);
                        });
                      },
                      initialCameraPosition: CameraPosition(
                          target: LatLng(lat, long),
                          bearing: 0,
                          tilt: 0,
                          zoom: 70),
                      mapType: MapType.normal,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      onPressed: () async {
                        if (await Permission.location.isDenied) {
                          Permission.location.request();
                        } else {
                          setState(() {
                            Geolocator.getPositionStream()
                                .listen((event) async {
                              lat = event.latitude;
                              long = event.longitude;
                              List<Placemark> Place =
                                  await placemarkFromCoordinates(lat, long);
                              placemark = Place[0];
                            });
                          });
                        }
                      },
                      child: Icon(Icons.location_searching_rounded),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
