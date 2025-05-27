import 'package:flutter/material.dart';
import '../models/clothes_model.dart';
import '../services/clothes_service.dart';
import 'detail_clothes_page.dart';
import 'create_clothes_page.dart';
import 'edit_clothes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Clothes>> futureClothes;

  @override
  void initState() {
    super.initState();
    futureClothes = ClothesService.getAllClothes();
  }

  void refreshData() {
    setState(() {
      futureClothes = ClothesService.getAllClothes();
    });
  }

  final Color primaryColor = const Color(0xFF3E350E);
  final Color accentColor = const Color(0xFFDAAD29);
  final Color backgroundColor = const Color(0xFFF5F5F5);
  final Color cardColor = Colors.white;
  final Color secondaryText = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Clothes Catalog', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Clothes>>(
        future: futureClothes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final clothesList = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: clothesList.length,
              itemBuilder: (context, index) {
                final item = clothesList[index];
                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailClothesPage(id: item.id!),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    color: cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Center(
                              child: Icon(Icons.checkroom, size: 48, color: accentColor),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.name??'-',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: primaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp ${item.price}',
                            style: TextStyle(color: accentColor, fontSize: 14),
                          ),
                          Text(
                            item.category??'-',
                            style: TextStyle(color: secondaryText, fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                color: Colors.blueGrey,
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditClothesPage(id: item.id!),

                                    ),
                                  );
                                  if (result == true) refreshData();
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, size: 20),
                                color: Colors.redAccent,
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Hapus Pakaian'),
                                      content: const Text('Yakin ingin menghapus pakaian ini?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          child: const Text('Hapus'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await ClothesService.deleteClothes(item.id!);
                                    refreshData();
                                  }
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Terjadi error: ${snapshot.error.toString()}"));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: accentColor,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateClothesPage(),
            ),
          );
          if (result == true) refreshData();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}