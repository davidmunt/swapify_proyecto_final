import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    final double maxWidth = MediaQuery.of(context).size.width * 0.85; 
    final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<UserBloc, UserState>(
                builder: (context, userState) {
                  final usuario = userState.users!.firstWhere((user) => user.id == widget.userId);
                  return Column(
                    children: [
                      if (usuario != null) 
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 40, 
                              backgroundImage: '$baseUrl${usuario.linkAvatar}' != null
                                  ? NetworkImage('$baseUrl${usuario.linkAvatar}') 
                                  : null,
                              backgroundColor: Colors.grey[300], 
                              child: '$baseUrl${usuario.linkAvatar}' == null
                                  ? const Icon(Icons.person, size: 40, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            Text(
                                usuario.name ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),

                      Text(
                        AppLocalizations.of(context)!.rateUser,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),

                      FittedBox(
                        child: GiveStarReviews(
                          starData: [
                            GiveStarData(
                              text: "${AppLocalizations.of(context)!.rate}: ",
                              textStyle: const TextStyle(fontSize: 12),
                              onChanged: (rate) {
                                setState(() {
                                  review = rate;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      Row(
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
                              child: Text(
                                AppLocalizations.of(context)!.cancel,
                                style: const TextStyle(fontSize: 14),
                              ),
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
                              child: Text(
                                AppLocalizations.of(context)!.rate,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
