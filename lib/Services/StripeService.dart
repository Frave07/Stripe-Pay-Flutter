import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:stripe_pagos/Models/PaymentIntentResponse.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;

import 'package:stripe_pagos/Models/StripeCustomResponse.dart';

class StripeService
{
    //singleton

    StripeService._privateConstructor();
    static final StripeService _intace = StripeService._privateConstructor();

    factory StripeService() => _intace;

    String _paymentApiUrl = 'https://api.stripe.com/v1/payment_intents';
    String _secretKey = '';
    String _apiKey = '';

    void init(){

        StripePayment.setOptions(
          StripeOptions(
            publishableKey: this._apiKey,
            androidPayMode: 'test',
            merchantId: 'test'
          )
        );

    }

    Future<StripeCustomResponse> pagarConTarjetaExistente({ 
      @required String amount,
      @required String currency,
      @required CreditCard card 
    }) async {

      try {

        final paymentMethod = await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: card)
        );

        final responsePago = await _realizarPago(amount: amount, currency: currency, paymentMethod: paymentMethod);

         return responsePago;
        
      } catch (e) {

        return StripeCustomResponse(ok: false, mensaje: e.toString());
      }

    }

    Future<StripeCustomResponse> pagarConNuevaTarjeta({ @required String amount, @required String currency }) async {

        try {

          final paymentMethod = await StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest());

          
          final responsePago = await _realizarPago(amount: amount, currency: currency, paymentMethod: paymentMethod);


          return responsePago;

        
        } catch (e) {
         
          return StripeCustomResponse(ok: false, mensaje: e.toString());
        }
    }

    Future<StripeCustomResponse> pagarConApplePayGooglePay({ @required String amount, @required String currency }) async {

        try {

          final token = await StripePayment.paymentRequestWithNativePay(
            androidPayOptions: AndroidPayPaymentRequest(currencyCode: currency, totalPrice: amount), 
            applePayOptions: ApplePayPaymentOptions(
              countryCode: 'US',
              currencyCode: currency,
              items: [
                ApplePayItem(
                  label: 'Producto Frave',
                  amount: amount
                )
              ]
            )
          );

          final paymentMethod = await StripePayment.createPaymentMethod(
              PaymentMethodRequest(
                card: CreditCard(
                  token: token.tokenId
              ))
          );

          final resp = await this._realizarPago(amount: amount, currency: currency, paymentMethod: paymentMethod);


          await StripePayment.completeNativePayRequest();

          return resp;
          

        } catch (e) {

          return StripeCustomResponse(ok: false, mensaje: e.toString());
        }

    }

    Future _crearPaymentIntent({ @required String amount, @required String currency }) async {

      try {

          final data = {
            'amount': amount,
            'currency': currency
          };

          var url = Uri.parse(_paymentApiUrl);

          final response = await http.post(url, headers: {
            'Accept': 'application/json',
            'Authorization' : 'Bearer $_secretKey'
          }, body: data);

          var resp = json.decode( response.body );

          return PaymentIntentResponse.fromJson(resp);

        
      } catch (e) {
          return PaymentIntentResponse(status: '400');
      }

    }

    Future<StripeCustomResponse> _realizarPago({
      @required String amount,
      @required String currency,
      @required PaymentMethod paymentMethod
    }) async {

      try {

        final paymentIntet = await _crearPaymentIntent(amount: amount, currency: currency);

        final responsePaymentResult = await StripePayment.confirmPaymentIntent(
          PaymentIntent(
            clientSecret: paymentIntet.clientSecret,
            paymentMethodId: paymentMethod.id
          )
        );

        if( responsePaymentResult.status == 'succeeded' ){

          return StripeCustomResponse(ok: true);

        } else {

          return StripeCustomResponse(ok: false, mensaje: 'Algo salio mal : ${responsePaymentResult.status}');

        }

        
      } catch (e) {

          return StripeCustomResponse(ok: false, mensaje: e.toString());
      }

    }
}