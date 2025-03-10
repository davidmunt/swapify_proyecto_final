import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:swapify/presentation/blocs/product/product_bloc.dart';
import 'package:swapify/presentation/blocs/product/product_event.dart';
import 'package:swapify/presentation/blocs/product/product_state.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';

class AlertSell extends StatefulWidget {
  final int productId;
  final String userId;

  const AlertSell({super.key, required this.productId, required this.userId});

  @override
  State<AlertSell> createState() => _AlertSellState();
}

class _AlertSellState extends State<AlertSell> {
  bool _isProcessing = false; 

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, userState) {},
      builder: (context, userState) {
        final String? sellerId = userState.user?.id;
        return SingleChildScrollView(
          child: BlocConsumer<ProductBloc, ProductState>(
            listener: (context, state) async {
              if (state.purchaseSuccess == true) {
                setState(() {
                  _isProcessing = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.productSoldSuccesfully)));
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                context.pop(); 
              } else if (state.errorMessage != null) {
                setState(() {
                  _isProcessing = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.error)));
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(AppLocalizations.of(context)!.cancel),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (_isProcessing) {
                          return;
                        }
                        if (widget.productId != null && widget.userId.isNotEmpty && sellerId != null) {
                          setState(() {
                            _isProcessing = true; 
                          });
                          context.read<ProductBloc>().add(
                            BuyProductButtonPressed(
                              productId: widget.productId,
                              userId: widget.userId,
                              sellerId: sellerId,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.qrInvalid)));
                        }
                      },
                      child: Column(
                        children: [
                          if (_isProcessing)
                            const CircularProgressIndicator(),
                          if (!_isProcessing)
                            Text(AppLocalizations.of(context)!.sell),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
