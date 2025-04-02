import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_event.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';

//alert para confirmar que quieres añadirte saldo
class AlertAddBallance extends StatefulWidget {
  final int balance;

  const AlertAddBallance({super.key, required this.balance});

  @override
  State<AlertAddBallance> createState() => _AlertAddBallanceState();
}

class _AlertAddBallanceState extends State<AlertAddBallance> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, userState) {
        if (userState.errorMessage != null) {
          setState(() {
            _isProcessing = false;
          });
        } else if (userState.user != null) {
          setState(() {
            _isProcessing = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.balanceAddedSuscesfully)));
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        }
      },
      builder: (context, userState) {
        final String? userId = userState.user?.id;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: _isProcessing
                    ? null
                    : () {
                        Navigator.of(context).pop();
                      },
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              TextButton(
                onPressed: _isProcessing
                    ? null
                    : () {
                        if (widget.balance > 0 && userId != null) {
                          setState(() {
                            _isProcessing = true;
                          });
                          context.read<UserBloc>().add(AddBalanceToUserButtonPressed(balanceToAdd: widget.balance, userId: userId));
                          context.pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.qrInvalid)));
                        }
                      },
                child: _isProcessing ? const CircularProgressIndicator() : Text(AppLocalizations.of(context)!.addBalance),
              ),
            ],
          ),
        );
      },
    );
  }
}
