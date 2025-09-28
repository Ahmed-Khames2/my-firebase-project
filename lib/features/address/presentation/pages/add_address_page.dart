import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/features/address/data/model/address_model.dart';
import 'package:my_firebase_app/features/address/presentation/cubit/addrescubit.dart';
import 'package:my_firebase_app/features/address/presentation/cubit/address_state.dart';
import 'package:uuid/uuid.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  final _buildingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("إضافة عنوان")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "الاسم كامل"),
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "رقم الهاتف"),
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: "المدينة"),
              ),
              TextFormField(
                controller: _streetController,
                decoration: const InputDecoration(labelText: "الشارع"),
              ),
              TextFormField(
                controller: _buildingController,
                decoration: const InputDecoration(labelText: "رقم المبنى"),
              ),
              const SizedBox(height: 20),
              BlocConsumer<AddressCubit, AddressState>(
                listener: (context, state) {
                  if (state is AddressSuccess) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                    Navigator.pop(context, true);
                  }
                },
                builder: (context, state) {
                  if (state is AddressLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ElevatedButton(
                    onPressed: () {
                      final id = const Uuid().v4();
                      final userId =
                          currentUser!.uid; // هتجيبها من FirebaseAuth
                      final address = AddressModel(
                        id: id,
                        userId: userId,
                        fullName: _nameController.text,
                        phone: _phoneController.text,
                        city: _cityController.text,
                        street: _streetController.text,
                        building: _buildingController.text,
                      );
                      context.read<AddressCubit>().addAddress(address);
                      // Navigator.pop(context, true);

                    },
                    child: const Text("حفظ"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
