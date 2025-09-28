import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/features/address/data/model/address_model.dart';
import 'package:my_firebase_app/features/address/presentation/cubit/address_state.dart';
import 'package:my_firebase_app/features/address/service/address_service.dart';

class AddressCubit extends Cubit<AddressState> {
  final AddressService _addressService;

  AddressCubit(this._addressService) : super(AddressInitial());

  Future<void> addAddress(AddressModel address) async {
    emit(AddressLoading());
    try {
      await _addressService.addAddress(address);
      emit(AddressSuccess("تم إضافة العنوان بنجاح"));
    } catch (e) {
      emit(AddressError("خطأ: ${e.toString()}"));
    }
  }

  Future<void> loadAddresses(String userId) async {
    emit(AddressLoading());
    try {
      final addresses = await _addressService.getUserAddresses(userId);
      emit(AddressLoaded(addresses));
    } catch (e) {
      emit(AddressError("خطأ: ${e.toString()}"));
    }
  }
}
