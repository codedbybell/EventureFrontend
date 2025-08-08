import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventure/localization/localization_service.dart'; // Bu yolu kendi projenize göre düzenlediğinizden emin olun

class LanguageToggleSwitch extends StatefulWidget {
  const LanguageToggleSwitch({Key? key}) : super(key: key);

  @override
  _LanguageToggleSwitchState createState() => _LanguageToggleSwitchState();
}

class _LanguageToggleSwitchState extends State<LanguageToggleSwitch> {
  late bool isTurkishSelected;

  @override
  void initState() {
    super.initState();
    isTurkishSelected = (Get.locale?.languageCode ?? 'tr') == 'tr';
  }

  void _onToggle(bool isTurkish) {
    setState(() {
      isTurkishSelected = isTurkish;
    });
    final newCode = isTurkish ? 'tr' : 'en';
    LocalizationService.changeLocale(newCode);
  }

  @override
  Widget build(BuildContext context) {
    const double width = 110.0; // AppBar'a sığması için biraz küçülttük
    const double height = 40.0; // AppBar'a sığması için biraz küçülttük
    const double padding = 3.0;

    return GestureDetector(
      onTap: () => _onToggle(!isTurkishSelected),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(height / 2),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedAlign(
              alignment: isTurkishSelected
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: Container(
                width: width / 2,
                height: height,
                padding: const EdgeInsets.all(padding),
                child: Container(
                  decoration: BoxDecoration(
                    color: isTurkishSelected
                        ? Colors.red.shade400
                        : Colors.blue.shade400,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                _buildLanguageText('EN', !isTurkishSelected),
                _buildLanguageText('TR', isTurkishSelected),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageText(String text, bool isSelected) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: FontWeight.bold,
            fontSize: 12, // Boyutu biraz küçülttük
          ),
        ),
      ),
    );
  }
}
