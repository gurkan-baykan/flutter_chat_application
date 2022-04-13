import 'package:firebase_proje/my_custom_bottom_navigation.dart';
import 'package:firebase_proje/tabItem.dart';
import 'package:firebase_proje/tab_menuler/kullanicilar.dart';
import 'package:firebase_proje/tab_menuler/profil.dart';
import 'package:firebase_proje/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.Kullanicilar;
  
   Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Kullanicilar: KullanicilarPage(), 
      TabItem.Profil: ProfilPage()
      
      };
  }
  
   Map<TabItem, GlobalKey<NavigatorState>> _navigatorKeys =
      {
      TabItem.Kullanicilar:  GlobalKey<NavigatorState>(), 
      TabItem.Profil:GlobalKey<NavigatorState>(), 
      
      };
  

  @override
  Widget build(BuildContext context) {

   

    return Container(
          child: MyCustomBottomNavigation(
            sayfaOlusturucu:tumSayfalar() ,
            currentTab: _currentTab,
            onSelectedTab: (secilenTab) {
                
                if(secilenTab == _currentTab)
                {
                    setState(() {
                          _navigatorKeys[secilenTab]?.currentState?.popUntil((route) => route.isFirst);
                    });
                  
                }
                else{
                   setState(() {
                 
                   _currentTab = secilenTab;
                  });
                }
             
             
          }),
    );
         
        
  }
}
