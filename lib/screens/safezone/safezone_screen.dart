import 'package:buddymensia/colors.dart';
import 'package:buddymensia/models/user.dart';
import 'package:buddymensia/services/auth_services.dart';
import 'package:buddymensia/widgets/buttons/primary_btn_widget.dart';
import 'package:buddymensia/widgets/textfields/general_textfield_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class SafezoneScreen extends StatefulWidget {
  const SafezoneScreen({super.key});

  @override
  _SafezoneScreenState createState() => _SafezoneScreenState();
}

class _SafezoneScreenState extends State<SafezoneScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _radiusController = TextEditingController();

  GoogleMapController? _mapController;
  LatLng targetLocation = const LatLng(-6.315687282015746, 106.79435478845504);
  Position? _currentPosition;
  double _distanceInMeters = 0.0;
  Circle? _circle;
  double _radius = 200;
  String _targetAddress = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _getTargetAddress();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Layanan lokasi tidak diaktifkan.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Izin lokasi ditolak');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Izin lokasi ditolak secara permanen, kami tidak dapat meminta izin.');
    }

    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    User? user = Provider.of<AuthService>(context, listen: false).user;
    targetLocation = user!.location!;
    _radius = user.radius!.toDouble();

    setState(() {
      _distanceInMeters = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        targetLocation.latitude,
        targetLocation.longitude,
      );

      _circle = Circle(
        circleId: const CircleId("circle"),
        center: targetLocation,
        radius: _radius,
        fillColor: _distanceInMeters > _radius
            ? Colors.redAccent.withOpacity(0.2)
            : AppColors.hijauTuaSecondary.withOpacity(0.2),
        strokeColor: _distanceInMeters > _radius
            ? Colors.redAccent
            : AppColors.hijauTuaSecondary,
        strokeWidth: 2,
      );
    });

    _mapController?.animateCamera(CameraUpdate.newLatLng(
      LatLng(targetLocation.latitude, targetLocation.longitude),
    ));
  }

  Future<void> _getTargetAddress() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        targetLocation.latitude,
        targetLocation.longitude,
      );

      Placemark place = placemarks[0];
      setState(() {
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
      targetLocation = position;
    });

    _distanceInMeters = Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      targetLocation.latitude,
      targetLocation.longitude,
    );

    await _getTargetAddress();
    await Provider.of<AuthService>(context, listen: false)
        .updateLocation(position);

    setState(() {
      _circle = Circle(
        circleId: CircleId("circle"),
        center: targetLocation,
        radius: _radius,
        fillColor: _distanceInMeters > _radius
            ? Colors.redAccent.withOpacity(0.2)
            : AppColors.hijauTuaSecondary.withOpacity(0.2),
        strokeColor: _distanceInMeters > _radius
            ? Colors.redAccent
            : AppColors.hijauTuaSecondary,
        strokeWidth: 2,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthService authProvider = Provider.of<AuthService>(context);
    User? user = authProvider.user;

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
                  backgroundColor: user!.role == 'user'
                      ? Colors.blue[50]
                      : Colors.purple[50],
                  child: Icon(
                    Icons.notifications,
                    color: user.role == 'user'
                        ? AppColors.hijauTuaPrimary
                        : AppColors.unguCaregiver,
                  )),
            ],
          ),
        ),
      ),
      body: _currentPosition == null
          ? Center(
              child: CircularProgressIndicator(
              color: user.role == 'user'
                  ? AppColors.hijauTuaSecondary
                  : AppColors.unguCaregiver,
            ))
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, _distanceInMeters > _radius ? Colors.red[100]! : Colors.green[100]!, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      user.role != 'user'
                          ? Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: AppColors.unguCaregiver,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  'Pilih Titik Zona Aman',
                                  style: GoogleFonts.montserrat(
                                      decoration: TextDecoration.underline,
                                      color: AppColors.unguCaregiver,
                                      fontSize: 14),
                                ),
                              ],
                            )
                          : Container(),
                      SizedBox(
                        width: width,
                        height: 12,
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16)),
                            border: Border.all(
                                color: user.role == 'user'
                                    ? AppColors.hijauTuaSecondary
                                    : AppColors.unguCaregiver)),
                        child: Text(
                          _distanceInMeters > _radius
                              ? 'Anda Berada di Luar Zona'
                              : 'Anda Berada di Zona Aman',
                          style: GoogleFonts.montserrat(
                              fontSize: 16,
                              color: user.role == 'user'
                                  ? AppColors.hijauTuaSecondary
                                  : AppColors.unguCaregiver),
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
                            height: user.role != 'user'
                                ? height * 0.38
                                : height * 0.5,
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(_currentPosition!.latitude,
                                    _currentPosition!.longitude),
                                zoom: 16,
                              ),
                              gestureRecognizers: {
                                Factory<OneSequenceGestureRecognizer>(
                                    () => EagerGestureRecognizer())
                              },
                              zoomControlsEnabled: false,
                              myLocationEnabled: true,
                              onMapCreated: (GoogleMapController controller) {
                                _mapController = controller;
                              },
                              markers: {
                                Marker(
                                  markerId: const MarkerId('targetMarker'),
                                  position: targetLocation,
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueAzure),
                                  infoWindow: InfoWindow(
                                    title: 'Target Location',
                                    snippet:
                                        _targetAddress, // Menampilkan alamat sebagai snippet
                                  ),
                                ),
                              },
                              onTap: user.role != 'user' ? _onMapTap : null,
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
                      user.role != 'user'
                          ? Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  GeneralTextfieldWidget(
                                    hintText: '100',
                                    inputType: TextInputType.number,
                                    isRequired: true,
                                    controller: _radiusController,
                                    labelText: 'Batas Zona',
                                    icon: Icons.gps_fixed,
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  _isLoading
                                      ? const CircularProgressIndicator(
                                          color: AppColors.hijauTuaSecondary,
                                        )
                                      : SizedBox(
                                          height: 40,
                                          child: PrimaryBtnWidget(
                                              buttonText: 'Simpan',
                                              color: AppColors.unguCaregiver,
                                              handler: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  setState(() {
                                                    _isLoading = true;
                                                  });
                                                  await authProvider
                                                      .updateRadius(int.parse(
                                                          _radiusController
                                                              .text));
                                                  _determinePosition();
                                                  _radiusController.text = '';
                                                  setState(() {
                                                    _isLoading = false;
                                                  });
                                                }
                                              }))
                                ],
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor:
                                          _distanceInMeters > _radius
                                              ? Colors.redAccent
                                              : AppColors.hijauMuda),
                                  onPressed: _determinePosition,
                                  child: Text(
                                    _distanceInMeters < _radius
                                        ? '${(_radius - _distanceInMeters).toStringAsFixed(0)} meter dari batas zona'
                                        : 'Diluar batas zona',
                                    style: GoogleFonts.istokWeb(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: _distanceInMeters > _radius
                                            ? Colors.white
                                            : AppColors.hijauTuaSecondary),
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
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              'Lakukan panggilan darurat jika tersesat',
                              style: GoogleFonts.istokWeb(
                                  fontSize: 10, fontWeight: FontWeight.w800),
                            ),
                          ),
                          IconButton(
                              onPressed: () {},
                              style: IconButton.styleFrom(
                                  backgroundColor: user.role != 'user'
                                      ? AppColors.unguCaregiver
                                      : AppColors.hijauTuaSecondary,
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
              ),
            ),
    );
  }
}
