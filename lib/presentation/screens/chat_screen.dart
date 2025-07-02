import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:swapify/domain/entities/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swapify/presentation/blocs/chat/chat_bloc.dart';
import 'package:swapify/presentation/blocs/chat/chat_event.dart';
import 'package:swapify/presentation/blocs/product/product_bloc.dart';
import 'package:swapify/presentation/blocs/product/product_event.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';
import 'package:swapify/presentation/widgets/alertdialog_rate_user_afther_product_bought.dart';
import 'package:swapify/presentation/widgets/alertdialog_show_image_chat.dart';
import 'package:swapify/presentation/widgets/alertdialog_show_qr_exchange.dart';
import 'package:swapify/presentation/widgets/widget_send_message.dart';
import 'package:url_launcher/url_launcher.dart';

//pantalla de un chat en especifico, puedes enviar mensajes, imagenes o propuestas de intercambio.
class ChatScreen extends StatefulWidget {
  final String productOwnerId;
  final String potBuyerId;
  final int productId;

  const ChatScreen({
    super.key,
    required this.productOwnerId,
    required this.potBuyerId,
    required this.productId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String chatId;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //el id del chat se obtiene juntando productOwnerId+potBuyerId+productId
    chatId = "${widget.productOwnerId}${widget.potBuyerId}${widget.productId}";
    //sirve para que al abrir el chat, este el scroll abajo del todo, sin este apartado, al abrir el chat 
    //te mostraria tus primeros mensajes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _sendMessage(String message, XFile? image, int? idProduct, String? productImage, [double? latitude, double? longitude]) {
    final userId = context.read<UserBloc>().state.user!.id;
    context.read<ChatBloc>().add(
      SendMessageButtonPressed(
        productOwnerId: widget.productOwnerId,
        potBuyerId: widget.potBuyerId,
        productId: widget.productId,
        message: message.isEmpty ? null : message,
        image: image,
        idProduct: idProduct,
        senderId: userId,
        productImage: productImage,
        latitudeSent: latitude,
        longitudeSent: longitude,
        dateMessageSent: DateTime.now(),
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<UserBloc, UserState>(
          builder: (context, userState) {
            if (userState.isLoading) {
              return const CircularProgressIndicator();
            } else if (userState.users != null && userState.users!.isNotEmpty) {
              final otherUserId = userState.user!.id == widget.productOwnerId ? widget.potBuyerId : widget.productOwnerId;
              final otherUser = userState.users!.firstWhere(
                (user) => user.id == otherUserId,
                orElse: () => UserEntity(id: "unknown", email: "unknown", name: "Usuario desconocido", surname: null, telNumber: null, avatarId: null, dateBirth: null, linkAvatar: null),
              );
              final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
              final avatar = otherUser.linkAvatar != null ? NetworkImage("$baseUrl${otherUser.linkAvatar}") : null;
              return Row(
                children: [
                  CircleAvatar(
                    backgroundImage: avatar,
                    child: avatar == null ? const Icon(Icons.person) : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    otherUser.name ?? AppLocalizations.of(context)!.unknownUser,
                    style: const TextStyle(fontSize: 18, overflow: TextOverflow.ellipsis),
                  ),
                ],
              );
            } else {
              return Text(AppLocalizations.of(context)!.chat);
            }
          },
        ),
      ),
      //escucha en tiempo real los cambios del chat desde Firestore para actualizar la conversacian
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('chats').doc(chatId).snapshots(),
        builder: (context, snapshot) {
          final userId = context.read<UserBloc>().state.user!.id;
          if (snapshot.hasError) {
            return Center(
              child: Text(AppLocalizations.of(context)!.error),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.data!.exists) {
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: Text(AppLocalizations.of(context)!.chatNotYetStarted),
                  ),
                ),
                SendMessageWidget(
                  userId: userId,
                  productOwnerId: widget.productOwnerId,
                  onSendMessage: (message, image, idProduct, productImage, latitude, longitude) {
                    _sendMessage(message, image, idProduct, productImage, latitude, longitude);
                  },
                ),
              ],
            );
          }
          final chatData = snapshot.data!.data() as Map<String, dynamic>;
          final messages = List<Map<String, dynamic>>.from(chatData['messages'] ?? []);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isSender = message['senderId'] == userId;
                    Widget messageContent;
                    //propuesta de intercambio
                    if (message['idProduct'] != null && message['productImage'] != null) {
                      messageContent = Column(
                        mainAxisSize: MainAxisSize.min, 
                        crossAxisAlignment: CrossAxisAlignment.center, 
                        children: [
                          SizedBox(
                            width: 220, 
                            height: 250,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                "${dotenv.env['BASE_API_URL']}${message['productImage']}",
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (message['accepted'] == null && widget.productOwnerId != userId) ...[
                            SizedBox(
                              width: 160, 
                              child: ElevatedButton(
                                onPressed: () {
                                  //muestra el qr de la propuesta de intercambio 
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertShowQRExchange(productId: widget.productId, userId: userId, productExchangedId: message['idProduct']),
                                    ).then((_) async {
                                      final previousState = context.read<ProductBloc>().state;
                                      context.read<ProductBloc>().add(GetProductButtonPressed(productId: widget.productId));
                                      final productState = await context.read<ProductBloc>().stream.firstWhere(
                                        (state) => state.product != null && state.product!.productId == widget.productId && state.product != previousState.product,
                                      );
                                      final updatedProduct = productState.product; 
                                      //al clicar fuera del widget que muestra el qr verifica si se ha realizado el intercambio
                                      if (updatedProduct != null && updatedProduct.idSaleStateProduct == 4 && updatedProduct.buyerId == userId) {
                                        context.read<ChatBloc>().add(UpdateExchangeStatusChatButtonPressed(productOwnerId: widget.productOwnerId, potBuyerId: widget.potBuyerId, productId: widget.productId, idProduct: message['idProduct'], accepted: true));
                                        context.read<ProductBloc>().add(GetProductsButtonPressed());
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.saleRealized)));
                                        context.pop();
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            //valora al otro usuario
                                            return Dialog(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), 
                                              child: AlertRateUser(
                                                userId: userId,
                                                productId: widget.productId,
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    });
                                },
                                child: Text(AppLocalizations.of(context)!.exchange),
                              ),
                            ),
                            //muestra el estado de la propuesta de intercambio para el usuario dueño del producto
                            //(en caso de que este en proceso) y si esta aceptada o rechazada se lo mostrara a los dos usuarios
                            //para intercambiar un producto, el usuario ducño del producto tendra que escanear el qr que lo muestra 
                            //el otro usuario
                          ] else if (message['accepted'] == null && widget.productOwnerId == userId) ...[
                            Chip(
                              label: Text(AppLocalizations.of(context)!.scanTheirQR),
                              backgroundColor: const Color.fromARGB(255, 238, 255, 82),
                            ),
                          ] else if (message['accepted'] == false) ...[
                            Chip(
                              label: Text(AppLocalizations.of(context)!.exchangeRejected),
                              backgroundColor: Colors.redAccent,
                            ),
                          ] else if (message['accepted'] == true) ...[
                            Chip(
                              label: Text(AppLocalizations.of(context)!.exchangeAccepted),
                              backgroundColor: Colors.greenAccent,
                            ),
                          ],
                        ],
                      );
                    //imagen
                    } else if (message['imagePath'] != null && message['imagePath'].trim().isNotEmpty) {
                      messageContent = GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertShowImageChat(imagenMostrar: message['imagePath']);
                            },
                          );
                        },
                        child: Image.network(
                          "${dotenv.env['BASE_API_URL']}${message['imagePath']}",
                          width: 200,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      );
                    //ubicacion
                    } else if (message['latitudeSent'] != null && message['longitudeSent'] != null) {
                      // ubicación enviada
                      final double latitude = message['latitudeSent'];
                      final double longitude = message['longitudeSent'];
                      messageContent = Stack(
                        alignment: Alignment.topRight,
                        children: [
                          SizedBox(
                            width: 250,
                            height: 300,
                            child: FlutterMap(
                              options: MapOptions(
                                initialCenter: LatLng(latitude, longitude),
                                initialZoom: 15,
                                interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                  userAgentPackageName: 'com.example.swapify',
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      width: 50,
                                      height: 50,
                                      point: LatLng(latitude, longitude),
                                      child: const Icon(Icons.location_pin, size: 50, color: Colors.red),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          //al clicar este boton abre google maps con esa ubicacion
                          Positioned(
                            top: 8,
                            right: 8,
                            child: FloatingActionButton.small(
                              heroTag: 'btnGoogleMaps_$index',
                              backgroundColor: Colors.white,
                              elevation: 4,
                              onPressed: () async {
                                final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('No se pudo abrir Google Maps')),
                                  );
                                }
                              },
                              child: const Icon(Icons.map, color: Colors.black),
                            ),
                          ),
                        ],
                      );
                    } else {
                      //texto
                      messageContent = Text(
                        message['message'] ?? '',
                        style: const TextStyle(fontSize: 14), 
                      );
                    }
                    return Align(
                      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 174, 215, 201),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft: Radius.circular(isSender ? 12 : 0),
                            bottomRight: Radius.circular(isSender ? 0 : 12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            messageContent,
                            const SizedBox(height: 10),
                            Text(
                              message['dateMessageSent'] != null ? DateFormat('dd/MM/yyyy HH:mm').format((message['dateMessageSent'] as Timestamp).toDate()) : 'Sin fecha',
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              //widget que muetra el y apartado para enviat texto, imagenes y propuesta de intercambio
              SendMessageWidget(
                userId: userId,
                productOwnerId: widget.productOwnerId,
                onSendMessage: (message, image, idProduct, productImage, latitude, longitude) {
                  _sendMessage(message, image, idProduct, productImage, latitude, longitude);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
