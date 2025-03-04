import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Swapify"),
      ),
      body: BlocListener<ChatBloc, ChatState>(
        listener: (context, chatState) {
          final userId = context.read<UserBloc>().state.user?.id;
          if (userId != null && (chatState.chats == null || chatState.chats!.isEmpty)) {
            context.read<ChatBloc>().add(GetMyChatsButtonPressed(userId: userId));
          }
        },
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, userState) {
            if (userState.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (userState.user != null && userState.errorMessage == null) {
              final userId = userState.user!.id;
              final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('chats').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  context.read<ChatBloc>().add(GetMyChatsButtonPressed(userId: userId));
                  return BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, chatState) {
                      if (chatState.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (chatState.chats != null) {
                        final chats = chatState.chats!;
                        if (chats.isEmpty) {
                          return Center(
                            child: Text(AppLocalizations.of(context)!.errorNoChats, style: const TextStyle(fontSize: 16)),
                          );
                        }
                        return BlocBuilder<ProductBloc, ProductState>(
                          builder: (context, productState) {
                            if (productState.isLoading) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (productState.products != null) {
                              final products = productState.products!;
                              return ListView.separated(
                                separatorBuilder: (context, index) => const Divider(color: Colors.grey, height: 1),
                                itemCount: chats.length,
                                itemBuilder: (context, index) {
                                  final chat = chats[index];
                                  final isProductOwner = chat.productOwnerId == userId;
                                  final otherUserId = isProductOwner ? chat.potBuyerId : chat.productOwnerId;
                                  final otherUser = userState.users?.firstWhere((user) => user.id == otherUserId);
                                  final otherUserName = otherUser?.name ?? "Usuario desconocido";
                                  ProductEntity? product;
                                  try {
                                    product = products.firstWhere((p) => p.productId == chat.productId);
                                  } catch (e) {
                                    product = null;
                                  }
                                  final timestamp = chat.messages.last['dateMessageSent'];
                                  final dateMessageSent = timestamp?.toDate();
                                  final formattedDate = dateMessageSent != null ? DateFormat('dd/MM/yyyy HH:mm').format(dateMessageSent) : 'Fecha desconocida';
                                  final productImage = product?.images.isNotEmpty == true ? "$baseUrl${product!.images.first.path}" : null;
                                  final productTitle = product != null ? "${product.productBrand} ${product.productModel}" : "Producto desconocido";
                                  return GestureDetector(
                                    onTap: () {
                                      context.push(
                                        '/chat',
                                        extra: {
                                          'productOwnerId': chat.productOwnerId,
                                          'potBuyerId': chat.potBuyerId,
                                          'productId': chat.productId,
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                      decoration: BoxDecoration(color: isProductOwner ? const Color.fromARGB(255, 200, 230, 201) : const Color.fromARGB(255, 250, 250, 250),
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
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(productImage!, width: 70, height: 70, fit: BoxFit.cover)
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  otherUserName,
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  productTitle,
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  chat.messages.last['message'] ?? AppLocalizations.of(context)!.foto,
                                                  style: const TextStyle(fontSize: 14),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              BlocBuilder<ProductSaleStateBloc, ProductSaleStateState>(
                                                builder: (context, saleState) {
                                                  if (saleState.isLoading) {
                                                    return const SizedBox(); 
                                                  } else if (saleState.productSaleStates != null) {
                                                    final saleStates = saleState.productSaleStates!;
                                                    final saleStateName = saleStates.firstWhere((state) => state.idSaleStateProduct == product?.idSaleStateProduct).name; 
                                                    if (saleStateName.toLowerCase() == "vendido") {
                                                      return Chip(
                                                        label: Text(AppLocalizations.of(context)!.selled),
                                                        backgroundColor: Colors.green,
                                                        labelStyle: const TextStyle(color: Colors.white),
                                                      );
                                                    } else if (saleStateName.toLowerCase() == "reservado") {
                                                      return Chip(
                                                        label: Text(AppLocalizations.of(context)!.reserved),
                                                        backgroundColor: Colors.orange,
                                                        labelStyle: const TextStyle(color: Colors.white),
                                                      );
                                                    }
                                                  }
                                                  return const SizedBox();
                                                },
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                formattedDate,
                                                style: const TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Center(child: Text(AppLocalizations.of(context)!.errorObtainingProducts));
                            }
                          },
                        );
                      } else {
                        return Center(child: Text(AppLocalizations.of(context)!.errorObtainingChats));
                      }
                    },
                  );
                },
              );
            } else {
              return Center(child: Text(AppLocalizations.of(context)!.errorObtainingUserInfoChat));
            }
          },
        ),
      ),
      drawer: const DrawerWidget(),
    );
  }
}
