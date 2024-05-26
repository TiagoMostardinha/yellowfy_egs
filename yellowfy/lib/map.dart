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
  double _radius = 1000; // Initial radius in meters

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  static const LatLng _center = const LatLng(40.6360, -8.6532);

  Future<void> _getCurrentLocation() async {
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
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
      mapController?.animateCamera(CameraUpdate.newLatLng(currentLocation!));
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (currentLocation != null) {
      mapController?.animateCamera(CameraUpdate.newLatLng(currentLocation!));
    }
  }

  String _selectedJobType = 'All Jobs';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YellowFinder'),
        backgroundColor: Colors.yellowAccent[700],
        centerTitle: true,
        actions: [
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
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            initialCameraPosition: const CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            markers: markers,
            circles: currentLocation != null
                ? {
                    Circle(
                      circleId: CircleId('radius_circle'),
                      center: currentLocation!,
                      radius: _radius,
                      fillColor: Colors.blue.withOpacity(0.1),
                      strokeWidth: 1,
                      strokeColor: Colors.blue,
                    ),
                  }
                : {},
          ),
          Positioned(
            bottom: 50,
            left: 10,
            right: 10,
            child: Column(
              children: [
                Slider(
                  value: _radius,
                  min: 100,
                  max: 5000,
                  divisions: 49,
                  label: '${_radius.round()} meters',
                  onChanged: (double value) {
                    setState(() {
                      _radius = value;
                    });
                  },
                ),
                Text(
                  'Search Radius: ${_radius.round()} meters',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
