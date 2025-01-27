import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  int currentPageIndex = 0;
  final PageStorageBucket bucket = PageStorageBucket();

  final List<Widget> pages = [
    const SearchProductsScreen(key: PageStorageKey('SearchProductsScreen')),
    const MyProductsScreen(key: PageStorageKey('MyProductsScreen')),
    const MessagesScreen(key: PageStorageKey('MessagesScreen')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: DrawerWidget(),
      ),
      body: PageStorage(
        bucket: bucket,
        child: pages[currentPageIndex],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        indicatorColor: Colors.transparent,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: const Icon(Icons.home),
            icon: const Icon(Icons.home_outlined),
            label: AppLocalizations.of(context)!.home,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.list),
            icon: const Icon(Icons.list_outlined),
            label: AppLocalizations.of(context)!.myProducts,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.messenger_sharp),
            icon: const Icon(Icons.messenger),
            label: AppLocalizations.of(context)!.messages,
          ),
        ],
      ),
    );
  }
}
