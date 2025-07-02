import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swapify/presentation/blocs/position/position_bloc.dart';
import 'package:swapify/presentation/blocs/position/position_state.dart';

//Pantalla para seleccionar ubicacion para enviar al chat
class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({Key? key}) : super(key: key);

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  LatLng? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.selectUbication),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _selectedLocation == null
                ? null
                : () {
                    Navigator.of(context).pop(_selectedLocation);
                  },
          ),
        ],
      ),
      body: BlocBuilder<PositionBloc, PositionState>(
        builder: (context, positionState) {
          return FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(positionState.latitude ?? 40.4168, positionState.longitude ?? -3.7038), 
              initialZoom: 13,
              onTap: (tapPosition, point) {
                setState(() {
                  _selectedLocation = point;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.example.swapify',
              ),
              if (_selectedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80,
                      height: 80,
                      point: _selectedLocation!,
                      child: const Icon(Icons.location_pin, size: 50, color: Colors.red),
                    ),
                  ],
                ),
            ],
          );
        }
      ),
    );
  }
}
