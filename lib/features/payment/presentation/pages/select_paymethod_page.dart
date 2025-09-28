import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/features/payment/presentation/cubit/payment_state.dart';
import '../cubit/payment_cubit.dart';

class PaymentMethodPage extends StatelessWidget {
  final String userId;
  const PaymentMethodPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("اختر طريقة الدفع")),
      body: BlocBuilder<PaymentCubit, PaymentState>(
        builder: (context, state) {
          if (state is PaymentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PaymentLoaded) {
            if (state.methods.isEmpty) {
              return const Center(child: Text("لا توجد طرق دفع بعد"));
            }
            return ListView.builder(
              itemCount: state.methods.length,
              itemBuilder: (context, index) {
                final method = state.methods[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: Icon(
                      method.type == "cash"
                          ? Icons.money
                          : Icons.credit_card,
                      color: Colors.blue,
                    ),
                    title: Text(method.type == "cash"
                        ? "Cash on Delivery"
                        : "Credit Card"),
                    subtitle: method.details != null
                        ? Text(method.details.toString())
                        : null,
                    trailing: method.isDefault
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                    onTap: () {
                      Navigator.pop(context, method);
                    },
                    onLongPress: () {
                      context.read<PaymentCubit>().selectDefault(method.id, userId);
                    },
                  ),
                );
              },
            );
          } else if (state is PaymentError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
