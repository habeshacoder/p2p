import 'package:flutter/material.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/screens/admin/allorders.dart';
import 'package:p2p/screens/user/delivery_request_screen.dart';
import 'package:p2p/screens/user/myorder.dart';
import 'package:p2p/screens/agent/nearby_order.dart';
import 'package:p2p/screens/user/order_screen.dart';
import 'package:p2p/screens/user/history.dart';

class User_Home extends StatefulWidget {
  static String routeName = "/User_home";
  const User_Home({this.toIndex = 0});
  final int toIndex;
  @override
  State<User_Home> createState() => _HomeState();
}

class _HomeState extends State<User_Home> {
  late List<Map<String, Object>> _pages;
  late int _selectedIndex;
  @override
  void didChangeDependencies() {
    _selectedIndex = widget.toIndex;
    _pages = [
      {
        'page': const DeliveryRequest(),
      },
      {'page': const OrderScreen()},
      // {'page': const AllOrdersScreen()},
      {'page': const MyOrderScreen()},
      {'page': const HistoryScreen()},
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
      case 0:
        return const DeliveryRequest();
      case 1:
        return const OrderScreen();
      // case 2:
      //   return const AllOrdersScreen();
      case 2:
        return const MyOrderScreen();
      case 3:
        return const HistoryScreen();
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
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.delivery_dining_outlined),
          label: 'Order', // You can set this to null if needed
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.list),
        //   label: 'Orders',
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.check_circle_rounded),
          label: 'my orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'History',
        ),
      ],
      selectedItemColor: P2pAppColors.yellow,
      unselectedItemColor: Colors.black,
      unselectedLabelStyle: const TextStyle(color: Colors.black),
    );
  }
}
