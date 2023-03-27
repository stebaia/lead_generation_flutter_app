import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Menu {
  final Icon icon;
  final String label;

  const Menu({required this.icon, required this.label});

  static List<Menu> gerateMenuFromUserType(int type) {
    switch (type) {
      case 106:
        {
          return <Menu>[
            const Menu(icon: Icon(CupertinoIcons.qrcode), label: ''),
            const Menu(icon: Icon(CupertinoIcons.list_bullet), label: ''),
            const Menu(icon: Icon(CupertinoIcons.settings), label: ''),
          ];
        }
      default:
        {
          return <Menu>[
            const Menu(icon: Icon(CupertinoIcons.qrcode), label: 'Scan'),
            const Menu(icon: Icon(CupertinoIcons.settings), label: 'Settings'),
          ];
        }
    }
  }
}
