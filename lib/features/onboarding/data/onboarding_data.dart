class OnboardingInfo {
  final String title;
  final String description;
  final String imagePath;

  OnboardingInfo({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

final List<OnboardingInfo> onboardingPages = [
  OnboardingInfo(
    title: 'Welcome to DishedOut',
    description: 'Share food and reduce waste in your community.',
    imagePath: 'assets/animations/onboarding1.json',
  ),
  OnboardingInfo(
    title: 'Lend and Borrow Easily',
    description: 'Post or claim food quickly using our simple platform.',
    imagePath: 'assets/animations/onboarding2.json',
  ),
  OnboardingInfo(
    title: 'Track & Meet',
    description: 'Live tracking makes pickup seamless and secure.',
    imagePath: 'assets/animations/onboarding3.json',
  ),
];
