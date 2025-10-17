import 'package:flutter/material.dart';
import 'package:frontend/features/home/data/home_repository.dart';
import 'package:frontend/core/services/local_storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _repo = HomeRepository();
  final _localStorage = LocalStorageService();

  Map<String, dynamic>? _organization;
  List<Map<String, dynamic>> _members = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOrganizationData();
  }

  Future<void> _loadOrganizationData() async {
    try {
      final orgId = await _localStorage.getOrgId();
      if (orgId == null) {
        setState(() => _error = 'No se encontró ninguna organización local.');
        return;
      }

      final orgData = await _repo.getOrganization(orgId);
      final members = await _repo.getOrgMembers(orgId);

      setState(() {
        _organization = orgData;
        _members = members;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    await _localStorage.clearOrgId();
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Principal'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : _organization == null
                  ? const Center(
                      child: Text('No se encontró información de la organización.'),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nombre de la organización
                          Text(
                            _organization!['name'] ?? 'Sin nombre',
                            style: theme.textTheme.headlineMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Código de invitación: ${_organization!['inviteCode']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          const Divider(),

                          Text(
                            'Miembros:',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),

                          Expanded(
                            child: ListView.separated(
                              itemCount: _members.length,
                              separatorBuilder: (_, __) => const Divider(),
                              itemBuilder: (context, index) {
                                final member = _members[index];
                                return ListTile(
                                  leading: const Icon(Icons.person),
                                  title: Text(member['email'] ?? 'Sin correo'),
                                  subtitle:
                                      Text('Rol: ${member['role'] ?? 'desconocido'}'),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
