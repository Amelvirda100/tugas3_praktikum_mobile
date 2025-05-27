import 'package:flutter/material.dart';
import '../models/clothes_model.dart';
import '../services/clothes_service.dart';
import 'edit_clothes_page.dart';

class DetailClothesPage extends StatefulWidget {
  final int id;
  final VoidCallback? onUpdate;

  const DetailClothesPage({
    super.key,
    required this.id,
    this.onUpdate,
  });

  @override
  State<DetailClothesPage> createState() => _DetailClothesPageState();
}

class _DetailClothesPageState extends State<DetailClothesPage> {
  late Future<Clothes> futureClothes;

  final Color primaryColor = const Color(0xFF3E350E);
  final Color accentColor = const Color(0xFFDAAD29);
  final Color backgroundColor = const Color(0xFFEAE9E7);
  final Color borderColor = const Color(0xFF794515);
  final Color secondaryColor = const Color(0xFF79792E);
  final Color highlightColor = const Color(0xFFF2DD6C);

  @override
  void initState() {
    super.initState();
    futureClothes = ClothesService.getClothesById(widget.id);
  }

  Future<void> _deleteClothes() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Pakaian'),
        content: const Text('Yakin ingin menghapus pakaian ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Hapus', style: TextStyle(color: Colors.red.shade700)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ClothesService.deleteClothes(widget.id);
        widget.onUpdate?.call();
        if (context.mounted) Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menghapus: $e')));
      }
    }
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.w600, color: primaryColor)),
          Expanded(child: Text(value, style: TextStyle(color: secondaryColor))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Detail Pakaian'),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: FutureBuilder<Clothes>(
        future: futureClothes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final item = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name??'-',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: borderColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildDetailItem('Harga', 'Rp ${item.price}'),
                          _buildDetailItem('Kategori', item.category??'-'),
                          _buildDetailItem('Brand', item.brand??'-'),
                          _buildDetailItem('Terjual', '${item.sold}'),
                          _buildDetailItem('Rating', '${item.rating}'),
                          _buildDetailItem('Stok', '${item.stock}'),
                          _buildDetailItem('Tahun Rilis', '${item.yearReleased}'),
                          _buildDetailItem('Material', item.material??'-'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
