import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:swapify/domain/entities/product.dart';
import 'package:swapify/presentation/blocs/chat/chat_bloc.dart';
import 'package:swapify/presentation/blocs/chat/chat_event.dart';
import 'package:swapify/presentation/blocs/chat/chat_state.dart';
import 'package:swapify/presentation/blocs/product/product_bloc.dart';
import 'package:swapify/presentation/blocs/product/product_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swapify/presentation/blocs/product_sale_state/product_sale_state_bloc.dart';
import 'package:swapify/presentation/blocs/product_sale_state/product_sale_state_event.dart';
import 'package:swapify/presentation/blocs/product_sale_state/product_sale_state_state.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_event.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';
import 'package:swapify/presentation/widgets/drawer.dart';
import 'package:go_router/go_router.dart';

//pantalla que muestra los chats que tiene tu usuario
class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  bool _usersInfoLoaded = false;

  Future<void> _getUsersInfo() async {
    if (!_usersInfoLoaded) {
      context.read<UserBloc>().add(GetUsersInfoButtonPressed());
      _usersInfoLoaded = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _getUsersInfo();
    context.read<ProductSaleStateBloc>().add(GetProductSaleStateButtonPressed());
    final userState = context.read<UserBloc>().state;
    if (userState.user != null) {
      final userId = userState.user!.id;
      context.read<ChatBloc>().add(GetMyChatsButtonPressed(userId: userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
    return Scaffold(
      appBar: AppBar(title: const Text("Swapify")),
      drawer: const DrawerWidget(),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, userState) {
          if (userState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (userState.user == null || userState.errorMessage != null) {
            return Center(child: Text(AppLocalizations.of(context)!.errorObtainingUserInfoChat));
          }
          final userId = userState.user!.id;
          return BlocBuilder<ChatBloc, ChatState>(
            builder: (context, chatState) {
              if (chatState.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (chatState.chats == null || chatState.chats!.isEmpty) {
                return Center(child: Text(AppLocalizations.of(context)!.errorNoChats, style: const TextStyle(fontSize: 16)));
              }
              final chats = chatState.chats!;
              return BlocBuilder<ProductBloc, ProductState>(
                builder: (context, productState) {
                  if (productState.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (productState.products == null) {
                    return Center(child: Text(AppLocalizations.of(context)!.errorObtainingProducts));
                  }
                  final products = productState.products!;
                  return ListView.separated(
                    separatorBuilder: (context, index) => const Divider(color: Colors.grey, height: 1),
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      final isProductOwner = chat.productOwnerId == userId;
                      final otherUserId = isProductOwner ? chat.potBuyerId : chat.productOwnerId;
                      final otherUser = userState.users?.firstWhere((user) => user.id == otherUserId);
                      final otherUserName = otherUser?.name ?? AppLocalizations.of(context)!.unknownUser;
                      ProductEntity? product;
                      try {
                        product = products.firstWhere((p) => p.productId == chat.productId);
                      } catch (_) {}
                      final timestamp = chat.messages.last['dateMessageSent'];
                      final dateMessageSent = timestamp?.toDate();
                      final formattedDate = dateMessageSent != null ? DateFormat('dd/MM/yyyy HH:mm').format(dateMessageSent) : AppLocalizations.of(context)!.unavailableDate;
                      final productImage = product?.images.isNotEmpty == true ? "$baseUrl${product!.images.first.path}" : null;
                      final productTitle = product != null ? "${product.productBrand} ${product.productModel}" : AppLocalizations.of(context)!.unknownProduct;
                      return GestureDetector(
                        onTap: () {
                          context.push('/chat', extra: {
                            'productOwnerId': chat.productOwnerId,
                            'potBuyerId': chat.potBuyerId,
                            'productId': chat.productId,
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            color: isProductOwner ? const Color.fromARGB(255, 200, 230, 201) : const Color.fromARGB(255, 250, 250, 250),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (productImage != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(productImage, width: 70, height: 70, fit: BoxFit.cover),
                                ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(otherUserName,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 4),
                                    Text(productTitle,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 4),
                                    Builder(
                                      builder: (_) {
                                        final lastMessage = chat.messages.last;
                                        if (lastMessage['message']?.toString().isNotEmpty ?? false) {
                                          return Text(lastMessage['message'],
                                              style: const TextStyle(fontSize: 14),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis);
                                        } else if (lastMessage['imagePath'] != null) {
                                          return Text(AppLocalizations.of(context)!.foto, style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic));
                                        } else if (lastMessage['latitudeSent'] != null && lastMessage['longitudeSent'] != null) {
                                          return Text(AppLocalizations.of(context)!.ubication, style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic));
                                        } else if (lastMessage['idProduct'] != null) {
                                          return Text(AppLocalizations.of(context)!.exchangeProposal, style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic));
                                        } else {
                                          return Text(AppLocalizations.of(context)!.noContent, style: const TextStyle(fontSize: 14));
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  BlocBuilder<ProductSaleStateBloc, ProductSaleStateState>(
                                    builder: (context, saleState) {
                                      if (saleState.isLoading || saleState.productSaleStates == null) {
                                        return const SizedBox();
                                      }
                                      final saleStates = saleState.productSaleStates!;
                                      final stateName = saleStates.firstWhere((s) => s.idSaleStateProduct == product?.idSaleStateProduct, orElse: () => saleStates.first).name.toLowerCase();
                                      if (stateName == "vendido") {
                                        return Chip(
                                          label: Text(AppLocalizations.of(context)!.selled),
                                          backgroundColor: Colors.green,
                                          labelStyle: const TextStyle(color: Colors.white),
                                        );
                                      } else if (stateName == "reservado") {
                                        return Chip(
                                          label: Text(AppLocalizations.of(context)!.reserved),
                                          backgroundColor: Colors.orange,
                                          labelStyle: const TextStyle(color: Colors.white),
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                  ),
                                  const SizedBox(height: 5),
                                  Text(formattedDate, style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
