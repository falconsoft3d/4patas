import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/pet.dart';
import '../services/pet_service.dart';

class EditPetScreen extends StatefulWidget {
  final String petId;
  
  const EditPetScreen({super.key, required this.petId});

  @override
  State<EditPetScreen> createState() => _EditPetScreenState();
}

class _EditPetScreenState extends State<EditPetScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _breedController;
  late TextEditingController _weightController;
  
  String _selectedType = 'Perro';
  String _selectedGender = 'Macho';
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  File? _selectedImage;
  String? _uploadedImageUrl;
  Pet? _pet;

  final List<Map<String, dynamic>> _petTypes = [
    {'name': 'Perro', 'icon': Icons.pets},
    {'name': 'Gato', 'icon': Icons.cruelty_free},
    {'name': 'Hamster', 'icon': Icons.pest_control_rodent},
    {'name': 'Otro', 'icon': Icons.pets},
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _breedController = TextEditingController();
    _weightController = TextEditingController();
  }

  void _initializeWithPet(Pet pet) {
    if (_pet != null) return; // Already initialized
    
    _pet = pet;
    _nameController.text = pet.name;
    _breedController.text = pet.breed;
    _weightController.text = pet.weight.toString();
    _selectedType = pet.type;
    _selectedGender = pet.gender;
    _selectedDate = pet.birthDate;
    _uploadedImageUrl = pet.photoUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _weightController.dispose();
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
    if (!_formKey.currentState!.validate() || _pet == null) return;
    
    setState(() => _isLoading = true);
    
    try {
      final petService = Provider.of<PetService>(context, listen: false);
      
      final updatedPet = _pet!.copyWith(
        name: _nameController.text.trim(),
        type: _selectedType,
        breed: _breedController.text.trim(),
        birthDate: _selectedDate,
        weight: double.tryParse(_weightController.text) ?? _pet!.weight,
        gender: _selectedGender,
        photoUrl: _uploadedImageUrl, // Local path
      );
      
      final success = await petService.updatePet(updatedPet);
      
      if (success && mounted) {
        context.pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Mascota actualizada exitosamente!')),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar mascota')),
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
    final petService = Provider.of<PetService>(context, listen: false);
    
    return FutureBuilder<Pet?>(
      future: petService.getPetById(widget.petId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Editar Mascota'),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        
        final pet = snapshot.data;
        if (pet == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
            ),
            body: Center(
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
            ),
          );
        }
        
        // Initialize form with pet data
        _initializeWithPet(pet);
        
        return _buildForm(theme);
      },
    );
  }

  Widget _buildForm(ThemeData theme) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text('Editar Mascota'),
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
                                  : (_getImageProvider(_uploadedImageUrl) != null
                                      ? DecorationImage(
                                          image: _getImageProvider(_uploadedImageUrl)!,
                                          fit: BoxFit.cover,
                                        )
                                      : null),
                            ),
                            child: (_selectedImage == null && _uploadedImageUrl == null)
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
                      'Toca para cambiar foto',
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
                'Nombre',
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
                'Tipo de Animal',
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
                        backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
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
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa la raza';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Weight Input
              Text(
                'Peso (kg)',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Ej. 10.5',
                  suffixText: 'kg',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa el peso';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Ingresa un número válido';
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
                      backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
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
                      backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
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
                    Text('Guardar Cambios'),
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
