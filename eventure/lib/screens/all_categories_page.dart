// lib/screens/all_categories_page.dart (YENİ DOSYA)

import 'package:flutter/material.dart';
import 'package:eventure/screens/home_page.dart';
import 'package:eventure/screens/category_events_page.dart';

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

      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Yan yana 2 kategori
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 3 / 2, // Kartların en-boy oranı
        ),
        itemCount: eventCategories.length,
        itemBuilder: (context, index) {
          final category = eventCategories[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CategoryEventsPage(categoryName: category['label']!),
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
                  title: Text(category['label']!, textAlign: TextAlign.center),
                ),
                child: Image.network(
                  category['image']!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.hide_image,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
