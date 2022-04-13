import 'package:firebase_proje/home.dart';
import 'package:firebase_proje/tabItem.dart';
import 'package:firebase_proje/tab_menuler/kullanicilar.dart';
import 'package:firebase_proje/tab_menuler/profil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCustomBottomNavigation extends StatelessWidget {
  MyCustomBottomNavigation(
      {Key? key,
      required this.currentTab,
      required this.onSelectedTab,
      required this.sayfaOlusturucu
      })
      : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem,Widget> sayfaOlusturucu;

   final Map<TabItem,Widget>tumSayfalar =   {
        
        
          TabItem.Kullanicilar: KullanicilarPage(), 
          TabItem.Profil: ProfilPage()
      
      };



  @override
  Widget build(BuildContext context) {
   
   

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _navItemOlusur(TabItem.Kullanicilar),
          _navItemOlusur(TabItem.Profil)
        ],
        onTap: (index) => onSelectedTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final gosterilcekItem = TabItem.values[index];
        return CupertinoTabView(builder: (context) {

         
          return    sayfaOlusturucu[gosterilcekItem] as Widget;
        
             
        });
      },
    );
  }

  BottomNavigationBarItem _navItemOlusur(TabItem tabItem) {
    final olusturulucakTab = TabItemData.tumTablar[tabItem];

    return BottomNavigationBarItem(
        icon: Icon(olusturulucakTab?.icon), label: olusturulucakTab?.title);
  }
}
