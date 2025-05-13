import 'package:dishedout/providers/auth_provider.dart';
import 'package:dishedout/shared/widgets/Avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController? _displayNameController;
  TextEditingController? _emailController;
  TextEditingController? _phoneController;

  @override
  void dispose() {
    _displayNameController?.dispose();
    _emailController?.dispose();
    _phoneController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: _formKey,
          child: authState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text("Error: $e", style: TextStyle(fontSize: 24)),
            data: (user) {
              return Column(
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Material(
                          color: Colors.transparent,
                          shape: const CircleBorder(),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () async {
                              await ref
                                  .read(authNotifierProvider.notifier)
                                  .changeProfilePic();
                            },
                            child: Avatar(
                              user: user,
                              radius: 100,
                              fontSize: 32,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _displayNameController,
                    initialValue: user?.displayName ?? '',
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person_rounded,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                      labelText: 'Display Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    initialValue: user?.email ?? '',
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email_rounded,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone_rounded,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () {},
            child: const Text('Save Changes'),
          ),
        ),
      ),
    );
  }
}
