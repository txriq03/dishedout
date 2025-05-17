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
    imagePath: 'assets/images/onboarding/community.svg',
  ),
  OnboardingInfo(
    title: 'Lend and Borrow Easily',
    description: 'Post or claim food quickly using our simple platform.',
    imagePath: 'assets/images/onboarding/selecting.svg',
  ),
  OnboardingInfo(
    title: 'Track & Meet',
    description: 'Live tracking makes pickup seamless and secure.',
    imagePath: 'assets/images/onboarding/chef.svg',
  ),
];
