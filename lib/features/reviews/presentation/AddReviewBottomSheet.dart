// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:my_firebase_app/features/reviews/cubit/review_cubit.dart';

// class AddReviewBottomSheet extends StatefulWidget {
//   final String productId;
  

//   const AddReviewBottomSheet({super.key, required this.productId});

//   @override
//   State<AddReviewBottomSheet> createState() => _AddReviewBottomSheetState();
// }

// class _AddReviewBottomSheetState extends State<AddReviewBottomSheet> {
//   final TextEditingController _controller = TextEditingController();
//   double _rating = 3.0;
//   final currentUser = FirebaseAuth.instance.currentUser;


//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Text("Add Review", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 16),

//           // Rating Slider
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.star, color: Colors.amber),
//               Slider(
//                 value: _rating,
//                 min: 1,
//                 max: 5,
//                 divisions: 4,
//                 label: _rating.toString(),
//                 onChanged: (val) {
//                   setState(() => _rating = val);
//                 },
//               ),
//             ],
//           ),

//           TextField(
//             controller: _controller,
//             decoration: const InputDecoration(
//               hintText: "Write your review...",
//               border: OutlineInputBorder(),
//             ),
//             maxLines: 3,
//           ),
//           const SizedBox(height: 16),

//           ElevatedButton(
//             onPressed: () {
//               context.read<ReviewCubit>().addReview(
//                     productId: widget.productId,
//           userId: currentUser!.uid, // ✅ جبت uid من FirebaseAuth
//                     rating: _rating,
//                     comment: _controller.text,
//                   );
//               Navigator.pop(context);
//             },
//             child: const Text("Submit"),
//           )
//         ],
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/features/reviews/cubit/review_cubit.dart';

class AddReviewBottomSheet extends StatefulWidget {
  final String productId;

  const AddReviewBottomSheet({super.key, required this.productId});

  @override
  State<AddReviewBottomSheet> createState() => _AddReviewBottomSheetState();
}

class _AddReviewBottomSheetState extends State<AddReviewBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  double _rating = 3.0;
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Add Review", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber),
                Slider(
                  value: _rating,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: _rating.toString(),
                  onChanged: (val) => setState(() => _rating = val),
                ),
              ],
            ),

            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Write your review...",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () async {
                final success = await context.read<ReviewCubit>().addReview(
                      productId: widget.productId,
                      userId: currentUser!.uid,
                      rating: _rating,
                      comment: _controller.text,
                    );

                if (!success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("You already reviewed this product")));
                  return;
                }

                Navigator.pop(context);
              },
              child: const Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}
