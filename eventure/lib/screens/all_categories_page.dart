import 'package:flutter/material.dart';
import 'package:eventure/screens/category_events_page.dart';
import '../models/category_model.dart';
import '../services/event_services.dart';

class AllCategoriesPage extends StatelessWidget {
  const AllCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Categories'), elevation: 1),
      body: FutureBuilder<List<Category>>(
        // EventService'i kullanıyorsanız, buranın doğru olduğundan emin olun.
        // Eğer ayrı bir CategoryService varsa, bu kullanım doğrudur.
        future: EventService().fetchCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No categories found."));
          }

          final categories = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 3 / 2,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          // <<< DEĞİŞİKLİK 1: 'label' yerine 'name' kullanıldı.
                          CategoryEventsPage(categoryName: category.name),
                    ),
                  );
                },
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: GridTile(
                    footer: GridTileBar(
                      backgroundColor: Colors.black45,
                      // <<< DEĞİŞİKLİK 2: 'label' yerine 'name' kullanıldı.
                      title: Text(category.name, textAlign: TextAlign.center),
                    ),
                    child: Image.network(
                      category.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.hide_image,
                        size: 40,
                        color: Colors.grey,
                      ),
                      // Ağdan yüklenirken bir yükleme göstergesi eklemek iyi bir pratiktir.
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
