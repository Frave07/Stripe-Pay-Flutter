import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stripe_pagos/Bloc/Carrito/carrito_bloc.dart';
import 'package:stripe_pagos/Data/Tarjetas.dart';
import 'package:stripe_pagos/Helpers/Helpers.dart';
import 'package:stripe_pagos/Pages/Tarjeta.dart';
import 'package:stripe_pagos/Services/StripeService.dart';
import 'package:stripe_pagos/Widgets/BottomPagar.dart';


class HomePage extends StatelessWidget
{
  final stripeService = new StripeService();

 @override
 Widget build(BuildContext context)
 {
   final carritoBloc = BlocProvider.of<CarritoBloc>(context);
   
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.plusSquare, size: 25),
            onPressed: () async {

              mostrarLoading(context);
              
              final amount    = carritoBloc.state.montoPagarString;
              final currency = carritoBloc.state.moneda;

              final resp = await stripeService.pagarConNuevaTarjeta(amount: amount, currency: currency);

              Navigator.pop(context);

              if( resp.ok ){
                 
                mostrarAlerta(context, 'Tarjeta Correcta', 'Pago procesado');

              } else {

                mostrarAlerta(context, 'Algo salio mal', resp.mensaje);
              }

            }
          )
        ],
      ),
       body: Stack(
         children: [

           Positioned(
             height: MediaQuery.of(context).size.height,
             width: MediaQuery.of(context).size.width,
             top: 150,
             child: PageView.builder(
               controller: PageController(
                 viewportFraction: 0.9
               ),
               physics: BouncingScrollPhysics(),
               itemCount: tarjetas.length,
               itemBuilder: (_, i) {

                  final tarjeta = tarjetas[i];

                  return GestureDetector(
                    onTap: () {
                      
                        carritoBloc.add(OnSeleccionarTarjeta(tarjeta));

                        Navigator.push(context, navegarFadeIn(context, TarjetaPage())); 
                    },
                    child: Hero(
                      tag: tarjeta.cardHolderName,
                      child: CreditCardWidget(
                        cardNumber: tarjeta.cardNumber, 
                        expiryDate: tarjeta.expiracyDate, 
                        cardHolderName: tarjeta.cardHolderName, 
                        cvvCode: tarjeta.cvv, 
                        showBackView: false,
                        height: 220,
                        cardBgColor: Color(0xFF1F252C)
                      ),
                    ),
                  );

               },
              ),
           ),

            Positioned(
              bottom: 0,
              child: BottomPagar()
            )

         ],
       ),
     );
  }
}