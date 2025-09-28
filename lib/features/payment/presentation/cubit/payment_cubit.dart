import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/features/payment/presentation/cubit/payment_state.dart';
import 'package:my_firebase_app/features/payment/service/payment_service.dart';



class PaymentCubit extends Cubit<PaymentState> {
  final PaymentMethodService service;

  PaymentCubit(this.service) : super(PaymentInitial());

  Future<void> loadMethods(String userId) async {
    emit(PaymentLoading());
    try {
      final methods = await service.getUserMethods(userId);
      emit(PaymentLoaded(methods: methods));
    } catch (e) {
      emit(PaymentError("فشل تحميل طرق الدفع"));
    }
  }

  Future<void> selectDefault(String methodId, String userId) async {
    try {
      await service.setDefaultMethod(methodId, userId);
      await loadMethods(userId);
    } catch (e) {
      emit(PaymentError("فشل تحديث طريقة الدفع"));
    }
  }
}
