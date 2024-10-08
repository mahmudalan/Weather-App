import 'package:flutter/material.dart';
import 'package:weather/pages/homepage.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white.withOpacity(0.3),
      width: 230,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [ UserAccountsDrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.transparent
          ),
            accountName: const Text('Mahmud Alan', style: TextStyle( fontFamily: 'Mondapick'),),
            accountEmail: const Text('mahmudalan77@gmail.com', style: TextStyle( fontFamily: 'Mondapick'),),
          currentAccountPicture: CircleAvatar(
            child: ClipOval(
              child: Image.asset('lib/assets/user.jpg',),
            ),
          ),
        ),
          ListTile(
            leading: Image.asset('lib/assets/home.png',height: 25,color: Colors.white),
            title: const Text('Dashboard',
              style: TextStyle(
                  fontFamily: 'Mondapick',
                  color: Colors.white,
                  fontSize: 15
              ),),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const Homepage()));
            },
          ),
      ]
      ),
    );
  }
}

