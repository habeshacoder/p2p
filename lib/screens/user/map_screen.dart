import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/appStyles/app_fontsize.dart';
import 'package:p2p/widgets/button.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _controller = TextEditingController();
  // MapType mapType = MapType.;
  late GoogleMapController _mapController;
  bool isNormalView = true;
  String API_KEY = "AIzaSyCJc75czqiuE1L-bq8WUYyZr0pR2kMt-m0";
  LatLng? currentLocation;
  LatLng? pickedLocation;
  String? choosenAdress;
  String? formatedAdd;
  bool addressConfimed = false;
  bool isLoading = false;
  CameraPosition cameraPosition = CameraPosition(
    target: LatLng(9.1450, 40.4897),
    zoom: 50,
  );

  Uint8List _createLiveLocationIcon() {
    final double size = 60.0;
    final Color outerCircleColor = Colors.red;
    final Color innerCircleColor = Colors.white;
    final Color centerCircleColor = Colors.red;
    final double strokeWidth = 2.0;

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final Paint outerCirclePaint = Paint()
      ..color = outerCircleColor
      ..style = PaintingStyle.fill;
    final Paint innerCirclePaint = Paint()
      ..color = innerCircleColor
      ..style = PaintingStyle.fill;
    final Paint centerCirclePaint = Paint()
      ..color = centerCircleColor
      ..style = PaintingStyle.fill;
    final double center = size / 2;
    final double radius = size / 2 - strokeWidth;

    canvas.drawCircle(Offset(center, center), radius, outerCirclePaint);
    canvas.drawCircle(
        Offset(center, center), radius - strokeWidth, innerCirclePaint);
    canvas.drawCircle(Offset(center, center), 5.0, centerCirclePaint);

    final ui.Picture picture = recorder.endRecording();
    final ui.Image image =
        picture.toImage(size.toInt(), size.toInt()) as ui.Image;
    final ByteData? byteData = image.toByteData() as ByteData?;
    return byteData!.buffer.asUint8List();
  }

  Set<Marker> _markers = {
    Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        // icon: BitmapDescriptor.fromBytes(_createLiveLocationIcon()),
        markerId: MarkerId('m1'),
        position: LatLng(9.1450, 40.4897))
  };

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    LatLng latLngC = currentLocation!;
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLngC.latitude},${latLngC.longitude}&key=${API_KEY}';

    http.get(Uri.parse(url)).then((value) {
      print('value:...$value');
      final formatedAdd =
          json.decode(value.body)['results'][0]['formatted_address'];
      print('formated address:.....$formatedAdd');
      _mapController
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: latLngC,
        zoom: 50,
      )));
      _markers.clear();
      setState(() {
        cameraPosition = CameraPosition(
          target: latLngC,
          zoom: 50,
        );
        _markers.add(Marker(
          infoWindow: InfoWindow(title: '${formatedAdd}'),
          icon: BitmapDescriptor.defaultMarker,
          markerId: MarkerId('m1'),
          position: latLngC,
        ));
      });
    });
  }

  Future<void> _getCurrentLocation() async {
    print('getting current location.............');

    Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then((position) {
      print('curretn POSITION........:${position}');
      print('current POSITION latitude........:${position.latitude}');
      LatLng latLngC = LatLng(position.latitude, position.longitude);
      currentLocation = latLngC;
      cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 7,
      );
    }).catchError((error) {
      print('Error getting current position: $error');
      cameraPosition = CameraPosition(
        target: LatLng(9.1450, 40.4897),
        zoom: 7,
      );
    });
  }

  getAddress(double lat, double long) {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=${API_KEY}';

    http.get(Uri.parse(url)).then((value) {
      print('value:...${value.body}');
      formatedAdd = json.decode(value.body)['results'][0]['formatted_address'];
      print('formated address:.....$formatedAdd');
      LatLng latLngC = LatLng(lat, long);
      pickedLocation = latLngC;
      choosenAdress = formatedAdd;
      _mapController
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: latLngC,
        zoom: 50,
      )));
      _markers.clear();
      setState(() {
        cameraPosition = CameraPosition(
          target: latLngC,
          zoom: 50,
        );
        _markers.add(Marker(
          infoWindow: InfoWindow(title: '${formatedAdd}'),
          icon: BitmapDescriptor.defaultMarker,
          markerId: MarkerId('m1'),
          position: latLngC,
        ));
      });
    });
  }

  @override
  void initState() {
    print('INIT STATE...........');
    _getCurrentLocation();
    // TODO: implement initState
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set the status bar color
      statusBarIconBrightness:
          Brightness.light, // Set the status bar text color
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    super.initState();
  }

  void showalert(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Tap on Map or Search Place',
            textAlign: TextAlign.justify,
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Okay'),
            ),
          ],
        );
      },
    );
  }

  void showalertConfirmation(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Your Selected Location',
            textAlign: TextAlign.justify,
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  addressConfimed = true;
                });
                Navigator.of(context).pop();
              },
              child: Text('Confirm'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // @override
  // void didChangeDependencies() {

  //   super.didChangeDependencies();
  // }

  @override
  void dispose() {
    _mapController.dispose();
    // TODO: implement dispose
    super.dispose();
    InkWell(
        onTap: () {
          if (pickedLocation != null) {
            Map<String, dynamic> data = {
              "street": choosenAdress,
              "latLang": pickedLocation,
            };
            print("data latlan------------------------:${data["latLang"]}");
            Navigator.pop(context, data);
          } else {
            showalert(
                'Please tap on your desired location on the map screen OR search a place and the required location will be picked');
          }
        },
        child: Container(
            // color: Colors.blue,
            decoration: BoxDecoration(
                color: P2pAppColors.black,
                borderRadius: BorderRadius.circular(15)),
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              'Select',
              style: TextStyle(color: Colors.white),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      bottomSheet: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: TextButton(
          onPressed: () {
            if (pickedLocation != null) {
              Map<String, dynamic> data = {
                "street": choosenAdress,
                "latLang": pickedLocation,
              };
              print("data latlan------------------------:${data["latLang"]}");
              Navigator.pop(context, data);
            } else {
              showalert(
                  'Please tap on your desired location on the map screen OR search a place and the required location will be picked');
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                P2pAppColors.black), // Background color
            side: MaterialStateProperty.all<BorderSide>(
              const BorderSide(
                width: 2.0, // Border width
              ),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0), // Border radius
              ),
            ),
          ),
          child: Text(
            'Done',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: P2pAppColors.white, // Text color
              fontSize: P2pFontSize.p2p23,
            ),
          ),
        ),
      ),

      /// The above code is written in Dart and it is defining a floatingActionButton widget.
      floatingActionButton: SearchMapPlaceWidget(
        hasClearButton: true,
        bgColor: Colors.white,
        textColor: Colors.black45,
        iconColor: P2pAppColors.orange,
        apiKey: '${API_KEY}',
        onSelected: (place) {
          setState(() {
            isLoading = true;
          });
          print('place onselected:.....${place.description}');

          print('place onselected:.....${place.fullJSON}');
          LatLng latLngC = LatLng(23.00, 34.56);
          dynamic formatedAdd;
          final plc = place;
          plc.geolocation.then(
            (value) {
              print('plc:.......${value!.coordinates}');
              latLngC = value.coordinates;
              pickedLocation = latLngC;
              choosenAdress = place.description;
            },
          ).then(
            (value) {
              final url =
                  'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLngC.latitude},${latLngC.longitude}&key=${API_KEY}';
              http.get(Uri.parse(url)).then(
                (value) {
                  print('value:...$value');
                  formatedAdd = json.decode(value.body)['results'][0]
                      ['formatted_address'];
                  print('formated address:.....$formatedAdd');
                },
              );
            },
          ).then((value) {
            _mapController
                .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: latLngC,
              zoom: 50,
            )));
            _markers.clear();
            setState(() {
              cameraPosition = CameraPosition(
                target: latLngC,
                zoom: 50,
              );
              _markers.add(Marker(
                infoWindow: InfoWindow(title: '${formatedAdd}'),
                icon: BitmapDescriptor.defaultMarker,
                markerId: MarkerId('m1'),
                position: latLngC,
              ));

              print('search result:.....${pickedLocation}');
            });
          });
          setState(() {
            isLoading = false;
          });
          print('state:------------$isLoading');
        },
      ),
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                ),
              )
            : GoogleMap(
                // mapType: mapType,
                onTap: (argument) {
                  setState(() {
                    isLoading = true;
                  });
                  getAddress(argument.latitude, argument.longitude);
                  setState(() {
                    isLoading = false;
                  });
                },
                onMapCreated: _onMapCreated,
                initialCameraPosition: cameraPosition,
                markers: _markers,
              ),
      ),
    );
  }
}

class LiveLocationIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer circle
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.withOpacity(0.3),
          ),
        ),
        // Inner dot
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}
