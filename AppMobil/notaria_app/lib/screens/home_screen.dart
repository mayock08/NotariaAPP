import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../models/expediente.dart';
import 'login_screen.dart';
import 'user_profile_screen.dart';
import 'process_tracking_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  final _apiService = ApiService();
  List<Expediente> _expedientes = [];
  bool _isLoading = true;
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final storage = const FlutterSecureStorage();
      _userName = await storage.read(key: 'user_name') ?? 'Usuario';
      
      final expedientes = await _apiService.getMyExpedientes();
      
      if (mounted) {
        setState(() {
          _expedientes = expedientes;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notaría Pública 9'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1A2B4A), Color(0xFF2E4A6F)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Color(0xFF1A2B4A)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Mi Perfil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UserProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Mis Documentos'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notificaciones'),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bienvenido, $_userName',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 24),

                    // Quick Access Cards
                    Row(
                      children: [
                        Expanded(
                          child: _QuickAccessCard(
                            icon: Icons.folder_outlined,
                            title: 'Expedientes',
                            count: _expedientes.length,
                            color: const Color(0xFF4A9ECC),
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _QuickAccessCard(
                            icon: Icons.description_outlined,
                            title: 'Documentos',
                            count: _expedientes.fold(
                              0,
                              (sum, exp) => sum + exp.documents.length,
                            ),
                            color: const Color(0xFF4CAF50),
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Expedientes List
                    Text(
                      'Mis Expedientes',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),

                    if (_expedientes.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text('No hay expedientes disponibles'),
                        ),
                      )
                    else
                      ..._expedientes.map((expediente) => _ExpedienteCard(
                            expediente: expediente,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProcessTrackingScreen(
                                    expediente: expediente,
                                  ),
                                ),
                              );
                            },
                          )),
                  ],
                ),
              ),
            ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.title,
    required this.count,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 12),
              Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpedienteCard extends StatelessWidget {
  final Expediente expediente;
  final VoidCallback onTap;

  const _ExpedienteCard({
    required this.expediente,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final completedStages = expediente.processStages.where((s) => s.isCompleted).length;
    final totalStages = expediente.processStages.length;
    final progress = totalStages > 0 ? completedStages / totalStages : 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    expediente.expedienteNumber,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A9ECC).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      expediente.currentStatus,
                      style: const TextStyle(
                        color: Color(0xFF4A9ECC),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[800],
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
              ),
              const SizedBox(height: 8),
              Text(
                '$completedStages de $totalStages etapas completadas',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total a pagar', style: TextStyle(fontSize: 12)),
                      Text(
                        '\$${expediente.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Abonado', style: TextStyle(fontSize: 12)),
                      Text(
                        '\$${expediente.paidAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
