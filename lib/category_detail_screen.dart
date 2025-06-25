import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String category;
  const CategoryDetailScreen({super.key, required this.category});

  IconData getIconData(String? iconName) {
    switch (iconName) {
      case 'lightbulb_outline':
        return Icons.lightbulb_outline;
      case 'format_quote':
        return Icons.format_quote;
      case 'trending_up':
        return Icons.trending_up;
      case 'auto_awesome':
        return Icons.auto_awesome;
      case 'favorite_border':
        return Icons.favorite_border;
      case 'people_outline':
        return Icons.people_outline;
      case 'school':
        return Icons.school;
      case 'hourglass_bottom':
        return Icons.hourglass_bottom;
      case 'self_improvement':
        return Icons.self_improvement;
      case 'family_restroom':
        return Icons.family_restroom;
      case 'flag':
        return Icons.flag;
      default:
        return Icons.category;
    }
  }

  Future<_CategoryDetail> _loadCategoryDetail() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/quotes.json',
    );
    final Map<String, dynamic> data = json.decode(jsonString);
    final List categories = data['categories'];
    final cat = categories.firstWhere(
      (c) => (c['title'] as String).toLowerCase() == category.toLowerCase(),
      orElse: () => null,
    );
    if (cat == null) {
      return _CategoryDetail(category, null, ['Maʼlumot topilmadi']);
    }
    final List quotes = cat['quotes'] as List;
    final iconName = cat['icon'] as String?;
    return _CategoryDetail(
      category,
      getIconData(iconName),
      quotes.map((q) => q.toString()).toList(),
    );
  }

  // Gradient color map for each category
  static const Map<String, List<Color>> categoryGradients = {
    'Donolik so‘zlari': [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
    'Maqollar': [Color(0xFFf7971e), Color(0xFFffd200)],
    'Motivatsion': [Color(0xFF43cea2), Color(0xFF185a9d)],
    'Hayot haqida': [Color(0xFFff9966), Color(0xFFff5e62)],
    'Muhabbat': [Color(0xFFf857a6), Color(0xFFFF5858)],
    'Do‘stlik': [Color(0xFF36D1C4), Color(0xFF1E5799)],
    'Ilm va Bilim': [Color(0xFF2193b0), Color(0xFF6dd5ed)],
    'Sabrlilik': [Color(0xFFee9ca7), Color(0xFFffdde1)],
    'Diniy hikmatlar': [Color(0xFFB06AB3), Color(0xFF4568DC)],
    'Ota-ona haqida': [Color(0xFFf7971e), Color(0xFFffd200)],
    'Vatanparvarlik': [Color(0xFF56ab2f), Color(0xFFa8e063)],
    'Yolg‘izlik va Tushuncha': [Color(0xFF232526), Color(0xFF414345)],
  };

  @override
  Widget build(BuildContext context) {
    final gradient =
        categoryGradients[category] ?? [Color(0xFF8E2DE2), Color(0xFF4A00E0)];
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
          ),
        ),
        title: Row(
          children: [
            FutureBuilder<_CategoryDetail>(
              future: _loadCategoryDetail(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.icon != null) {
                  return Row(
                    children: [
                      Icon(snapshot.data!.icon, size: 24, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        snapshot.data!.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          shadows: [
                            Shadow(color: Colors.black26, blurRadius: 4),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return Text(
                  category,
                  style: const TextStyle(color: Colors.white),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
        ),
        child: FutureBuilder<_CategoryDetail>(
          future: _loadCategoryDetail(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Xatolik yuz berdi'));
            } else if (!snapshot.hasData || snapshot.data!.quotes.isEmpty) {
              return const Center(child: Text('Maʼlumot topilmadi'));
            }
            final quotes = snapshot.data!.quotes;
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 16,
                top: 16,
              ),
              child: ListView.builder(
                itemCount: quotes.length,
                itemBuilder: (context, index) {
                  final quote = quotes[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            quote,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              shadows: [
                                Shadow(color: Colors.white24, blurRadius: 1),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: const Icon(Icons.copy, color: Colors.black54),
                            onPressed: () async {
                              await Clipboard.setData(
                                ClipboardData(text: quote),
                              );
                              Fluttertoast.showToast(
                                msg: 'Nusxa olindi!',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CategoryDetail {
  final String title;
  final IconData? icon;
  final List<String> quotes;
  _CategoryDetail(this.title, this.icon, this.quotes);
}
