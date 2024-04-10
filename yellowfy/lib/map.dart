import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? mapController;
  LatLng? currentLocation;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Define an initial camera position
  static const LatLng _center = const LatLng(40.6360, -8.6532);

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // Add a variable to store the selected job type
  String _selectedJobType = 'All Jobs';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YellowFinder'),
        backgroundColor: Colors.yellowAccent[700],
        centerTitle: true,
        actions: [
          // Add a PopupMenuButton for the filter
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_list),
            onSelected: (String value) {
              setState(() {
                _selectedJobType = value;
              });
              // Perform filtering based on the selected job type
              // Update the map markers accordingly
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'All Jobs',
                child: Text('All Jobs'),
              ),
              const PopupMenuItem<String>(
                value: 'Plumber',
                child: Text('Plumber'),
              ),
              const PopupMenuItem<String>(
                value: 'Contractor',
                child: Text('Contractor'),
              ),
              const PopupMenuItem<String>(
                value: 'Painter',
                child: Text('Painter'),
              ),
            ],
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        initialCameraPosition: const CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: markers,
        /*
        circles: {
          Circle(
            circleId: CircleId('1'),
            center: _center,
            radius: 1000,
            fillColor: Colors.blue.withOpacity(0.1),
            strokeWidth: 1,
            strokeColor: Colors.blue,
          ),
        },
        */
      ),
    );
  }
}
