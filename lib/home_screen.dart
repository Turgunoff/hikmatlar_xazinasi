import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'about_screen.dart';
import 'category_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

  Future<List<_Category>> _loadCategories() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/quotes.json',
    );
    final Map<String, dynamic> data = json.decode(jsonString);
    final List categories = data['categories'];
    return List<_Category>.generate(categories.length, (i) {
      final title = categories[i]['title'] as String;
      final iconName = categories[i]['icon'] as String?;
      final icon = getIconData(iconName);
      return _Category(title, icon);
    });
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Hikmatlar Xazinasi',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset('assets/image/bac_image.png', fit: BoxFit.cover),
          ),
          // Blur for the whole background
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(color: Colors.black.withOpacity(0.15)),
            ),
          ),
          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0x66a18cd1),
                    Color(0x66fbc2eb),
                    Color(0x66fad0c4),
                  ],
                ),
              ),
            ),
          ),
          FutureBuilder<List<_Category>>(
            future: _loadCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Xatolik yuz berdi'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Maʼlumot topilmadi'));
              }
              final categories = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final gradient =
                        categoryGradients[category.name] ??
                        [Colors.deepPurple, Colors.purpleAccent];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CategoryDetailScreen(category: category.name),
                          ),
                        );
                      },
                      child: Container(
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return LinearGradient(
                                  colors: gradient,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(bounds);
                              },
                              child: Icon(
                                category.icon,
                                size: 48,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return LinearGradient(
                                  colors: gradient,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(bounds);
                              },
                              child: Text(
                                category.name,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Category {
  final String name;
  final IconData icon;
  const _Category(this.name, this.icon);
}
