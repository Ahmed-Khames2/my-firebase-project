import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/core/routes/app_routes.dart';
import 'package:my_firebase_app/features/address/data/model/address_model.dart';
import 'package:my_firebase_app/features/address/presentation/cubit/addrescubit.dart';
import 'package:my_firebase_app/features/address/presentation/cubit/address_state.dart';
import 'package:my_firebase_app/features/address/presentation/pages/add_address_page.dart';

class AddressListPage extends StatefulWidget {
  final String userId; // لازم يتبعت من FirebaseAuth
  const AddressListPage({super.key, required this.userId});

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  AddressModel? selectedAddress;

  @override
  void initState() {
    super.initState();
    context.read<AddressCubit>().loadAddresses(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("اختيار العنوان"),
        // actions: [
        //   IconButton(
        //     onPressed: () async {
        //       final added = await Navigator.pushNamed(context, AppRoutes.addAddressPage);
        //       if (added == true) {
        //         context.read<AddressCubit>().loadAddresses(widget.userId);
        //       }
        //     },
        //     icon: const Icon(Icons.add_location_alt),
        //   ),
        // ],
      ),
      body: BlocBuilder<AddressCubit, AddressState>(
        builder: (context, state) {
          if (state is AddressLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AddressLoaded) {
            return Column(
              children: [
                Expanded(
                  child:
                      state.addresses.isEmpty
                          ? const Center(child: Text("لا توجد عناوين بعد"))
                          : ListView.builder(
                            itemCount: state.addresses.length,
                            itemBuilder: (context, index) {
                              final address = state.addresses[index];
                              final isSelected =
                                  selectedAddress?.id == address.id;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedAddress = address;
                                  });
                                },
                                child: Card(
                                  margin: const EdgeInsets.all(8),
                                  color:
                                      isSelected
                                          ? Colors.blue[50]
                                          : Colors.white,
                                  child: ListTile(
                                    title: Text(
                                      "${address.fullName} - ${address.phone}",
                                    ),
                                    subtitle: Text(
                                      "${address.city}, ${address.street}, مبنى ${address.building}",
                                    ),
                                    trailing:
                                        isSelected
                                            ? const Icon(
                                              Icons.check_circle,
                                              color: Colors.blue,
                                            )
                                            : null,
                                  ),
                                ),
                              );
                            },
                          ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final added = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => BlocProvider.value(
                                value: context.read<AddressCubit>(),
                                child: const AddAddressPage(),
                              ),
                        ),
                      );
                      if (added == true) {
                        context.read<AddressCubit>().loadAddresses(
                          widget.userId,
                        );
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("إضافة عنوان جديد"),
                  ),
                ),
              ],
            );
          } else if (state is AddressError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed:
              selectedAddress == null
                  ? null
                  : () {
                    Navigator.pop(context, selectedAddress);
                  },
          child: const Text("تأكيد العنوان"),
        ),
      ),
    );
  }
}
