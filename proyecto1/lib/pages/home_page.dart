import 'package:flutter/material.dart';
import 'reservation_form_page.dart';


const Color primaryBlue = Color(0xFF0A2342);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
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
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: const Body(),
    );
  }
}

//////////////////////////////////////////////////////
// ---------------- WIDGET PADRE --------------------
//////////////////////////////////////////////////////

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
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////
// ---------------- WIDGETS HIJOS -------------------
//////////////////////////////////////////////////////

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
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
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
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
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
                          horizontal: 18, vertical: 10),
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
