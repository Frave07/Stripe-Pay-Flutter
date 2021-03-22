import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:stripe_pagos/Models/TarjetaCredito.dart';

part 'carrito_event.dart';
part 'carrito_state.dart';

class CarritoBloc extends Bloc<CarritoEvent, CarritoState> {


  CarritoBloc() : super(CarritoState());

  @override
  Stream<CarritoState> mapEventToState( CarritoEvent event ) async* {

      if ( event is OnSeleccionarTarjeta ){

        yield state.copyWith(tarjetaActiva: true, tarjeta: event.tarjeta );
      
      } else if ( event is OnDesactivarTarjeta ){

        yield state.copyWith( tarjetaActiva: false );
      }
  }
}
