import 'package:flutter/material.dart';

class UploadsCarousel extends StatefulWidget {
  const UploadsCarousel({super.key});

  @override
  State<UploadsCarousel> createState() => _UploadsCarouselState();
}

class _UploadsCarouselState extends State<UploadsCarousel> {
  final CarouselController controller = CarouselController(initialItem: 0);

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
