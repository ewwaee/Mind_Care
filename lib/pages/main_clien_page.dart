import 'package:flutter/material.dart';
import 'psychologists_page.dart';
import 'blogpage.dart';
import 'SessionDetailsPage.dart';


class MainClientPage extends StatefulWidget {
  @override
  _MainClientPageState createState() => _MainClientPageState();
}

class _MainClientPageState extends State<MainClientPage> {
  Map<String, dynamic>? upcomingSession;

  void setUpcomingSession(Map<String, dynamic> session) {
    setState(() {
      upcomingSession = session;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Основные цвета из второго фото
    final backgroundColor = Color(0xFFF3F6F9);
    final cardColor1 = Color(0xFF9FB6C6);
    final cardColor2 = Color(0xFF7592A7);
    final textColor1 = Color(0xFF1B1B1B);
    final textColor2 = Colors.white;
    final accentColor = Color(0xFF2F4179);

    return Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Приветствие и аватарка
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: cardColor1,
                      child: Icon(Icons.person, color: textColor2, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Good morning, Charlie!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor1,
                        fontFamily: 'InclusiveSans', // Используем шрифт InclusiveSans
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 36),

                // Предстоящая сессия
                if (upcomingSession != null)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SessionDetailsPage(session: upcomingSession!),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardColor1,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: cardColor1.withOpacity(0.5),
                            blurRadius: 10,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(18),
                      margin: EdgeInsets.only(bottom: 30),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: cardColor2,
                            child: Icon(Icons.person, color: textColor2, size: 36),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  upcomingSession!['psychologist']['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: textColor1,
                                    fontFamily: 'InclusiveSans', // Используем шрифт InclusiveSans
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  upcomingSession!['psychologist']['description'],
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: cardColor2,
                                    fontFamily: 'InclusiveSans', // Используем шрифт InclusiveSans
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: cardColor2,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                            child: Column(
                              children: [
                                Text(
                                  upcomingSession!['date'],
                                  style: TextStyle(
                                    color: textColor2,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    fontFamily: 'InclusiveSans', // Используем шрифт InclusiveSans
                                  ),
                                ),
                                Text(
                                  upcomingSession!['day'] ?? '',
                                  style: TextStyle(color: textColor2, fontSize: 14, fontFamily: 'InclusiveSans'), // Используем шрифт InclusiveSans
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      color: cardColor1,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: cardColor1.withOpacity(0.5),
                          blurRadius: 10,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(18),
                    margin: EdgeInsets.only(bottom: 30),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: cardColor2,
                          child: Icon(Icons.person, color: textColor2, size: 36),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          'No Upcoming Session',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: cardColor2,
                            fontFamily: 'InclusiveSans', // Используем шрифт InclusiveSans
                          ),
                        ),
                      ],
                    ),
                  ),

                // Карточка поиска психолога
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: cardColor1,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: cardColor1.withOpacity(0.7),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Find best therapist for you and schedule a session!',
                        style: TextStyle(fontSize: 17, color: textColor1, fontFamily: 'InclusiveSans'), // Используем шрифт InclusiveSans
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          shadowColor: accentColor.withOpacity(0.6),
                          elevation: 6,
                        ),
                        onPressed: () async {
                          final session = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PsychologistsPage()),
                          );
                          if (session != null) {
                            setUpcomingSession(session);
                          }
                        },
                        child: const Text(
                          "Let's do it!",
                          style: TextStyle(fontSize: 17, color: Colors.white, fontFamily: 'InclusiveSans'), // Используем шрифт InclusiveSans
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Карточка статей
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: cardColor2,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: cardColor2.withOpacity(0.7),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Read articles based on your interests and needs!",
                        style: TextStyle(fontSize: 17, color: textColor2, fontFamily: 'InclusiveSans'), // Используем шрифт InclusiveSans
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          shadowColor: accentColor.withOpacity(0.6),
                          elevation: 6,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BlogPage()),
                          );
                        },
                        child: const Text(
                          "Let's see!",
                          style: TextStyle(fontSize: 17, color: Colors.white, fontFamily: 'InclusiveSans'), // Используем шрифт InclusiveSans
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );

  }
}
