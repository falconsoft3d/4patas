import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/vaccine.dart';
import '../services/vaccine_service.dart';

class AddVaccineScreen extends StatefulWidget {
  final String petId;
  
  const AddVaccineScreen({super.key, required this.petId});

  @override
  State<AddVaccineScreen> createState() => _AddVaccineScreenState();
}

class _AddVaccineScreenState extends State<AddVaccineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _vetNameController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  VaccineStatus _selectedStatus = VaccineStatus.pending;
  DateTime? _completedDate;
  bool _isLoading = false;

  final List<String> _commonVaccines = [
    'Rabia',
    'Parvovirus',
    'Moquillo',
    'Hepatitis',
    'Leptospirosis',
    'Bordetella',
    'Coronavirus',
    'Triple Felina',
    'Leucemia Felina',
    'Otra',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _vetNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveVaccine() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      final vaccineService = Provider.of<VaccineService>(context, listen: false);
      
      final vaccine = Vaccine(
        id: const Uuid().v4(),
        petId: widget.petId,
        name: _nameController.text.trim(),
        scheduledDate: _selectedDate,
        status: _selectedStatus,
        veterinarianName: _vetNameController.text.trim().isEmpty 
            ? null 
            : _vetNameController.text.trim(),
        notes: _notesController.text.trim().isEmpty 
            ? null 
            : _notesController.text.trim(),
        completedDate: _completedDate,
        createdAt: DateTime.now(),
      );
      
      final result = await vaccineService.addVaccine(vaccine);
      
      if (result != null && mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Vacuna registrada exitosamente!')),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al registrar vacuna')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text('Registrar Vacuna'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vaccine Icon
              Center(
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.vaccines,
                    size: 40,
                    color: theme.primaryColor,
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Vaccine Name
              Text(
                'Nombre de la Vacuna',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _commonVaccines.map((vaccine) {
                  return ChoiceChip(
                    label: Text(vaccine),
                    selected: _nameController.text == vaccine,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _nameController.text = vaccine);
                      }
                    },
                    selectedColor: theme.primaryColor,
                    backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'O escribe el nombre',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa el nombre de la vacuna';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Status
              Text(
                'Estado',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Pendiente'),
                      selected: _selectedStatus == VaccineStatus.pending,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedStatus = VaccineStatus.pending;
                            _completedDate = null;
                          });
                        }
                      },
                      selectedColor: Colors.orange.shade200,
                      backgroundColor: Colors.orange.shade50,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Completada'),
                      selected: _selectedStatus == VaccineStatus.completed,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedStatus = VaccineStatus.completed;
                            _completedDate = DateTime.now();
                          });
                        }
                      },
                      selectedColor: Colors.green.shade200,
                      backgroundColor: Colors.green.shade50,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Scheduled Date
              Text(
                _selectedStatus == VaccineStatus.completed 
                    ? 'Fecha de Aplicación' 
                    : 'Fecha Programada',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                  );
                  if (date != null) {
                    setState(() {
                      _selectedDate = date;
                      if (_selectedStatus == VaccineStatus.completed) {
                        _completedDate = date;
                      }
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: theme.inputDecorationTheme.fillColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: theme.textTheme.bodyLarge,
                      ),
                      const Icon(Icons.calendar_month),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Veterinarian Name
              Text(
                'Veterinario (Opcional)',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _vetNameController,
                decoration: const InputDecoration(
                  hintText: 'Nombre del veterinario',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Notes
              Text(
                'Notas (Opcional)',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  hintText: 'Notas adicionales',
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 3,
              ),
              
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      
      // Floating Action Button
      floatingActionButton: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _saveVaccine,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black,
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Registrar Vacuna'),
                    SizedBox(width: 8),
                    Icon(Icons.check, size: 20),
                  ],
                ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
