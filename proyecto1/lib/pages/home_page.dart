import 'package:flutter/material.dart';
import 'reservation_form_page.dart';
import 'my_reservations_page.dart';
import 'package:proyecto1/services/api_service.dart';

const Color primaryBlue = Color(0xFF0A2342);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false, // Quita la flecha de retroceso
        backgroundColor: primaryBlue,
        elevation: 0,
        title: const Text(
          "I&C",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          // Botón Mis Reservas
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyReservationsPage(),
                ),
              );
            },
            icon: const Icon(Icons.receipt_long, color: Colors.white),
            tooltip: "Mis Reservas",
          ),
          // Botón Perfil
          IconButton(
            onPressed: () => _showProfile(context),
            icon: const Icon(Icons.account_circle, color: Colors.white),
            tooltip: "Mi Perfil",
          ),
        ],
      ),
      body: const Body(),
    );
  }

  void _showProfile(BuildContext context) async {
    final apiService = ApiService(); // Instancia provisional
    final personId = ApiService.currentPersonId;

    if (personId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No has iniciado sesión.")));
      return;
    }

    // Mostrar indicador de carga
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => const Center(child: CircularProgressIndicator()),
    );

    final personData = await apiService.getPerson(personId);

    // Cerrar indicador
    if (context.mounted) Navigator.pop(context);

    if (personData != null && context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Mi Perfil"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoRow(
                "Nombre:",
                "${personData['firstName'] ?? ''} ${personData['firstLastName'] ?? ''}",
              ),
              const SizedBox(height: 8),
              _infoRow(
                "Documento:",
                "${personData['documentTypeName'] ?? ''} ${personData['documentNumber'] ?? ''}",
              ),
              const SizedBox(height: 8),
              _infoRow("Teléfono:", "${personData['phoneNumber'] ?? ''}"),
              // Add more fields if available
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar diálogo
              },
              child: const Text("Cerrar"),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context); // Cerrar diálogo
                Navigator.pop(context); // Salir de HomePage (Logout visual)
              },
              icon: const Icon(Icons.logout, size: 16),
              label: const Text("Cerrar Sesión"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al cargar perfil.")),
        );
      }
    }
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label ", style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value)),
      ],
    );
  }
}
// Removed extra Body class definition from replacement to avoid duplicates if I'm not careful, but I am replacing the Widget build method context mostly.
// Wait, the previous tool call target was inside the `build` method?
// No, I entered StartLine: 27.
// I need to be careful. The original code had the `build` method ending at line 50.
// My replacement content includes the closing brace of `build`, then `_showProfile`, then `_infoRow`, then closing brace of `HomePage`.
// This looks correct.

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          HeaderBanner(),
          SizedBox(height: 20),
          SearchBarWidget(),
          SizedBox(height: 25),
          RecommendedTitle(),
          SizedBox(height: 15),
          RestaurantList(),
          SizedBox(height: 25),
          CategoriesTitle(), // Nuevo título
          SizedBox(height: 15),
          CategoriesList(), // Nueva lista horizontal
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ... HeaderBanner, SearchBarWidget ... (Same as before, not repeating for brevity if replace handles partial content, but replace handles chunks. I will assume replace entire Body or appending).
// Wait, I need to keep the other classes. I'll replace the Body and add new classes at the end.

class HeaderBanner extends StatelessWidget {
  const HeaderBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        "https://images.unsplash.com/photo-1552566626-52f8b828add9",
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const TextField(
        decoration: InputDecoration(
          icon: Icon(Icons.search),
          hintText: "Buscar restaurantes...",
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class RecommendedTitle extends StatelessWidget {
  const RecommendedTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Recomendados para ti",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}

class CategoriesTitle extends StatelessWidget {
  const CategoriesTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Categorías",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {"name": "Rápida", "icon": Icons.fastfood, "color": Colors.orange},
      {
        "name": "Mexicana",
        "icon": Icons.local_pizza,
        "color": Colors.red,
      }, // Pizza icon as placeholder
      {"name": "Asiática", "icon": Icons.ramen_dining, "color": Colors.pink},
      {"name": "Gourmet", "icon": Icons.wine_bar, "color": Colors.purple},
    ];

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 15),
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Container(
            width: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (cat['color'] as Color).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    cat['icon'] as IconData,
                    color: cat['color'] as Color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cat['name'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class RestaurantList extends StatelessWidget {
  const RestaurantList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        RestaurantCard(
          name: "La Casa del Pollo",
          location: "Calle 123, Bogotá",
          image: "https://images.unsplash.com/photo-1540189549336-e6e99c3679fe",
        ),
        RestaurantCard(
          name: "Pizzería Napoli",
          location: "Cra 45 # 22",
          image: "https://images.unsplash.com/photo-1600891964599-f61ba0e24092",
        ),
        RestaurantCard(
          name: "Sushi Sakura",
          location: "Zona Rosa",
          image: "https://images.unsplash.com/photo-1553621042-f6e147245754",
        ),
      ],
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final String name;
  final String location;
  final String image;

  const RestaurantCard({
    super.key,
    required this.name,
    required this.location,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.network(
              image,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 100,
                width: 100,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, size: 40),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    location,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReservationFormPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text("Reservar"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
