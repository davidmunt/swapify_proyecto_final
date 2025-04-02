import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:swapify/presentation/blocs/qr/qr_bloc.dart';
import 'package:swapify/presentation/blocs/qr/qr_event.dart';
import 'package:swapify/presentation/blocs/qr/qr_state.dart';
import 'package:swapify/presentation/blocs/product/product_bloc.dart';
import 'package:swapify/presentation/blocs/product/product_event.dart';
import 'package:swapify/presentation/blocs/product/product_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:swapify/presentation/widgets/alertdialog_rate_user_afther_product_bought.dart';

//alert para mostrar un qr para la compra de un producto
class AlertShowQRPurchase extends StatefulWidget {
  final int productId;
  final String userId;

  const AlertShowQRPurchase({
    super.key,
    required this.productId,
    required this.userId,
  });

  @override
  State<AlertShowQRPurchase> createState() => _AlertShowQRPurchaseState();
}

class _AlertShowQRPurchaseState extends State<AlertShowQRPurchase> {
  @override
  void initState() {
    super.initState();
    context.read<QRBloc>().add(GetQRButtonPressed(productId: widget.productId, userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(10),
      child: BlocListener<ProductBloc, ProductState>(
        listenWhen: (previous, current) {
          return previous.products != current.products;
        },
        listener: (context, productState) {
          final updatedProduct = productState.product;
          if (updatedProduct != null && updatedProduct.idSaleStateProduct == 4 && updatedProduct.buyerId == widget.userId) {
            context.read<ProductBloc>().add(GetProductsButtonPressed());
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.saleRealized)));
            context.pop();
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: AlertRateUser(
                    userId: updatedProduct.userId, 
                    productId: updatedProduct.productId,
                  ),
                );
              },
            );
          }
        },
        child: GestureDetector(
          child: BlocBuilder<QRBloc, QRState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.qrEntity != null) {
                final qrPath = state.qrEntity!.qrPath;
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      constraints: BoxConstraints(
                        maxHeight: constraints.maxHeight * 0.9,
                        maxWidth: constraints.maxWidth * 0.9,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          "${dotenv.env['BASE_API_URL']}$qrPath",
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                );
              } else if (state.errorMessage != null) {
                return Center(
                  child: Text(
                    state.errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                return Center(
                  child: Text(AppLocalizations.of(context)!.errorGeneratingQR, textAlign: TextAlign.center),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
