import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class PagoCompletoPage extends StatelessWidget
{

 @override
 Widget build(BuildContext context)
 {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon( FontAwesomeIcons.solidCheckCircle, size: 150, ),
            SizedBox(height: 30),
            Text('Pago realizado con exito!', style: TextStyle(fontSize: 24))   
          ],
        )
      ) ,
    );
  }
}