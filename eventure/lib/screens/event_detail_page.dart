import 'package:flutter/material.dart';

class EventDetailPage extends StatelessWidget {
  final Map<String, dynamic> event;

  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    const Color customBackgroundColor = Color.fromARGB(255, 255, 255, 255);

    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: customBackgroundColor,
      appBar: AppBar(
        // 1. AppBar'ın kendi rengini şeffaf yapıyoruz ki alttaki gradyan görünsün.
        backgroundColor: Colors.transparent,

        // 2. AppBar'ın altındaki varsayılan gölgeyi kaldırıyoruz.
        elevation: 0,

        // 3. flexibleSpace kullanarak arka plana gradyanlı bir Container yerleştiriyoruz.
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFF6B9D),
                Color(0xFF4ECDC4),
              ], // İstediğiniz gradyan
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),

        // --- Orijinal AppBar içeriğiniz ---
        // Geri butonu. Rengini gradyan üzerinde iyi görünmesi için beyaz yapıyoruz.
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white, // Değişiklik: Renk beyaz yapıldı
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),

        // Başlık. Rengini yine beyaz yapıyoruz.
        title: Text(
          event['title'] ?? 'Event Detail',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white, // Değişiklik: Renk beyaz yapıldı
          ),
        ),

        // Başlığı ortalama özelliği aynı kalıyor.
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  event['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Tags
              if (event['tags'] != null)
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: (event['tags'] as List<dynamic>)
                      .map(
                        (tag) => Chip(
                          label: Text(tag.toString()),
                          backgroundColor: theme.colorScheme.surface,
                          labelStyle: theme.textTheme.bodyMedium,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                        ),
                      )
                      .toList(),
                ),
              const SizedBox(height: 16),
              // Organizer Info
              _buildInfoRow(
                context,
                icon: Icons.info_outline,
                text: event['organizer'] ?? 'Not specified',
                color: theme.colorScheme.background,
              ),
              const SizedBox(height: 16),
              // Title and Subtitle
              Text(
                event['title'],
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                event['subtitle'],
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 24),
              // Details Box
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  // We'll use the same consistent color here
                  color: customBackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      // Make the shadow more subtle
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildInfoRow(
                      context,
                      icon: Icons.location_on_outlined,
                      text: event['location'] ?? 'Location not specified',
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      context,
                      icon: Icons.calendar_today_outlined,
                      text: '${event['date'] ?? ''}  ${event['time'] ?? ''}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Apply Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // onPressed fonksiyonunu koruyoruz
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    // Butonun kendisini şeffaf yapıyoruz
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets
                        .zero, // İç boşluğu sıfırlıyoruz ki Ink tam otursun
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        25,
                      ), // Hedef stildeki yuvarlaklık
                    ),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      // Hedef stildeki gradyanı uyguluyoruz
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF6B9D), Color(0xFF4ECDC4)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(
                        25,
                      ), // Dekorasyonun da yuvarlak olması lazım
                    ),
                    child: Container(
                      width: double
                          .infinity, // Butonun tam genişlikte olmasını sağlar
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ), // Yüksekliği ayarlamak için padding (orijinal butona benzer)
                      child: Row(
                        // İkon ve yazıyı ortalamak için
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Orijinal butondaki ikon
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors
                                .white, // Gradyan üzerinde görünmesi için rengi beyaz yapıyoruz
                          ),
                          const SizedBox(
                            width: 10,
                          ), // İkon ile yazı arasına boşluk
                          // Orijinal butondaki yazı
                          const Text(
                            "Apply",
                            // Hedef stildeki yazı stiline benzetiyoruz
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String text,
    Color? color,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: color ?? theme.colorScheme.onBackground),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: color ?? theme.colorScheme.onBackground,
            ),
          ),
        ),
      ],
    );
  }
}
