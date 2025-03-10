import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_event.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';
import 'package:givestarreviews/givestarreviews.dart';

class AlertRateUser extends StatefulWidget {
  final String userId;
  final int productId;

  const AlertRateUser({super.key, required this.userId, required this.productId});

  @override
  State<AlertRateUser> createState() => _AlertRateUserState();
}

class _AlertRateUserState extends State<AlertRateUser> {
  int review = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.all(30), 
      title: Text(
        AppLocalizations.of(context)!.rateUser,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
      ),
      content: BlocBuilder<UserBloc, UserState>(
        builder: (context, userState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 32), 
              Align(
                alignment: Alignment.center,
                child: GiveStarReviews(
                  starData: [
                    GiveStarData(
                      text: "${AppLocalizations.of(context)!.rate}: ",
                      onChanged: (rate) {
                        setState(() {
                          review = rate;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32), 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(AppLocalizations.of(context)!.cancel),
                    ),
                  ),
                  const SizedBox(width: 12), 
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (userState.user != null) {
                          context.read<UserBloc>().add(AddRatingToUserButtonPressed(
                            customerId: userState.user!.id,
                            userId: widget.userId,
                            productId: widget.productId,
                            rating: review,
                          ));
                        }
                        Navigator.of(context).pop();
                        context.push('/home');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(AppLocalizations.of(context)!.rate),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
