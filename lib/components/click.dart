import 'package:flutter/material.dart';

class Click extends StatelessWidget {
  const Click({required this.text, required this.colour,super.key,});
  final String text;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Container(
                height: 150.0,
                width: 150.0,
                decoration: BoxDecoration(
                    color: colour,
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
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 25.0,
                      fontWeight: FontWeight.w800,
                      fontFamily: "Inter",
                      height: 1.1,
                    ),
                  ),
                ),
              );
  }
}