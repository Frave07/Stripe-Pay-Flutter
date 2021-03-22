import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stripe_pagos/Bloc/Carrito/carrito_bloc.dart';
import 'package:stripe_pagos/Helpers/Helpers.dart';
import 'package:stripe_pagos/Services/StripeService.dart';
import 'package:stripe_payment/stripe_payment.dart';


class BottomPagar extends StatelessWidget
{

 @override
 Widget build(BuildContext context)
 {
   final carritoBloc = BlocProvider.of<CarritoBloc>(context).state;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      width: MediaQuery.of(context).size.width,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Total', style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold)),
              Text('\$ ${carritoBloc.montoPagar} ${carritoBloc.moneda} ', style: TextStyle(fontSize: 22, color: Colors.black))
            ],
          ),

          BlocBuilder<CarritoBloc, CarritoState>(
            builder: (_, state) {

              if( state is OnSeleccionarTarjeta ){
                
                return _BtnPay(activo: state.tarjetaActiva );
              }
              else if ( state is OnDesactivarTarjeta ){

                return _BtnPay(activo: state.tarjetaActiva );
                
              } else {

                 return _BtnPay(activo: state.tarjetaActiva );
              }
              
            },
          )

        ],
      ),
    );
  }
}

class _BtnPay extends StatelessWidget {

  final bool activo;

  const _BtnPay({ this.activo });

  @override
  Widget build(BuildContext context) {
      return activo
      ? buildPayCreditCard(context)
      : buildPayGoogleAndApple(context);
  }

  Widget buildPayCreditCard(BuildContext context) {
    return MaterialButton(
      child: Row(
        children: [
          Icon(FontAwesomeIcons.solidCreditCard),
          SizedBox(width: 15),
          Text('Pagar', style: TextStyle(fontSize: 18))
        ],
      ),
      height: 45,
      minWidth: 150,
      color: Color(0xFF0E141C),
      shape: StadiumBorder(),
      onPressed: () async {

          mostrarLoading(context);

          final stripeService = new StripeService();
          final state = BlocProvider.of<CarritoBloc>(context).state;
          final tarjeta = state.tarjeta;
          final mesAnio = tarjeta.expiracyDate.split('/');

          final resp = await stripeService.pagarConTarjetaExistente(
            amount: state.montoPagarString,
            currency: state.moneda,
            card: CreditCard(
              number: tarjeta.cardNumber,
              expMonth: int.parse(mesAnio[0]),
              expYear:  int.parse(mesAnio[1])
            )
          );

          Navigator.pop(context);

          if( resp.ok ){
              
            mostrarAlerta(context, 'Tarjeta Correcta', 'Pago realizado con exito!');

          } else {

            mostrarAlerta(context, 'Algo salio mal', resp.mensaje);
            
          }

      }
    );
  }
  
  Widget buildPayGoogleAndApple(BuildContext context) {
    return MaterialButton(
      child: Row(
        children: [
          Platform.isAndroid
          ? Icon(FontAwesomeIcons.google)
          : Icon(FontAwesomeIcons.apple),
          SizedBox(width: 10),
          Text('Pagar', style: TextStyle(fontSize: 18))
        ],
      ),
      height: 45,
      minWidth: 140,
      color: Color(0xFF0E141C),
      shape: StadiumBorder(),
      onPressed: () async {

        final stripeService = new StripeService();
        final state = BlocProvider.of<CarritoBloc>(context).state;

        await stripeService.pagarConApplePayGooglePay(amount: state.montoPagarString, currency: state.moneda);

      }
    );
  }

 
}

