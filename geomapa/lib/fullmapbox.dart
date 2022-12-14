import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'main.dart';
import 'page.dart';

class FullMapPage2 extends MainPage {
  FullMapPage2() : super(const Icon(Icons.map), 'Mapa en patalla completa V2');

  @override
  Widget build(BuildContext context) {
    return const FullMap();
  }
}

class FullMap extends StatefulWidget {
  const FullMap();

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<FullMap> {
  final center = LatLng(-33.852, 151.211);
  final streetStyle = 'mapbox://styles/ever1ck/clb2asf1u000314mjuzxp3s9p';
  final sateliteStyle = 'mapbox://styles/ever1ck/clb2au9cm002k14ojy6gald7s';
  final oscuroStyle = 'mapbox://styles/ever1ck/clb2aqo9j000314p4150bu44x';
  bool _myLocationEnabled = true;
  bool _zoomGesturesEnabled = true;
  MyLocationTrackingMode _myLocationTrackingMode = MyLocationTrackingMode.None;

  MapboxMapController? mapController;
  var isLight = true;

  _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  _onStyleLoadedCallback() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Style loaded :)"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 1),
    ));
  }

  Widget _myLocationTrackingModeCycler() {
    final MyLocationTrackingMode nextType = MyLocationTrackingMode.values[
        (_myLocationTrackingMode.index + 1) %
            MyLocationTrackingMode.values.length];
    return FloatingActionButton(
      child: Icon(Icons.location_searching),
      onPressed: () {
        setState(() {
          _myLocationTrackingMode = nextType;
        });
      },
    );
  }

  Widget _myLocationToggler() {
    return TextButton(
      child: Text('${_myLocationEnabled ? 'disable' : 'enable'} my location'),
      onPressed: () {
        setState(() {
          _myLocationEnabled = !_myLocationEnabled;
        });
      },
    );
  }

  Widget _zoomToggler() {
    return TextButton(
      child: Text('${_zoomGesturesEnabled ? 'disable' : 'enable'} zoom'),
      onPressed: () {
        setState(() {
          _zoomGesturesEnabled = !_zoomGesturesEnabled;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: FloatingActionButton(
                child: Icon(Icons.swap_horiz),
                onPressed: () => setState(
                  () => isLight = !isLight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: _myLocationTrackingModeCycler(),
            )
          ],
        ),
        body: MapboxMap(
          styleString: isLight ? streetStyle : sateliteStyle,
          accessToken: MapsFlutter.ACCESS_TOKEN,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(target: center, zoom: 14),
          onStyleLoadedCallback: _onStyleLoadedCallback,
          myLocationEnabled: _myLocationEnabled,
          myLocationTrackingMode: _myLocationTrackingMode,
          myLocationRenderMode: MyLocationRenderMode.GPS,
          zoomGesturesEnabled: _zoomGesturesEnabled,
        ));
  }
}
