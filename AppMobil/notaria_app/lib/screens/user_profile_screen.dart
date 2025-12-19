import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user_profile.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _apiService = ApiService();
  UserProfile? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final profile = await _apiService.getProfile();
      if (mounted) {
        setState(() {
          _profile = profile;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading profile: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _profile == null
              ? const Center(child: Text('Error al cargar el perfil'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Profile Photo
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: const Color(0xFF4A9ECC),
                        child: _profile!.photoUrl != null
                            ? ClipOval(
                                child: Image.network(
                                  _profile!.photoUrl!,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(Icons.person, size: 60, color: Colors.white),
                      ),
                      const SizedBox(height: 24),

                      // Información Básica
                      _SectionCard(
                        title: 'Información Básica',
                        children: [
                          _InfoRow(
                            icon: Icons.person_outline,
                            label: 'Nombre completo',
                            value: _profile!.fullName,
                          ),
                          _InfoRow(
                            icon: Icons.email_outlined,
                            label: 'Correo electrónico',
                            value: _profile!.email,
                          ),
                          _InfoRow(
                            icon: Icons.phone_outlined,
                            label: 'Teléfono',
                            value: _profile!.phone,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Dirección
                      _SectionCard(
                        title: 'Dirección',
                        children: [
                          _InfoRow(
                            icon: Icons.home_outlined,
                            label: 'Calle y número',
                            value: _profile!.address.street,
                          ),
                          _InfoRow(
                            icon: Icons.location_city_outlined,
                            label: 'Colonia',
                            value: _profile!.address.neighborhood,
                          ),
                          _InfoRow(
                            icon: Icons.map_outlined,
                            label: 'Ciudad, Estado',
                            value: '${_profile!.address.city}, ${_profile!.address.state}',
                          ),
                          _InfoRow(
                            icon: Icons.pin_drop_outlined,
                            label: 'Código postal',
                            value: _profile!.address.postalCode,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Edit Profile Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement edit profile
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Editar Perfil'),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: const Color(0xFF4A9ECC)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
