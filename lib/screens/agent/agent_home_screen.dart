import 'package:flutter/material.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/screens/admin/allorders.dart';
import 'package:p2p/screens/user/delivery_request_screen.dart';
import 'package:p2p/screens/user/history.dart';
import 'package:p2p/screens/user/myorder.dart';
import 'package:p2p/screens/agent/nearby_order.dart';
import 'package:p2p/screens/user/order_screen.dart';

class Agent_Home_Screen extends StatefulWidget {
  static String routeName = "/Agent_home_Screen";
  const Agent_Home_Screen({super.key});
  @override
  State<Agent_Home_Screen> createState() => _HomeState();
}

class _HomeState extends State<Agent_Home_Screen> {
  late List<Map<String, Object>> _pages;
  int _selectedIndex = 0;
  @override
  void didChangeDependencies() {
    _pages = [
      // {
      //   'page': const DeliveryRequest(),
      // },
      {'page': const NearByOrderScreen()},
      // {'page': const AllOrdersScreen()},
      {'page': const HistoryScreen()},
      // {'page': const MyOrderScreen()},
    ];

    super.didChangeDependencies();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: P2pAppColors.grey,
      body: _getPage(_selectedIndex),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _selectPage,
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      // case :
      //   return const DeliveryRequest();
      case 0:
        return const NearByOrderScreen();
      case 1:
        return const HistoryScreen();
      // case 2:
      //   return const NearByOrderScreen();
      // case 3:
      //   return const MyOrderScreen();
      default:
        return const SizedBox.shrink();
    }
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.home),
        //   label: '',
        // ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.delivery_dining_outlined),
        //   label: 'Order', // You can set this to null if needed
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_city_rounded),
          label: 'Nearby Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'History',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.check_circle_rounded),
        //   label: 'my orders',
        // ),
      ],
      selectedItemColor: P2pAppColors.yellow,
      unselectedItemColor: Colors.black,
      unselectedLabelStyle: const TextStyle(color: Colors.black),
    );
  }
}
