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
  Set<Marker> markers = {};

  // Replace this with your actual list of announcement locations
  List<String> announcementLocations = [
    '40.1234 -8.5678', // Example format: latitude longitude
    // Add more announcement locations as needed
  ];

  @override
  void initState() {
    super.initState();
    _setMarkers();
  }

  void _setMarkers() {
    setState(() {
      markers = _buildMarkers(announcementLocations);
    });
  }

  Set<Marker> _buildMarkers(List<String> locations) {
    return locations.map((location) {
      var latLng = location.split(' ');
      double lat = double.parse(latLng[0]);
      double lng = double.parse(latLng[1]);
      return Marker(
        markerId: MarkerId(location),
        position: LatLng(lat, lng),
      );
    }).toSet();
  }

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
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        initialCameraPosition: const CameraPosition(
          target: LatLng(40.6360, -8.6532),
          zoom: 11.0,
        ),
        markers: markers,
      ),
    );
  }
}
