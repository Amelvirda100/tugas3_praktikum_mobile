import 'package:flutter/material.dart';
import 'package:tugas3_praktikum_mobile/models/clothes_model.dart';
import 'package:tugas3_praktikum_mobile/services/clothes_service.dart';

class EditClothesPage extends StatefulWidget {
  final int id;
  const EditClothesPage({super.key, required this.id});

  @override
  State<EditClothesPage> createState() => _EditClothesPageState();
}

class _EditClothesPageState extends State<EditClothesPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController category = TextEditingController();
  final TextEditingController brand = TextEditingController();
  final TextEditingController sold = TextEditingController();
  final TextEditingController rating = TextEditingController();
  final TextEditingController stock = TextEditingController();
  final TextEditingController year = TextEditingController();
  final TextEditingController material = TextEditingController();

  bool _isDataLoaded = false;

  final Color backgroundColor = const Color(0xFFEAE9E7);
  final Color primaryColor = const Color(0xFFDAAD29);
  final Color textColor = const Color(0xFF3E350E);
  final Color accentColor = const Color(0xFF794515);
  final Color buttonColor = const Color(0xFFF2DD6C);
  final Color inputBorderColor = const Color(0xFF79792E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Edit Pakaian"),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: FutureBuilder(
          future: ClothesService.getClothesById(widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              if (!_isDataLoaded) {
                _isDataLoaded = true;
                final Clothes data = snapshot.data!;
                name.text = data.name ?? '-';
                price.text = data.price.toString();
                category.text = data.category ?? '-';
                brand.text = data.brand ?? "";
                sold.text = data.sold.toString();
                rating.text = data.rating.toString();
                stock.text = data.stock.toString();
                year.text = data.yearReleased.toString();
                material.text = data.material ?? "";
              }
              return _formEdit();
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _formEdit() {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          _buildInput("Nama", name, validator: _validateRequired),
          _buildInput("Harga", price, isNumber: true, validator: _validateInt),
          _buildInput("Kategori", category, validator: _validateRequired),
          _buildInput("Brand", brand, validator: _validateRequired),
          _buildInput("Jumlah Terjual", sold, isNumber: true, validator: _validateInt),
          _buildInput("Rating", rating, isNumber: true, validator: _validateRating),
          _buildInput("Stok", stock, isNumber: true, validator: _validateInt),
          _buildInput("Tahun Rilis", year, isNumber: true, validator: _validateYear),
          _buildInput("Material", material, validator: _validateRequired),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _updateClothes,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: textColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Simpan Perubahan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller,
      {bool isNumber = false, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          isDense: true,
          labelText: label,
          labelStyle: TextStyle(
            color: textColor,
            overflow: TextOverflow.ellipsis,
            fontSize: 14,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: inputBorderColor, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: validator,
      ),
    );
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

  Future<void> _updateClothes() async {
    if (!_formKey.currentState!.validate()) {
      // Jika validasi gagal, jangan lanjut update
      return;
    }

    try {
      final clothes = Clothes(
        id: widget.id,
        name: name.text.trim(),
        price: int.parse(price.text),
        category: category.text.trim(),
        brand: brand.text.trim(),
        sold: int.parse(sold.text),
        rating: double.parse(rating.text),
        stock: int.parse(stock.text),
        yearReleased: int.parse(year.text),
        material: material.text.trim(),
      );

      await ClothesService.updateClothes(widget.id, clothes);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: accentColor,
            content: Text(
              "Berhasil mengupdate ${clothes.name}",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Gagal: $e", style: const TextStyle(color: Colors.white)),
        ),
      );
    }
  }
}
