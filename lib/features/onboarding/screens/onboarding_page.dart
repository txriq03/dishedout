import 'package:dishedout/features/authentication/screens/auth_page.dart';
import 'package:dishedout/features/onboarding/data/onboarding_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // PageView showing onboarding slides
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: onboardingPages.length,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final page = onboardingPages[index];
                return Stack(
                  children: [
                    // Centered SVG image
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: SvgPicture.asset(page.imagePath, height: 300),
                      ),
                    ),

                    // Bottom text content
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SafeArea(
                        minimum: const EdgeInsets.only(bottom: 100),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                page.title,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                page.description,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.75),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              onboardingPages.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: currentPage == index ? 16 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color:
                      currentPage == index
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                if (currentPage == onboardingPages.length - 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthPage()),
                  );
                } else {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                currentPage == onboardingPages.length - 1
                    ? 'Get Started'
                    : 'Next',
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
