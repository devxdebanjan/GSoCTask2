import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gsoc_debanjan/screens/settings.dart';
import 'package:gsoc_debanjan/screens/subhome.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  
  
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.white,
      
      body: Column(
        children: [
          SizedBox(
            height: 15.0,
            
          ),
          Center(
            child: Container(
              height: 150.0,
              width: 150.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/lglogo.png"),
                      fit: BoxFit.contain)),
            ),
          ),
          Container( 
            child: TabBar(
              indicatorColor: const Color.fromARGB(255, 105, 234, 110),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 5.0,
              labelStyle: TextStyle(
                fontSize: 22.0,
                color: Colors.black,
              ),
              unselectedLabelColor: const Color.fromARGB(255, 121, 121, 121),
              controller: tabController,
              tabs: [
              Tab(text: "Home"),
              Tab(text: "Settings"),
               ], 
            )
          ),
          
            Expanded(
                child: TabBarView(
                  controller: tabController,
              children: [
                SubHome(),
                Settings(),
              ],
             ),
            ),
          
        ],
      ),
    );
  }
}
