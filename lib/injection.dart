import 'package:swapify/data/datasources/chat_remote_datasource.dart';
import 'package:swapify/data/datasources/product_category_remote_datasource.dart';
import 'package:swapify/data/datasources/product_remote_datasource.dart';
import 'package:swapify/data/datasources/product_sale_state_remote_datasource.dart';
import 'package:swapify/data/datasources/product_state_remote_datasource.dart';
import 'package:swapify/data/datasources/product_view_remote_datasource.dart';
import 'package:swapify/data/datasources/qr_remote_datasource.dart';
import 'package:swapify/data/datasources/recomendation_price_remote_datasource.dart';
import 'package:swapify/data/datasources/user_remote_datasource.dart';
import 'package:swapify/data/repositories/chat_repository_impl.dart';
import 'package:swapify/data/repositories/product_category_repository_impl.dart';
import 'package:swapify/data/repositories/product_repository_impl.dart';
import 'package:swapify/data/repositories/product_sale_state_repository_impl.dart';
import 'package:swapify/data/repositories/product_state_repository_impl.dart';
import 'package:swapify/data/repositories/product_view_repository_impl.dart';
import 'package:swapify/data/repositories/qr_repository_impl.dart';
import 'package:swapify/data/repositories/recomendation_price_repisitory_impl.dart';
import 'package:swapify/data/repositories/user_repository_impl.dart';
import 'package:swapify/domain/repositories/chat_repository.dart';
import 'package:swapify/domain/repositories/product_category_repository.dart';
import 'package:swapify/domain/repositories/product_repository.dart';
import 'package:swapify/domain/repositories/product_sale_state_repository.dart';
import 'package:swapify/domain/repositories/product_state_repository.dart';
import 'package:swapify/domain/repositories/product_view_repository.dart';
import 'package:swapify/domain/repositories/qr_repository.dart';
import 'package:swapify/domain/repositories/recomendation_price_repository.dart';
import 'package:swapify/domain/repositories/user_repository.dart';
import 'package:swapify/domain/usecases/add_balance_to_user_usecase.dart';
import 'package:swapify/domain/usecases/add_rating_to_user_usecase.dart';
import 'package:swapify/domain/usecases/buy_product_usecase.dart';
import 'package:swapify/domain/usecases/change_password_user_usecase.dart';
import 'package:swapify/domain/usecases/change_user_avatar_usecase.dart';
import 'package:swapify/domain/usecases/change_user_info_usecase.dart';
import 'package:swapify/domain/usecases/change_user_password_usecase.dart';
import 'package:swapify/domain/usecases/create_product_usecase.dart';
import 'package:swapify/domain/usecases/delete_chat_where_is_product_usecase.dart';
import 'package:swapify/domain/usecases/delete_product_usecase.dart';
import 'package:swapify/domain/usecases/delete_user_usecase.dart';
import 'package:swapify/domain/usecases/exchange_product_usecase.dart';
import 'package:swapify/domain/usecases/get_chat_usecse.dart';
import 'package:swapify/domain/usecases/get_current_user_usecase.dart';
import 'package:swapify/domain/usecases/get_filtered_products_usecase.dart';
import 'package:swapify/domain/usecases/get_my_chats_usecase.dart';
import 'package:swapify/domain/usecases/get_product_category_usecase.dart';
import 'package:swapify/domain/usecases/get_product_sale_state_usecase.dart';
import 'package:swapify/domain/usecases/get_product_state_usecase.dart';
import 'package:swapify/domain/usecases/get_product_usecase.dart';
import 'package:swapify/domain/usecases/get_products_usecase.dart';
import 'package:swapify/domain/usecases/get_qr_product_exchange_usecase.dart';
import 'package:swapify/domain/usecases/get_qr_product_payment_usecase.dart';
import 'package:swapify/domain/usecases/get_recomendation_product_price_usecase.dart';
import 'package:swapify/domain/usecases/get_user_info_usecase.dart';
import 'package:swapify/domain/usecases/get_users_info_usecase.dart';
import 'package:swapify/domain/usecases/get_youre_envolvment_products_usecase.dart';
import 'package:swapify/domain/usecases/get_youre_liked_products_usecase.dart';
import 'package:swapify/domain/usecases/get_youre_products_usecase.dart';
import 'package:swapify/domain/usecases/like_product_usecase.dart';
import 'package:swapify/domain/usecases/login_to_get_token_from_backend_usecase.dart';
import 'package:swapify/domain/usecases/reset_password_user_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swapify/domain/usecases/save_message_image_usecase.dart';
import 'package:swapify/domain/usecases/save_product_view_usecase.dart';
import 'package:swapify/domain/usecases/save_user_info_usecase.dart';
import 'package:swapify/domain/usecases/save_user_notification_token_usecase.dart';
import 'package:swapify/domain/usecases/send_message_chat_usecase.dart';
import 'package:swapify/domain/usecases/send_notification_to_other_user_usecase.dart';
import 'package:swapify/domain/usecases/sign_in_user_usecase.dart';
import 'package:swapify/domain/usecases/sign_out_user_usecase.dart';
import 'package:swapify/domain/usecases/sign_up_user_usecase.dart';
import 'package:swapify/domain/usecases/unlike_product_usecase.dart';
import 'package:swapify/domain/usecases/update_exchange_status_chat_usecase.dart';
import 'package:swapify/domain/usecases/update_product_images_usecase.dart';
import 'package:swapify/domain/usecases/update_product_usecase.dart';
import 'package:swapify/domain/usecases/upload_product_images_usecase.dart';
import 'package:swapify/presentation/blocs/chat/chat_bloc.dart';
import 'package:swapify/presentation/blocs/language/language_bloc.dart';
import 'package:swapify/presentation/blocs/navigation_bar/navigation_bar_bloc.dart';
import 'package:swapify/presentation/blocs/position/position_bloc.dart';
import 'package:swapify/presentation/blocs/product/product_bloc.dart';
import 'package:swapify/presentation/blocs/product_category/product_category_bloc.dart';
import 'package:swapify/presentation/blocs/product_sale_state/product_sale_state_bloc.dart';
import 'package:swapify/presentation/blocs/product_state/product_state_bloc.dart';
import 'package:swapify/presentation/blocs/product_view/product_view_bloc.dart';
import 'package:swapify/presentation/blocs/qr/qr_bloc.dart';
import 'package:swapify/presentation/blocs/recomendation_price/recomendation_price_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {

  sl.registerFactory<UserBloc>(
    () => UserBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()),
  );

  sl.registerFactory<ProductCategoryBloc>(
    () => ProductCategoryBloc(sl()),
  );

  sl.registerFactory<ProductStateBloc>(
    () => ProductStateBloc(sl()),
  );

  sl.registerFactory<ProductSaleStateBloc>(
    () => ProductSaleStateBloc(sl()),
  );

  sl.registerFactory<ProductBloc>(
    () => ProductBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()),
  );

  sl.registerFactory<ChatBloc>(
    () => ChatBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl()),
  );

  sl.registerFactory<QRBloc>(
    () => QRBloc(sl(), sl()),
  );

  sl.registerFactory<ProductViewBloc>(
    () => ProductViewBloc(sl()),
  );

  sl.registerFactory<RecomendationPriceBloc>(
    () => RecomendationPriceBloc(sl()),
  );

  sl.registerFactory<LanguageBloc>(
    () => LanguageBloc(),
  );

  sl.registerFactory<NavigationBarBloc>(
    () => NavigationBarBloc(),
  );

  sl.registerFactory<PositionBloc>(
    () => PositionBloc(),
  );

  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSource(
      auth: sl<FirebaseAuth>(), 
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  sl.registerLazySingleton<ChatDataSource>(
    () => ChatDataSource(firestore: sl<FirebaseFirestore>()),
  );

  sl.registerLazySingleton<ProductCategoryDataSource>(
    () => ProductCategoryDataSource(),
  );

  sl.registerLazySingleton<ProductStateDataSource>(
    () => ProductStateDataSource(),
  );

  sl.registerLazySingleton<ProductSaleStateDataSource>(
    () => ProductSaleStateDataSource(),
  );

  sl.registerLazySingleton<ProductDataSource>(
    () => ProductDataSource(),
  );

  sl.registerLazySingleton<QRDataSource>(
    () => QRDataSource(),
  );

  sl.registerLazySingleton<ProductViewDataSource>(
    () => ProductViewDataSource(),
  );

  sl.registerLazySingleton<RecomendationPriceDataSource>(
    () => RecomendationPriceDataSource(),
  );

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl<FirebaseAuthDataSource>(), sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<ProductCategoryRepository>(
    () => ProductCategoryRepositoryImpl(sl<ProductCategoryDataSource>()),
  );

  sl.registerLazySingleton<ProductStateRepository>(
    () => ProductStateRepositoryImpl(sl<ProductStateDataSource>()),
  );

  sl.registerLazySingleton<ProductSaleStateRepository>(
    () => ProductSaleStateRepositoryImpl(sl<ProductSaleStateDataSource>()),
  );

  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl<ProductDataSource>()),
  );

  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(sl<ChatDataSource>(), sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<QRRepository>(
    () => QRRepositoryImpl(sl<QRDataSource>()),
  );

  sl.registerLazySingleton<RecomendationPriceRepository>(
    () => RecomendationPriceRepositoryImpl(sl<RecomendationPriceDataSource>()),
  );

  sl.registerLazySingleton<ProductViewRepository>(
    () => ProductViewRepositoryImpl(sl<ProductViewDataSource>()),
  );

  sl.registerLazySingleton<SigninUserUseCase>(
    () => SigninUserUseCase(sl()),
  );
  sl.registerLazySingleton<SignUpUserUsecase>(
    () => SignUpUserUsecase(sl()),
  );
  sl.registerLazySingleton<SignoutUserUseCase>(
    () => SignoutUserUseCase(sl()),
  );
  sl.registerLazySingleton<ResetPassUserUsecase>(
    () => ResetPassUserUsecase(sl()),
  );
  sl.registerLazySingleton<ChangePassUserUsecase>(
    () => ChangePassUserUsecase(sl()),
  );
  sl.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(sl()),
  );
  sl.registerLazySingleton<SaveUserInfoUseCase>(
    () => SaveUserInfoUseCase(sl()),
  );
  sl.registerLazySingleton<GetUserInfoUseCase>(
    () => GetUserInfoUseCase(sl()),
  );
  sl.registerLazySingleton<GetUsersInfoUseCase>(
    () => GetUsersInfoUseCase(sl()),
  );
  sl.registerLazySingleton<DeleteUserUseCase>(
    () => DeleteUserUseCase(sl()),
  );
  sl.registerLazySingleton<ChangeUserInfoUseCase>(
    () => ChangeUserInfoUseCase(sl()),
  );
  sl.registerLazySingleton<AddBalanceToUserUseCase>( 
    () => AddBalanceToUserUseCase(sl()),
  );
  sl.registerLazySingleton<ChangeUserPasswordUseCase>(
    () => ChangeUserPasswordUseCase(sl()),
  );
  sl.registerLazySingleton<SaveUserNotificationTokenUseCase>(
    () => SaveUserNotificationTokenUseCase(sl()),
  );
  sl.registerLazySingleton<ChangeUserAvatarUseCase>(
    () => ChangeUserAvatarUseCase(sl()),
  );
  sl.registerLazySingleton<GetProductCategoryUseCase>(
    () => GetProductCategoryUseCase(sl()),
  );
  sl.registerLazySingleton<GetProductStateUseCase>(
    () => GetProductStateUseCase(sl()),
  );
  sl.registerLazySingleton<GetProductSaleStateUseCase>(
    () => GetProductSaleStateUseCase(sl()),
  );
  sl.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(sl()),
  );
  sl.registerLazySingleton<GetYoureProductsUseCase>(
    () => GetYoureProductsUseCase(sl()),
  );
  sl.registerLazySingleton<GetYoureLikedProductsUseCase>(
    () => GetYoureLikedProductsUseCase(sl()),
  );
  sl.registerLazySingleton<GetYoureEnvolvmentProductsUseCase>(
    () => GetYoureEnvolvmentProductsUseCase(sl()),
  );
  sl.registerLazySingleton<GetFilteredProductsUseCase>(
    () => GetFilteredProductsUseCase(sl()),
  );
  sl.registerLazySingleton<CreateProductUseCase>(
    () => CreateProductUseCase(sl()),
  );
  sl.registerLazySingleton<DeleteProductUseCase>(
    () => DeleteProductUseCase(sl()),
  );
  sl.registerLazySingleton<UploadProductImagesUseCase>(
    () => UploadProductImagesUseCase(sl()),
  );
  sl.registerLazySingleton<BuyProductUseCase>(
    () => BuyProductUseCase(sl()),
  );
  sl.registerLazySingleton<ExchangeProductUseCase>(
    () => ExchangeProductUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateProductUseCase>(
    () => UpdateProductUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateProductImagesUseCase>(
    () => UpdateProductImagesUseCase(sl()),
  );
  sl.registerLazySingleton<LikeProductUseCase>(
    () => LikeProductUseCase(sl()),
  );
  sl.registerLazySingleton<UnlikeProductUseCase>(
    () => UnlikeProductUseCase(sl()),
  );
  sl.registerLazySingleton<GetProductUseCase>(
    () => GetProductUseCase(sl()),
  );
  sl.registerLazySingleton<SendMessageChatUsecase>(
    () => SendMessageChatUsecase(sl()),
  );
  sl.registerLazySingleton<UploadMessageImageUsecase>(
    () => UploadMessageImageUsecase(sl()),
  );
  sl.registerLazySingleton<GetMyChatsUseCase>(
    () => GetMyChatsUseCase(sl()),
  );
  sl.registerLazySingleton<GetChatUseCase>(
    () => GetChatUseCase(sl()),   
  );
  sl.registerLazySingleton<UpdateExchangeStatusChatUseCase>(
    () => UpdateExchangeStatusChatUseCase(sl()),   
  );
  sl.registerLazySingleton<SendNotificationToOtherUserUseCase>(
    () => SendNotificationToOtherUserUseCase(sl()),
  );
  sl.registerLazySingleton<GetQRProductPaymentUseCase>(
    () => GetQRProductPaymentUseCase(sl()),
  );
  sl.registerLazySingleton<GetQRProductExchangeUseCase>(
    () => GetQRProductExchangeUseCase(sl()),
  );
  sl.registerLazySingleton<GetRecomendationPriceUseCase>(
    () => GetRecomendationPriceUseCase(sl()),
  );
  sl.registerLazySingleton<AddRatingToUserUseCase>(
    () => AddRatingToUserUseCase(sl()),
  );
  sl.registerLazySingleton<SaveProductViewUsecase>(
    () => SaveProductViewUsecase(sl()),
  );
  sl.registerLazySingleton<DeleteChatWhereIsProductUsecase>( 
    () => DeleteChatWhereIsProductUsecase(sl()),
  );
  sl.registerLazySingleton<LoginToGetTokenFromBackendUseCase>( 
    () => LoginToGetTokenFromBackendUseCase(sl()),
  );
}