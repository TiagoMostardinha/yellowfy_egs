import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yellowfy/common/Handlers.dart';
import 'package:yellowfy/models/announcements.dart';

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
  final Handlers handlers = Handlers(); // Create an instance of Handlers

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  static const LatLng _center = LatLng(40.6360, -8.6532);

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
      _fetchAnnouncements(); // Fetch announcements when location is acquired
    });
  }

  Future<void> _fetchAnnouncements() async {
    if (currentLocation != null) {
      try {
        List<Announcement> announcements =
            await handlers.handleGetAnnouncementsByGPS(
          _radius,
          currentLocation!.latitude,
          currentLocation!.longitude,
        );
        print('Announcements fetched: ${announcements.length}');
        _updateMarkers(announcements);
      } catch (e) {
        print('Error fetching announcements: $e');
      }
    }
  }

  void _updateMarkers(List<Announcement> announcements) {
    setState(() {
      markers.clear();
      for (var announcement in announcements) {
        markers.add(
          Marker(
            markerId:
                MarkerId(announcement.id.toString()), // Ensure unique markerId
            position: LatLng(
              announcement.coordinates.latitude,
              announcement.coordinates.longitude,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueYellow),
            infoWindow: InfoWindow(
              title: announcement.category,
              snippet: announcement.description,
            ),
          ),
        );
      }
      print('Markers updated: ${markers.length}');
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (currentLocation != null) {
      mapController?.animateCamera(CameraUpdate.newLatLng(currentLocation!));
    }
  }

  void _increaseRadius() {
    setState(() {
      _radius += 500; // Increase the radius by 500 meters
    });
    _fetchAnnouncements(); // Fetch announcements with the new radius
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YellowFinder'),
        backgroundColor: Colors.yellowAccent[700],
        centerTitle: true,
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
                    _fetchAnnouncements(); // Refetch announcements with the new radius
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
