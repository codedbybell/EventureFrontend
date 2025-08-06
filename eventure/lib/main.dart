import 'package:eventure/thema/thema.dart' as AppTheme;
import 'package:flutter/material.dart';
// Oluşturduğumuz theme.dart dosyasını 'AppTheme' adıyla import ediyoruz.

void main() {
  runApp(const KampusEtkinlikApp());
}

class KampusEtkinlikApp extends StatelessWidget {
  const KampusEtkinlikApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Uygulama başlığı (genellikle uygulama değiştiricide görünür)
      title: 'Kampüs Etkinlik Platformu',

      // Hata ayıklama (debug) etiketini kaldırır
      debugShowCheckedModeBanner: false,

      // Açık tema olarak theme.dart dosyasındaki lightTheme'i kullan
      theme: AppTheme.lightTheme,

      // Koyu tema olarak theme.dart dosyasındaki darkTheme'i kullan
      darkTheme: AppTheme.darkTheme,

      // Cihazın ayarlarına göre temayı otomatik seçer (Açık/Koyu)
      // Dilerseniz ThemeMode.light veya ThemeMode.dark olarak sabitleyebilirsiniz.
      themeMode: ThemeMode.system,

      // Uygulamanın başlangıç ekranı
      home: const AnaEkran(),
    );
  }
}

class AnaEkran extends StatelessWidget {
  const AnaEkran({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Scaffold, temel Material Design görsel düzenini uygular.
    return Scaffold(
      // AppBar, ekranın üst kısmındaki çubuktur.
      appBar: AppBar(
        backgroundColor: AppTheme.paletSomon,
        // AppBar başlığı. Tema tarafından otomatik olarak renklendirilir.
        title: const Text('Ana Ekran'),
        actions: [
          // AppBar'a ikon ekleme
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Filtreleme işlemleri burada yapılacak
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Profil ekranına yönlendirme burada yapılacak
            },
          ),
        ],
      ),

      // Ekranın ana içeriği
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Kart widget'ı. Temadan cardColor özelliğini alır.
              Card(
                color: Theme.of(
                  context,
                ).cardColor, // Temadan açık sarı rengi alacak
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Popüler Etkinlik',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Metin widget'ı. Temanın textTheme'inden stilini alır.
              Text(
                'Kampüs Etkinlik Platformuna Hoş Geldiniz!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 30),

              // Yükseltilmiş buton. Temanın elevatedButtonTheme'inden stilini alır.
              ElevatedButton(
                onPressed: () {},
                child: const Text('Tüm Etkinlikleri Gör'),
              ),
              const SizedBox(height: 10),

              // İkincil renk (Cam Göbeği) ile bir buton örneği
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.secondary, // Temadan ikincil rengi alır
                ),
                onPressed: () {},
                child: const Text('Kategorilere Göz At'),
              ),
            ],
          ),
        ),
      ),

      // Floating Action Button (FAB). Temanın floatingActionButtonTheme'inden stilini alır.
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.paletKoyuMercan,
        onPressed: () {
          // Yeni etkinlik ekleme ekranına yönlendirme
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
