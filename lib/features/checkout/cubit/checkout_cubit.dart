import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/features/address/data/model/address_model.dart';
class CheckoutState {
  final AddressModel? selectedAddress;
  final String? selectedPaymentMethod;
  final String? promoCode;

  CheckoutState({
    this.selectedAddress,
    this.selectedPaymentMethod,
    this.promoCode,
  });

  CheckoutState copyWith({
    AddressModel? selectedAddress,
    String? selectedPaymentMethod,
    String? promoCode,
  }) {
    return CheckoutState(
      selectedAddress: selectedAddress ?? this.selectedAddress,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      promoCode: promoCode ?? this.promoCode,
    );
  }
}

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutState());

  void selectAddress(AddressModel address) {
    emit(state.copyWith(selectedAddress: address));
  }

  void selectPayment(String method) {
    emit(state.copyWith(selectedPaymentMethod: method));
  }

  void applyPromo(String code) {
    emit(state.copyWith(promoCode: code));
  }
}
