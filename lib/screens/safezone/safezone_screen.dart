import 'package:buddymensia/colors.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class SafezoneScreen extends StatefulWidget {
  const SafezoneScreen({super.key});

  @override
  _SafezoneScreenState createState() => _SafezoneScreenState();
}

class _SafezoneScreenState extends State<SafezoneScreen> {
  GoogleMapController? _mapController;
  LatLng targetLocation = LatLng(-6.4145297746401,
      106.80978962510416); // Ganti dengan koordinat yang Anda inginkan
  Position? _currentPosition;
  double _distanceInMeters = 0.0;
  Circle? _circle;
  final double _radius = 200; // Radius dalam meter
  String _targetAddress = '';
  Marker? _targetMarker;

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _getTargetAddress();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Periksa apakah layanan lokasi diaktifkan
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Lokasi tidak diaktifkan, periksa apakah bisa diaktifkan
      return Future.error('Layanan lokasi tidak diaktifkan.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Jika izin ditolak
        return Future.error('Izin lokasi ditolak');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Ketika izin ditolak secara permanen
      return Future.error(
          'Izin lokasi ditolak secara permanen, kami tidak dapat meminta izin.');
    }

    // Mendapatkan posisi saat ini
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _distanceInMeters = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        targetLocation.latitude,
        targetLocation.longitude,
      );

      _circle = Circle(
        circleId: CircleId("circle"),
        center: targetLocation,
        radius: _radius,
        fillColor: _distanceInMeters > _radius ? Colors.redAccent.withOpacity(0.2) : AppColors.hijauTuaSecondary.withOpacity(0.2),
        strokeColor: _distanceInMeters > _radius ? Colors.redAccent : AppColors.hijauTuaSecondary,
        strokeWidth: 2,
      );
    });

    _mapController?.animateCamera(CameraUpdate.newLatLng(
      LatLng(targetLocation.latitude, targetLocation.longitude),
    ));
  }

  Future<void> _getTargetAddress() async {
    try {
      // Melakukan reverse geocoding menggunakan geocoding package
      List<Placemark> placemarks = await placemarkFromCoordinates(
        targetLocation.latitude,
        targetLocation.longitude,
      );

      Placemark place = placemarks[0];
      setState(() {
        // Menyimpan informasi alamat
        _targetAddress =
            '${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      });
    } catch (e) {
      print('Error saat mendapatkan alamat: $e');
      setState(() {
        _targetAddress = 'Tidak dapat menemukan alamat untuk lokasi ini.';
      });
    }
  }

  void _onMapTap(LatLng position) async {
    setState(() {
      targetLocation = position; // Update lokasi target
    });

    // Update jarak dan alamat berdasarkan lokasi baru
    _distanceInMeters = Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      targetLocation.latitude,
      targetLocation.longitude,
    );

    await _getTargetAddress(); // Dapatkan alamat untuk lokasi baru

    setState(() {
      _circle = Circle(
        circleId: CircleId("circle"),
        center: targetLocation,
        radius: _radius,
        fillColor: _distanceInMeters > _radius ? Colors.redAccent.withOpacity(0.2) : AppColors.hijauTuaSecondary.withOpacity(0.2),
        strokeColor: _distanceInMeters > _radius ? Colors.redAccent : AppColors.hijauTuaSecondary,
        strokeWidth: 2,
      );

      _targetMarker = Marker(
        markerId: MarkerId('targetMarker'),
        position: targetLocation,
        infoWindow: InfoWindow(
          title: 'Target Location',
          snippet: _targetAddress,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        flexibleSpace: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Spacer(),
              CircleAvatar(
                  backgroundColor: Colors.blue[50],
                  child: const Icon(
                    Icons.notifications,
                    color: AppColors.hijauTuaPrimary,
                  )),
            ],
          ),
        ),
      ),
      body: _currentPosition == null
          ? const Center(
              child: CircularProgressIndicator(
              color: AppColors.hijauTuaSecondary,
            ))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width,
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16)),
                        border: Border.all(color: AppColors.hijauTuaSecondary)),
                    child: Text(
                      _distanceInMeters > _radius ? 'Anda Berada di Luar Zona' : 'Anda Berada di Zona Aman',
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: AppColors.hijauTuaSecondary),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 3,
                              spreadRadius: 2,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                        height: height * 0.5,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(_currentPosition!.latitude,
                                _currentPosition!.longitude),
                            zoom: 18,
                          ),
                          zoomControlsEnabled: false,
                          myLocationEnabled: true,
                          onMapCreated: (GoogleMapController controller) {
                            _mapController = controller;
                          },
                          markers:
                              _targetMarker != null ? {_targetMarker!} : {},
                          onTap: _onMapTap,
                          circles: _circle != null ? {_circle!} : {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _targetAddress,
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: TextButton.styleFrom(
                            backgroundColor: _distanceInMeters > _radius ? Colors.redAccent : AppColors.hijauMuda),
                        onPressed: _determinePosition,
                        child: Text(
                          _distanceInMeters < _radius ? '${(_radius - _distanceInMeters).toStringAsFixed(0)} meter dari batas zona' : 'Keluar dari batas zona',
                          style: GoogleFonts.istokWeb(fontSize: 14, fontWeight: FontWeight.bold, color: _distanceInMeters > _radius ? Colors.white : AppColors.hijauTuaSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.abuMuda,
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: Text(
                          'Lakukan panggilan darurat jika tersesat',
                          style: GoogleFonts.istokWeb(
                              fontSize: 10, fontWeight: FontWeight.w800),
                        ),
                      ),
                      IconButton(
                          onPressed: () {},
                          style: IconButton.styleFrom(
                              backgroundColor: AppColors.hijauTuaSecondary,
                              padding: EdgeInsets.all(12)),
                          icon: const Icon(
                            Icons.call,
                            color: Colors.white,
                          ))
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
