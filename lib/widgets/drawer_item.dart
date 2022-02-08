import 'package:flutter/material.dart';

class DrawerItems extends StatelessWidget {
  const DrawerItems({
    this.icon,
    this.label,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onTap;
  final IconData? icon;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap!,
      leading: Icon(
        icon,
        color: Colors.grey.shade400,
        size: 18,
      ),
      title: Text(
        label!,
        style: TextStyle(
          fontSize: 11,
        ),
      ),
    );
  }
}
