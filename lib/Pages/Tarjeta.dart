import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:stripe_pagos/Bloc/Carrito/carrito_bloc.dart';
import 'package:stripe_pagos/Widgets/BottomPagar.dart';


class TarjetaPage extends StatelessWidget
{

 @override
 Widget build(BuildContext context)
 {
    final carritoBloc = BlocProvider.of<CarritoBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pay'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {

            carritoBloc.add(OnDesactivarTarjeta());
            Navigator.pop(context);

          },
        ),
      ),
      body: Stack(
        children: [

          Container(),

          Hero(
            tag: carritoBloc.state.tarjeta.cardHolderName,
            child: CreditCardWidget(
                cardNumber: carritoBloc.state.tarjeta.cardNumber, 
                expiryDate: carritoBloc.state.tarjeta.expiracyDate, 
                cardHolderName: carritoBloc.state.tarjeta.cardHolderName, 
                cvvCode: carritoBloc.state.tarjeta.cvv, 
                showBackView: false,
                cardBgColor: Color(0xFF1F252C),
            ),
          ),


          Positioned(
            bottom: 0,
            child: BottomPagar()
          )

        ],
      )
    );
  }
}