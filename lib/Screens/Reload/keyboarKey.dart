import 'package:flutter/material.dart';

class KeyboardKey extends StatefulWidget {

final String label;
final dynamic value;
final ValueSetter<dynamic> onTap;

  const KeyboardKey({ Key? key, required this.label, required this.value, required this.onTap }) : super(key: key);

  @override
  _KeyboardKeyState createState() => _KeyboardKeyState();
}

class _KeyboardKeyState extends State<KeyboardKey> {

  renderLbel(){

    if(widget.label is Widget){
       return widget.label;
    }
    return Text(
      widget.label,
      style:TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    return InkWell( 

      onTap: (){
        widget.onTap(widget.value);
      },
      child: AspectRatio(
        aspectRatio: 2,
        child: Container(
          child: Center(
            child: renderLbel() 
            
          ),
        ),
      ),
    );
  }
}