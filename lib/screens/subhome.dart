import 'package:flutter/material.dart';
import 'package:gsoc_debanjan/components/click.dart';
import 'package:gsoc_debanjan/connections/lgclick.dart';

class SubHome extends StatefulWidget {
  const SubHome({super.key});

  @override
  State<SubHome> createState() => _SubHomeState();
}

class _SubHomeState extends State<SubHome> {
  LGonnection lg = LGonnection();



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 25.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap : lg.sendlogo,
                child: Click(text: "Send\nLogo", colour: Color(0xffFF7575),)
              ),
              GestureDetector(
                onTap: lg.clearLogo,
                child: Click(text: "Clear\n Logo", colour: Color(0xff4DBF60),)
              ),
            ],
          ),
          SizedBox(height: 30.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: lg.sendKML1,
                child: Click(text: "Send\nKML1", colour: Color(0xff60A0FF),)
              ),
              GestureDetector(
                onTap: lg.sendKML2,
                child: Click(text: "Send\nKML2", colour: Color(0xffFF7575),)
              ),
            ],
          ),
          SizedBox(height: 30.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: lg.clearKML,
                child: Click(text: "Clear\n KML", colour: Color(0xff4DBF60),)
              ),
              GestureDetector(
                onTap: lg.reboot,
                child: Click(text: "Reboot", colour: Color(0xff60A0FF),)
              ),
            ],
          ),
          SizedBox(height: 30.0,),
          GestureDetector(
            onTap: lg.shutdown,
            child: Container(
                  height: 55.0,
                  width: double.maxFinite,
                  margin: EdgeInsets.symmetric(horizontal: 40.0),
                  decoration: BoxDecoration(
                      color: Color(0xffFF7575),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1.0, 2.0),
                          blurRadius: 3.0,
                        ),
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(-1.0, 2.0),
                          blurRadius: 3.0,
                        ),
                      ]
                      ),
                  child: Center(
                    child: Row(
                    children:[ 
                      SizedBox(width: 10.0),
                      Icon(
                        Icons.power_settings_new,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      SizedBox(width: 10.0,),
                      Text(
                      "Shutdown",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 25.0,
                        fontWeight: FontWeight.w800,
                        fontFamily: "Inter",
                        height: 1.1,
                      ),
                    ),
                    ]
                    ),
                  ),
                )
          ),
          SizedBox(height: 5.0,),
          ],
      ),
    );
  }
}
