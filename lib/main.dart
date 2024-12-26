import 'package:firebase_core/firebase_core.dart';
import 'package:pks_14/api/api_service.dart';
import 'package:pks_14/api/cart_api.dart';
import 'package:pks_14/api/favorite_api.dart';
import 'package:pks_14/api/order_api.dart';
import 'package:pks_14/api/product_api.dart';
import 'package:pks_14/auth/auth_gate.dart';
import 'package:pks_14/auth/auth_service.dart';
import 'package:pks_14/cart_bloc/cart_event.dart';
import 'package:pks_14/favorite_bloc/favorite_event.dart';
import 'package:pks_14/firebase_options.dart';
import 'package:pks_14/order_bloc/order_bloc.dart';
import 'package:pks_14/pages/profile_related/test_profile_page.dart';
import 'package:pks_14/product_bloc/product_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'cart_bloc/cart_bloc.dart';
import 'chat/chat_service.dart';
import 'product_bloc/product_bloc.dart';
import 'product_bloc/product_deletion_bloc.dart';
import 'favorite_bloc/favorite_bloc.dart';
import 'pages/cart_page.dart';
import 'pages/favorite_page.dart';
import 'pages/home_page.dart';
import 'cubit/navigation_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthService()),
          ChangeNotifierProvider(create: (context) => ChatService()),
        ],
        child: const MyApp(),
      )
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NavigationCubit()),
        BlocProvider(create: (context) => FavoriteBloc(
            favoriteApi: FavoriteApi(ApiService()))..add(LoadFavoritesEvent(0)),
        ),
        BlocProvider(create: (context) => CartBloc(cartApi: CartApi(ApiService()))..add(LoadCartEvent(0))
        ),
        BlocProvider(create: (context) => ProductBloc(
            productApi: ProductApi(ApiService()))..add(LoadProductsEvent()),
        ),
        BlocProvider(create: (context) => ProductDeletionBloc(
          productBloc: context.read<ProductBloc>(),
          favoriteBloc: context.read<FavoriteBloc>(),
          cartBloc: context.read<CartBloc>(),
        )),
        BlocProvider(create: (context) => OrderBloc(
          OrderApi(ApiService()),
          ProductApi(ApiService()),
        )),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomePage(),
      FavoritePage(
        productApi: ProductApi(ApiService()),
      ),
      CartPage(
        productApi: ProductApi(ApiService()),
      ),
      AuthGate(),
      //TestProfilePage()
    ];

    return BlocBuilder<NavigationCubit, int>(
      builder: (context, selectedIndex) {
        return Scaffold(
          body: _pages[selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Главная',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Избранное',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Корзина',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Профиль',
              ),
            ],
            currentIndex: selectedIndex,
            selectedItemColor: const Color(0xFF504BFF),
            unselectedItemColor: Colors.grey,
            onTap: (index) => context.read<NavigationCubit>().setPage(index),
          ),
        );
      },
    );
  }
}
