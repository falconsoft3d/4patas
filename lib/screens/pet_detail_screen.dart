import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../models/pet.dart';
import '../models/vaccine.dart';
import '../services/pet_service.dart';
import '../services/vaccine_service.dart';

class PetDetailScreen extends StatefulWidget {
  final String petId;
  
  const PetDetailScreen({super.key, required this.petId});

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  ImageProvider? _getImageProvider(String? photoUrl) {
    if (photoUrl == null) return null;
    
    // Check if it's a local file path
    if (photoUrl.startsWith('/') || photoUrl.startsWith('file://')) {
      final file = File(photoUrl);
      if (file.existsSync()) {
        return FileImage(file);
      }
    }
    
    // Otherwise treat as network URL
    try {
      return NetworkImage(photoUrl);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final petService = Provider.of<PetService>(context, listen: false);
    final vaccineService = Provider.of<VaccineService>(context, listen: false);
    
    return Scaffold(
      body: FutureBuilder<Pet?>(
        future: petService.getPetById(widget.petId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final pet = snapshot.data;
          if (pet == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 80),
                  const SizedBox(height: 16),
                  const Text('Mascota no encontrada'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Volver'),
                  ),
                ],
              ),
            );
          }
          
          return CustomScrollView(
            slivers: [
              // Hero Image Header
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                leading: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      context.push('/edit-pet/${pet.id}');
                    },
                    icon: const Icon(Icons.edit),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      _getImageProvider(pet.photoUrl) != null
                          ? Image(
                              image: _getImageProvider(pet.photoUrl)!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: theme.primaryColor.withValues(alpha: 0.2),
                                  child: const Icon(Icons.pets, size: 100),
                                );
                              },
                            )
                          : Container(
                              color: theme.primaryColor.withValues(alpha: 0.2),
                              child: const Icon(Icons.pets, size: 100),
                            ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.6),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.6),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Content
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -16),
                  child: Column(
                    children: [
                      // Pet Info Card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: theme.cardTheme.color,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              pet.name,
                              style: theme.textTheme.displayMedium,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  pet.breed.toUpperCase(),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 8),
                                  height: 4,
                                  width: 4,
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Text(
                                  pet.type.toUpperCase(),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            const Divider(),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _InfoColumn(
                                  label: 'EDAD',
                                  value: '${pet.ageInYears} Años',
                                ),
                                _InfoColumn(
                                  label: 'PESO',
                                  value: '${pet.weight.toStringAsFixed(1)}kg',
                                ),
                                _InfoColumn(
                                  label: 'SEXO',
                                  value: pet.gender,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Quick Actions
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _ActionButton(
                              icon: Icons.edit_note,
                              label: 'Detalles',
                              onTap: () {},
                            ),
                            _ActionButton(
                              icon: Icons.vaccines,
                              label: 'Vacunar',
                              onTap: () {
                                context.push('/vaccines/${pet.id}');
                              },
                            ),
                            _ActionButton(
                              icon: Icons.share,
                              label: 'Compartir',
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Tabs
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          labelColor: theme.primaryColor,
                          unselectedLabelColor: Colors.grey.shade600,
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                          tabs: const [
                            Tab(text: 'Próximas'),
                            Tab(text: 'Historial'),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Vaccines List
                      StreamBuilder<List<Vaccine>>(
                        stream: vaccineService.getPetVaccines(pet.id),
                        builder: (context, vaccineSnapshot) {
                          if (vaccineSnapshot.connectionState == ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.all(48),
                              child: CircularProgressIndicator(),
                            );
                          }
                          
                          final vaccines = vaccineSnapshot.data ?? [];
                          final upcomingVaccines = vaccines
                              .where((v) => v.status != VaccineStatus.completed)
                              .toList();
                          
                          if (upcomingVaccines.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(48),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    size: 80,
                                    color: Colors.grey.shade300,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No hay vacunas pendientes',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '¡${pet.name} está al día!',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Próximas Vacunas',
                                  style: theme.textTheme.headlineMedium,
                                ),
                                const SizedBox(height: 16),
                                ...upcomingVaccines.map((vaccine) => 
                                  _VaccineCard(vaccine: vaccine)
                                ),
                                const SizedBox(height: 100),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      
      // Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/add-vaccine/${widget.petId}');
        },
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add_circle),
        label: const Text(
          'Registrar Vacuna',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;
  
  const _InfoColumn({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: Colors.grey.shade600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.headlineMedium,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _VaccineCard extends StatelessWidget {
  final Vaccine vaccine;
  
  const _VaccineCard({required this.vaccine});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd MMM yyyy', 'es');
    final isOverdue = vaccine.isOverdue;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOverdue 
              ? Colors.red.shade200 
              : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: isOverdue 
                  ? Colors.red.shade100 
                  : theme.primaryColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isOverdue ? Icons.warning : Icons.vaccines,
              color: isOverdue ? Colors.red.shade700 : Colors.green.shade700,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vaccine.name,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  isOverdue 
                      ? 'Vence: ${dateFormat.format(vaccine.scheduledDate)}'
                      : dateFormat.format(vaccine.scheduledDate),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isOverdue ? Colors.red : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(
              color: isOverdue ? Colors.red : theme.primaryColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
