import 'package:carmen/example_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Marker> markers;
  late List<LatLng> points;
  final PopupController _popupLayerController = PopupController();

  List<Color> colors = [Colors.blue, Colors.green, Colors.red, Colors.black];

  @override
  void initState() {
    super.initState();
    points = <LatLng>[];
    points.add(LatLng(-8.89074, -36.4966));
    points.add(LatLng(37.090240, -95.712891));
    points.add(LatLng(-38.416097, -63.616672));
    points.add(LatLng(-8.783195, 34.508523));

    markers = <Marker>[];
    for (int i = 0; i < points.length; i++) {
      markers.add(Marker(
        width: 80.0,
        height: 80.0,
        point: points.elementAt(i),
        builder: (ctx) => Icon(Icons.pin_drop, color: colors[i]),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Flexible(
                      child: FlutterMap(
                        options: MapOptions(
                          center: LatLng(-8.89074, -36.4966),
                          zoom: 2,
                          onTap: (_, __) => _popupLayerController
                              .hideAllPopups(), // Hide popup when the map is tapped.
                        ),
                        children: [
                          TileLayerWidget(
                            options: TileLayerOptions(
                                urlTemplate:
                                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                subdomains: ['a', 'b', 'c']),
                          ),
                          PolylineLayerWidget(
                            options: PolylineLayerOptions(
                                polylineCulling: false,
                                polylines: [
                                  Polyline(
                                    points: points,
                                  )
                                ]),
                          ),
                          PopupMarkerLayerWidget(
                            options: PopupMarkerLayerOptions(
                                popupController: _popupLayerController,
                                markers: markers,
                                markerRotateAlignment: PopupMarkerLayerOptions
                                    .rotationAlignmentFor(AnchorAlign.top),
                                popupBuilder:
                                    (BuildContext context, Marker marker) =>
                                        ExamplePopup(marker)),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("Where's CS?"),
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
