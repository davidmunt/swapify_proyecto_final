import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapify/presentation/blocs/position/position_event.dart';
import 'package:swapify/presentation/blocs/position/position_state.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class PositionBloc extends Bloc<PositionEvent, PositionState> {
  PositionBloc() : super(PositionState.initial()) {

    //obtiene tu posicion (latitud y longitud)
    on<GetPositionButtonPressed>((event, emit) async {
      emit(PositionState.loading());
      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          emit(PositionState.failure("Error al intentar obtener la ubicación"));
          return;
        }
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            emit(PositionState.failure("Permisos denegados"));
            return;
          }
        }
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        double latitudeCreated = position.latitude;
        double longitudeCreated = position.longitude;
        String nameCityCreated;
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(latitudeCreated, longitudeCreated);
          nameCityCreated = placemarks.isNotEmpty ? (placemarks.first.locality ?? "Ciudad desconocida") : "Ciudad desconocida";
        } catch (e) {
          nameCityCreated = "Ciudad desconocida"; 
        }
        emit(PositionState.success(latitudeCreated, longitudeCreated, nameCityCreated));
      } catch (e) {
        emit(PositionState.failure("Fallo al obtener la ubicacion: $e"));
      }
    });
  }
}
