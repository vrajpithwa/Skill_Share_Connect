import 'package:flutter/material.dart';
import 'package:ssc/components/list_tile.dart';

class MyDrawer extends StatefulWidget {
  final void Function()? onProfile;
  final void Function()? onLogout;
  final void Function()? onPayment;

  const MyDrawer({
    super.key,
    required this.onProfile,
    required this.onLogout,
    required this.onPayment,
  });

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const DrawerHeader(
                child: Icon(
                  Icons.person,
                  size: 50,
                ),
              ),
              MyListTile(
                icon: Icons.home,
                text: "Home",
                onTap: () => Navigator.pop(context),
              ),
              MyListTile(
                  icon: Icons.person_2,
                  text: "Profile",
                  onTap: widget.onProfile),
              MyListTile(
                  icon: Icons.upgrade,
                  text: "Upgrade to Premium",
                  onTap: widget.onPayment),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: MyListTile(
                icon: Icons.logout_rounded,
                text: "Logout",
                onTap: widget.onLogout),
          )
          // Add more ListTile items as needed
        ],
      ),
    );
  }
}
