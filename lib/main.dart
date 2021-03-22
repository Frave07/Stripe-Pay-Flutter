import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_pagos/Bloc/Carrito/carrito_bloc.dart';

import 'package:stripe_pagos/Pages/Home.dart';
import 'package:stripe_pagos/Pages/Pago.dart';
import 'package:stripe_pagos/Services/StripeService.dart';

 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0XFF0E141C)
    ));

    new StripeService()
      ..init();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CarritoBloc())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Stripe Pay',
        initialRoute: 'home',
        routes: {
          'home' : (_) => HomePage(),
          'pago' : (_) => PagoCompletoPage(),
        },
        theme: ThemeData.dark().copyWith(
          primaryColor: Color(0XFF0E141C),
          scaffoldBackgroundColor: Color(0XFF0E141C),
          
        ),
      ),
    );
  }
}