part of 'carrito_bloc.dart';

@immutable
abstract class CarritoEvent {}


class OnSeleccionarTarjeta extends CarritoEvent
{
  final TarjetaCredito tarjeta;

  OnSeleccionarTarjeta(this.tarjeta);
}

class OnDesactivarTarjeta extends CarritoEvent {}