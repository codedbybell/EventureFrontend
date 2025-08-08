import 'package:flutter/material.dart';
import 'package:eventure/screens/category_events_page.dart';
import '../models/category_model.dart';
import '../services/event_services.dart';

class AllCategoriesPage extends StatelessWidget {
  const AllCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Tema verilerine erişmek için bir değişken tanımlıyoruz.
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        // 1. AppBar'ın arkaplanını şeffaf yapıyoruz ki alttaki gradyan görünsün.
        backgroundColor: Colors.transparent,

        // 2. AppBar'ın altındaki gölgeyi kaldırıyoruz.
        elevation: 0,

        // 3. 'flexibleSpace' ile arka plana istediğimiz gradyan rengini ekliyoruz.
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFF6B9D), // Pembe tonu
                Color(0xFF4ECDC4), // Turkuaz tonu
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),

        // --- Orijinal AppBar içeriğiniz gradyan stile uyarlandı ---

        // 4. Geri butonunun rengini, gradyan üzerinde daha iyi görünmesi için beyaz yapıyoruz.
        leading: IconButton(
          onPressed: () {
            // Butona tıklandığında bir önceki sayfaya döner.
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white, // Değişiklik: Renk beyaz yapıldı.
          ),
        ),

        // 5. Başlığın rengini de okunabilirlik için beyaz yapıyoruz.
        title: const Text(
          'All Categories',
          style: TextStyle(
            color: Colors.white, // Değişiklik: Renk beyaz yapıldı.
          ),
        ),
        centerTitle: true, // Başlığı ortalar.
      ),
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
