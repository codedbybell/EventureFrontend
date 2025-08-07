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
        // AppBar'ın sol tarafına bir widget eklemek için 'leading' kullanılır.
        leading: IconButton(
          onPressed: () {
            // Butona tıklandığında bir önceki sayfaya döner.
            Navigator.pop(context);
          },
          // İstediğiniz ikon ve rengi burada tanımlıyoruz.
          icon: Icon(
            Icons.arrow_back_ios,
            color: theme.colorScheme.onBackground, // Temanın rengini kullanır.
          ),
        ),
        title: const Text('All Categories'),
        elevation: 1,
        // AppBar'ın başlığını ortalamak için (isteğe bağlı)
        centerTitle: true,
        // Flutter, 'leading' eklendiğinde otomatik olarak bir geri butonu alanı bırakır.
        // Başlığın bu alanı hesaba katmasını istemiyorsak bunu false yapabiliriz.
        // Ancak genellikle true kalması daha iyi bir görünüm sağlar.
        primary: true,
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
