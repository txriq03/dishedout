import 'package:flutter/material.dart';

class UserUploads extends StatefulWidget {
  const UserUploads({super.key});

  @override
  State<UserUploads> createState() => _UserUploadsState();
}

class _UserUploadsState extends State<UserUploads> {
  final CarouselController controller = CarouselController(initialItem: 1);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 400, minHeight: 200),
      child: CarouselView.weighted(
        controller: controller,
        itemSnapping: true,
        flexWeights: [8, 2],
        children: [
          Image.asset('assets/pancake.jpg', fit: BoxFit.cover),
          Image.asset('assets/meat.jpg', fit: BoxFit.cover),
          Image.asset('assets/spices.jpg', fit: BoxFit.cover),
        ],
      ),
    );
  }
}
