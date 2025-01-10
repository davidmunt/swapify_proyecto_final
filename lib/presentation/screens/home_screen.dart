import 'package:flutter/material.dart';
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

  final List<Widget> pages = [
    const SearchProductsScreen(), 
    const MyProductsScreen(),
    const MessagesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: DrawerWidget(),
      ),
      body: pages[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        indicatorColor: Colors.transparent,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.list),
            icon: Icon(Icons.list_outlined),
            label: 'Mis productos',
          ),
          NavigationDestination(
            selectedIcon: Badge(
              label: Text('12'),
              child: Icon(Icons.messenger),
            ),
            icon: Badge(
              label: Text('12'),
              child: Icon(Icons.messenger_sharp),
            ),
            label: 'Mensajes',
          ),
        ],
      ),
    );
  }
}
