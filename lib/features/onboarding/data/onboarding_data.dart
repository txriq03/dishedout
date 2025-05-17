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
    description:
        'DishedOut works by our users sharing the spare food they have, ultimately reducing food waste in households.',
    imagePath: 'assets/images/onboarding/community.svg',
  ),
  OnboardingInfo(
    title: 'Lend and Borrow Easily',
    description:
        'Post or claim food quickly using our simple platform. Our intuitive interface makes interaction super easy!',
    imagePath: 'assets/images/onboarding/selecting.svg',
  ),
  OnboardingInfo(
    title: 'Track & Meet',
    description:
        'By using Google\'s Maps API, we provide live tracking that is seamless and secure.',
    imagePath: 'assets/images/onboarding/navigation.svg',
  ),
];
