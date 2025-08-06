import 'package:flutter/material.dart';
import 'package:eventure/theme/theme.dart' as AppTheme;

class AnaEkran extends StatelessWidget {
  const AnaEkran({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.salmonPalette,
        title: const Text('Ana Ekran'),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: Theme.of(context).cardColor,
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Popüler Etkinlik',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Kampüs Etkinlik Platformuna Hoş Geldiniz!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                ),
                onPressed: () {},
                child: const Text('Tüm Etkinlikleri Gör'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () {},
                child: const Text('Kategorilere Göz At'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.tealPalette,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
