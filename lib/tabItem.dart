import 'package:flutter/material.dart';

enum TabItem { Kullanicilar, Profil }

class TabItemData {
  final String title;
  final IconData icon;

  TabItemData({required this.title,required this.icon});

  static Map<TabItem,TabItemData> tumTablar = {

        TabItem.Kullanicilar : TabItemData(title:"Kullanıcılar",icon: Icons.supervised_user_circle),
        TabItem.Profil : TabItemData(title:"Profil",icon: Icons.face_outlined)
  };

}
