import 'package:dishedout/providers/auth_provider.dart';
import 'package:dishedout/services/user_service.dart';
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
  bool _isLoading = false;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    final user = ref
        .read(authNotifierProvider)
        .maybeWhen(data: (user) => user, orElse: () => null);

    _displayNameController = TextEditingController(text: user?.displayName);
    _emailController = TextEditingController(text: user?.email);
    _phoneController = TextEditingController(text: user?.phone);
  }

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
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person_rounded,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                      labelText: 'Display Name',
                    ),
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email_rounded,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                      labelText: 'Email',
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
            onPressed:
                _isLoading
                    ? null
                    : () async {
                      if (_formKey.currentState!.validate()) {
                        final user = ref
                            .read(authNotifierProvider)
                            .maybeWhen(
                              data: (user) => user,
                              orElse: () => null,
                            );

                        if (user == null) return;

                        setState(() => _isLoading = true); // Start loading

                        final updatedData = {
                          'displayName': _displayNameController!.text.trim(),
                          'email': _emailController!.text.trim(),
                          'phone': _phoneController!.text.trim(),
                        };

                        try {
                          await _userService.updateProfile(
                            user.uid,
                            updatedData,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Profile updated successfully'),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error updating profile: $e'),
                            ),
                          );
                        } finally {
                          setState(() => _isLoading = false);
                        }
                      }
                    },
            child:
                _isLoading
                    ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : const Text('Save Changes'),
          ),
        ),
      ),
    );
  }
}
