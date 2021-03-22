part of 'carrito_bloc.dart';

@immutable
class CarritoState
{
    final double montoPagar;
    final String moneda;
    final bool tarjetaActiva;
    final TarjetaCredito tarjeta;

  String get montoPagarString => '${ (this.montoPagar * 100).floor() }';

  CarritoState({
    this.montoPagar = 350.00,
    this.moneda = 'USD',
    this.tarjetaActiva = false,
    this.tarjeta
  });

  CarritoState copyWith({ double montoPagar, String moneda, bool tarjetaActiva, TarjetaCredito tarjeta })
    => CarritoState(
        montoPagar : montoPagar ?? this.montoPagar,
        moneda     : moneda ?? this.moneda,
        tarjeta    : tarjeta ?? this.tarjeta,
        tarjetaActiva : tarjetaActiva ?? this.tarjetaActiva
    );
}