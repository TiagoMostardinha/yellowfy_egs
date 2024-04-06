import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? mapController;

  // Define an initial camera position
  static const LatLng _center = const LatLng(40.6306, -8.6571);

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
        initialCameraPosition: const CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),
    );
  }
}
