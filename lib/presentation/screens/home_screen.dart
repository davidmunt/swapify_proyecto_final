import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swapify/presentation/blocs/navigation_bar/navigation_bar_bloc.dart';
import 'package:swapify/presentation/blocs/navigation_bar/navigation_bar_event.dart';
import 'package:swapify/presentation/blocs/navigation_bar/navigation_bar_state.dart';
import 'package:swapify/presentation/screens/like_products_screen.dart';
import 'package:swapify/presentation/screens/search_products_screen.dart';
import 'package:swapify/presentation/screens/my_products_screen.dart';
import 'package:swapify/presentation/screens/messages_screen.dart';
import 'package:swapify/presentation/widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageStorageBucket bucket = PageStorageBucket();
  final List<Widget> pages = [
    const SearchProductsScreen(key: PageStorageKey('SearchProductsScreen')),
    const LikeProductsScreen(key: PageStorageKey('LikeProductsScreen')),
    const MyProductsScreen(key: PageStorageKey('MyProductsScreen')),
    const MessagesScreen(key: PageStorageKey('MessagesScreen')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(child: DrawerWidget()),
      body: BlocBuilder<NavigationBarBloc, NavigationBarState>(
        builder: (context, state) {
          return PageStorage(
            bucket: bucket,
            child: pages[state.numNavigationBar ?? 0],
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<NavigationBarBloc, NavigationBarState>(
        builder: (context, state) {
          return NavigationBar(
            onDestinationSelected: (int index) {
              context.read<NavigationBarBloc>().add(ChangeNavigationBarButtonPressed(numNavigationBar: index));
            },
            selectedIndex: state.numNavigationBar ?? 0,
            indicatorColor: Colors.transparent,
            destinations: <Widget>[
              NavigationDestination(
                selectedIcon: const Icon(Icons.home, color: Color.fromARGB(255, 12, 104, 70)),
                icon: const Icon(Icons.home_outlined),
                label: AppLocalizations.of(context)!.home,
              ),
              NavigationDestination(
                selectedIcon: const Icon(Icons.favorite, color: Color.fromARGB(255, 12, 104, 70)),
                icon: const Icon(Icons.favorite_border),
                label: AppLocalizations.of(context)!.home,
              ),
              NavigationDestination(
                selectedIcon: const Icon(Icons.list_sharp, color: Color.fromARGB(255, 12, 104, 70)),
                icon: const Icon(Icons.list_outlined),
                label: AppLocalizations.of(context)!.myProducts,
              ),
              NavigationDestination(
                selectedIcon: const Icon(Icons.messenger_sharp, color: Color.fromARGB(255, 12, 104, 70)),
                icon: const Icon(Icons.messenger),
                label: AppLocalizations.of(context)!.messages,
              ),
            ],
          );
        },
      ),
    );
  }
}
