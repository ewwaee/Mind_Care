import 'package:badges/badges.dart' as badges;
import 'package:doctor_app_fixed/data/json.dart';
import 'package:doctor_app_fixed/pages/doctor_profile_page.dart';
import 'package:doctor_app_fixed/theme/colors.dart';
import 'package:doctor_app_fixed/widgets/avatar_image.dart';
import 'package:doctor_app_fixed/widgets/doctor_box.dart';
import 'package:doctor_app_fixed/widgets/textbox.dart';
import 'package:flutter/material.dart';

class DoctorPage extends StatefulWidget {
  const DoctorPage({super.key});

  @override
  State<DoctorPage> createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Doctors",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.info,
              color: Colors.grey,
            ),
          )
        ],
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Expanded(child: CustomTextBox()),
                SizedBox(width: 5),
                Icon(Icons.filter_list_rounded, color: primary, size: 35),
              ],
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  chatsData.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: badges.Badge(
                      badgeStyle: const badges.BadgeStyle(
                        badgeColor: Colors.green,
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      position:
                          badges.BadgePosition.topEnd(top: -3, end: 0),
                      badgeContent: const Text(''),
                      child: AvatarImage(
                        chatsData[index]["image"].toString(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            getDoctorList()
          ],
        ),
      ),
    );
  }

  Widget getDoctorList() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: doctors.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (BuildContext context, int index) {
        return DoctorBox(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const DoctorProfilePage()),
            );
          },
          index: index,
          doctor: doctors[index],
        );
      },
    );
  }
}
