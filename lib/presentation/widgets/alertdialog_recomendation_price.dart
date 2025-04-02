import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';

//alert para recomendar un precio a un producto
class AlertRecomendationPrice extends StatelessWidget {
  final double recomendedPrice;
  final String marca;
  final String modelo;
  final String descripcion;
  final double precio;
  final int idProductCategory;
  final int idProductState;
  final String? nameCityCreated;
  final double longitudeCreated;
  final double latitudeCreated;
  final List<XFile> selectedImages;

  const AlertRecomendationPrice({
    super.key,
    required this.recomendedPrice,
    required this.marca,
    required this.modelo,
    required this.descripcion,
    required this.precio,
    required this.idProductCategory,
    required this.idProductState,
    required this.nameCityCreated,
    required this.longitudeCreated,
    required this.latitudeCreated,
    required this.selectedImages,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 260,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.recommendedPriceSuggestion(recomendedPrice),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 50), 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.green, width: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false); 
                    },
                    child: Text(
                      AppLocalizations.of(context)!.modifyProduct,
                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (!Navigator.of(context).mounted) return;
                        Navigator.of(context).pop(true);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.ignore,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
