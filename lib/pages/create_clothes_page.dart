import 'package:flutter/material.dart';
import '../models/clothes_model.dart';
import '../services/clothes_service.dart';

class CreateClothesPage extends StatefulWidget {
  const CreateClothesPage({Key? key}) : super(key: key);

  @override
  State<CreateClothesPage> createState() => _CreateClothesPageState();
}

class _CreateClothesPageState extends State<CreateClothesPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _soldController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _yearReleasedController = TextEditingController();
  final TextEditingController _materialController = TextEditingController();

  String? _errorMessage;

  Future<void> _createClothes() async {
    setState(() => _errorMessage = null);

    if (_formKey.currentState!.validate()) {
      try {
        final clothes = Clothes(
          name: _nameController.text,
          price: int.parse(_priceController.text),
          category: _categoryController.text,
          brand: _brandController.text,
          sold: int.parse(_soldController.text),
          rating: double.parse(_ratingController.text),
          stock: int.parse(_stockController.text),
          yearReleased: int.parse(_yearReleasedController.text),
          material: _materialController.text,
        );

        await ClothesService.createClothes(clothes);
        if (mounted) Navigator.pop(context);
      } catch (e) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    }
  }

  String? _validateInt(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Field cannot be empty 😠';
    }
    if (int.tryParse(value) == null) {
      return 'Must be a valid number';
    }
    return null;
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Field cannot be empty 😠';
    }
    return null;
  }

  String? _validateRating(String? value) {
    if (value == null || value.trim().isEmpty) return 'Field cannot be empty 😠';
    final rating = double.tryParse(value);
    if (rating == null || rating < 0 || rating > 5) {
      return 'Rating must be between 0 and 5';
    }
    return null;
  }

  String? _validateYear(String? value) {
    if (value == null || value.isEmpty) return 'Field cannot be empty 😠';
    final year = int.tryParse(value);
    if (year == null || year < 2018 || year > 2025) {
      return 'Release year must be between 2018 and 2025';
    }
    return null;
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF3E350E)),
      filled: true,
      fillColor: Color(0xFFEAE9E7),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFDAAD29), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2DD6C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3E350E),
        foregroundColor: Colors.white,
        title: const Text('Create Clothes'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 10),
              TextFormField(controller: _nameController, decoration: _buildInputDecoration('Name'), validator: _validateRequired),
              const SizedBox(height: 14),
              TextFormField(controller: _priceController, decoration: _buildInputDecoration('Price'), keyboardType: TextInputType.number, validator: _validateInt),
              const SizedBox(height: 14),
              TextFormField(controller: _categoryController, decoration: _buildInputDecoration('Category'), validator: _validateRequired),
              const SizedBox(height: 14),
              TextFormField(controller: _brandController, decoration: _buildInputDecoration('Brand'), validator: _validateRequired),
              const SizedBox(height: 14),
              TextFormField(controller: _soldController, decoration: _buildInputDecoration('Sold'), keyboardType: TextInputType.number, validator: _validateInt),
              const SizedBox(height: 14),
              TextFormField(controller: _ratingController, decoration: _buildInputDecoration('Rating'), keyboardType: TextInputType.number, validator: _validateRating),
              const SizedBox(height: 14),
              TextFormField(controller: _stockController, decoration: _buildInputDecoration('Stock'), keyboardType: TextInputType.number, validator: _validateInt),
              const SizedBox(height: 14),
              TextFormField(controller: _yearReleasedController, decoration: _buildInputDecoration('Year Released'), keyboardType: TextInputType.number, validator: _validateYear),
              const SizedBox(height: 14),
              TextFormField(controller: _materialController, decoration: _buildInputDecoration('Material'), validator: _validateRequired),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _createClothes,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF794515),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}