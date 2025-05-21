import 'package:flutter/material.dart';

// Пример виджета ContactBox
class ContactBox extends StatelessWidget {
  final IconData icon;
  final Color color;

  const ContactBox({super.key, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }
}

// Твой основной экран профиля доктора
class DoctorProfilePage extends StatefulWidget {
  const DoctorProfilePage({ super.key });

  @override
  _DoctorProfilePageState createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Doctor's Profile", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),),
      ),
      body: getBody(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.blue, // пример цвета
          onPressed: () {
            // Логика кнопки
          },
          label: const Text("Request For Appointment"),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  getBody(){
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Patient time 8:00am - 5:00pm", style: TextStyle(fontSize: 13, color: Colors.green)),
          const SizedBox(height: 25, ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Dr. Terry Aminoff", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  SizedBox(height: 5, ),
                  Text("Dentist Specialist", style: TextStyle(color: Colors.grey, fontSize: 14),),
                ],
              ),
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'), // пример изображения
              )
            ],
          ),
          const SizedBox(height: 25, ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, size: 18, color: Colors.orangeAccent,),
              const Icon(Icons.star, size: 18, color: Colors.orangeAccent,),
              const Icon(Icons.star, size: 18, color: Colors.orangeAccent,),
              const Icon(Icons.star, size: 18, color: Colors.orangeAccent,),
              Icon(Icons.star, size: 18, color: Colors.grey.shade300,),
            ],
          ),
          const SizedBox(height: 5, ),
          const Text("4.0 Out of 5.0", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 3, ),
          const Text("340 Patients review", style: TextStyle(color: Colors.grey, fontSize: 12),),
          const SizedBox(height: 25, ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ContactBox(icon: Icons.videocam_rounded, color: Colors.blue,),
              ContactBox(icon: Icons.call_end, color: Colors.green,),
              ContactBox(icon: Icons.chat_rounded, color: Colors.purple,),
            ],
          ),
          const SizedBox(height: 25, ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InfoBox(value: "500+", info: "Successful Patients", icon: Icons.groups_rounded, color: Colors.green,),
              InfoBox(value: "10 Years", info: "Experience", icon: Icons.medical_services_rounded, color: Colors.purple,),
            ],
          ),
          const SizedBox(height: 15, ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
             InfoBox(value: "28+", info: "Successful OT", icon: Icons.bloodtype_rounded, color: Colors.blue,),
             InfoBox(value: "8+", info: "Certificates Achieved", icon: Icons.card_membership_rounded, color: Colors.orange,),
            ],
          ),
        ],
      ),
    );
  }
}

// Пример виджета для DoctorInfoBox (заменитель твоего DoctorInfoBox)
class InfoBox extends StatelessWidget {
  final String value;
  final String info;
  final IconData icon;
  final Color color;

  const InfoBox({super.key, required this.value, required this.info, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: 150,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: color),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
          const SizedBox(height: 5),
          Text(info, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: DoctorProfilePage(),
  ));
}
