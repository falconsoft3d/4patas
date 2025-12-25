import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/pet.dart';
import '../services/pet_service.dart';
import '../services/auth_service.dart';

class CreatePetScreen extends StatefulWidget {
  const CreatePetScreen({super.key});

  @override
  State<CreatePetScreen> createState() => _CreatePetScreenState();
}

class _CreatePetScreenState extends State<CreatePetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  
  String _selectedType = 'Perro';
  String _selectedGender = 'Macho';
  DateTime _selectedDate = DateTime.now();
  final double _weight = 10.0;
  bool _isLoading = false;
  File? _selectedImage;
  String? _uploadedImageUrl;

  final List<Map<String, dynamic>> _petTypes = [
    {'name': 'Perro', 'icon': Icons.pets},
    {'name': 'Gato', 'icon': Icons.cruelty_free},
    {'name': 'Hamster', 'icon': Icons.pest_control_rodent},
    {'name': 'Otro', 'icon': Icons.pets},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          // Store the local path instead of uploading
          _uploadedImageUrl = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al seleccionar imagen: $e')),
        );
      }
    }
  }

  Future<void> _savePet() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      final petService = Provider.of<PetService>(context, listen: false);
      final authService = Provider.of<AuthService>(context, listen: false);
      
      final pet = Pet(
        id: const Uuid().v4(),
        name: _nameController.text.trim(),
        type: _selectedType,
        breed: _breedController.text.trim(),
        birthDate: _selectedDate,
        weight: _weight,
        gender: _selectedGender,
        photoUrl: _uploadedImageUrl, // Local path
        ownerId: authService.userId ?? 'guest',
        createdAt: DateTime.now(),
      );
      
      final result = await petService.addPet(pet);
      
      if (result != null && mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Mascota añadida exitosamente!')),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al añadir mascota')),
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
        title: const Text('Nueva Mascota'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Photo
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        children: [
                          Container(
                            height: 128,
                            width: 128,
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                              image: _selectedImage != null
                                  ? DecorationImage(
                                      image: FileImage(_selectedImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _selectedImage == null
                                ? Icon(
                                    Icons.pets,
                                    size: 48,
                                    color: theme.primaryColor,
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.primaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: theme.scaffoldBackgroundColor,
                                  width: 4,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _selectedImage == null ? 'Sube una foto' : 'Foto seleccionada',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Toca para editar',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Name Input
              Text(
                '¿Cómo se llama?',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Nombre de tu mascota',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Animal Type Selection
              Text(
                '¿Qué animal es?',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _petTypes.map((type) {
                    final isSelected = _selectedType == type['name'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ChoiceChip(
                        label: Row(
                          children: [
                            Icon(
                              type['icon'] as IconData,
                              size: 20,
                              color: isSelected ? Colors.black : null,
                            ),
                            const SizedBox(width: 8),
                            Text(type['name'] as String),
                          ],
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedType = type['name'] as String);
                          }
                        },
                        selectedColor: theme.primaryColor,
                        backgroundColor: theme.primaryColor.withOpacity(0.1),
                        labelStyle: TextStyle(
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? Colors.black : null,
                        ),
                        side: isSelected
                            ? BorderSide(color: theme.primaryColor, width: 2)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Breed Input
              Text(
                'Raza',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _breedController,
                decoration: const InputDecoration(
                  hintText: 'Ej. Labrador, Siamés',
                  suffixIcon: Icon(Icons.search),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa la raza';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Gender Selection
              Text(
                'Sexo',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Macho'),
                      selected: _selectedGender == 'Macho',
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedGender = 'Macho');
                        }
                      },
                      selectedColor: theme.primaryColor,
                      backgroundColor: theme.primaryColor.withOpacity(0.1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Hembra'),
                      selected: _selectedGender == 'Hembra',
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedGender = 'Hembra');
                        }
                      },
                      selectedColor: theme.primaryColor,
                      backgroundColor: theme.primaryColor.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Birth Date
              Text(
                'Cumpleaños',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() => _selectedDate = date);
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
          onPressed: _isLoading ? null : _savePet,
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
                    Text('Crear Perfil'),
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
