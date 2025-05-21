import 'package:flutter/material.dart';



class ConfirmSessionPage extends StatefulWidget {
  final Map<String, dynamic> psychologist;
  ConfirmSessionPage({required this.psychologist});

  @override
  _ConfirmSessionPageState createState() => _ConfirmSessionPageState();
}

class _ConfirmSessionPageState extends State<ConfirmSessionPage> {
  String? selectedTime;
  DateTime? selectedDate;
  final TextEditingController concernController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  List<String> times = ['10:00', '11:00', '12:00', '14:00', '16:00', '18:00'];

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  String get formattedDate {
    if (selectedDate == null) return "Choose Date";
    return "${selectedDate!.day.toString().padLeft(2, '0')} "
        "${_monthName(selectedDate!.month)} "
        "${selectedDate!.year}";
  }

  String _monthName(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }

  bool get isFormValid =>
      selectedTime != null &&
          selectedDate != null &&
          nameController.text.isNotEmpty &&
          phoneController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm your session', style: TextStyle(fontFamily: 'InclusiveSans')),
        leading: BackButton(),
        backgroundColor: Color(0xFF174754),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Session details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'InclusiveSans')),

            SizedBox(height: 8),

            Wrap(
              spacing: 8,
              children: times.map((time) {
                final isSelected = time == selectedTime;
                return ChoiceChip(
                  label: Text(time, style: TextStyle(fontFamily: 'InclusiveSans')),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      selectedTime = time;
                    });
                  },
                );
              }).toList(),
            ),

            SizedBox(height: 16),

            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formattedDate,
                      style: TextStyle(fontSize: 16, color: selectedDate == null ? Colors.grey : Colors.black, fontFamily: 'InclusiveSans'),
                    ),
                    Icon(Icons.calendar_today, color: Color(0xFF174754)),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(child: Icon(Icons.person)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.psychologist['name'], style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'InclusiveSans')),
                        Text(widget.psychologist['description'], style: TextStyle(fontFamily: 'InclusiveSans')),
                      ],
                    ),
                  ),
                  Text('${widget.psychologist['experience']} years', style: TextStyle(fontFamily: 'InclusiveSans')),
                ],
              ),
            ),

            SizedBox(height: 16),

            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Your Name",
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontFamily: 'InclusiveSans'),
            ),

            SizedBox(height: 16),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontFamily: 'InclusiveSans'),
            ),

            SizedBox(height: 16),

            TextField(
              controller: concernController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Feel free to share your emotion and thoughts here',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontFamily: 'InclusiveSans'),
            ),

            SizedBox(height: 8),

            Text('After confirmation you will get message with zoom link', style: TextStyle(fontFamily: 'InclusiveSans')),

            SizedBox(height: 16),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF174754),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: isFormValid
                  ? () {
                final session = {
                  'date': formattedDate,
                  'time': selectedTime,
                  'name': nameController.text,
                  'phone': phoneController.text,
                  'concern': concernController.text,
                  'psychologist': widget.psychologist,
                };
                Navigator.pop(context, session);
              }
                  : null,
              child: Text('Confirm session', style: TextStyle(fontSize: 16, fontFamily: 'InclusiveSans')),
            ),
          ],
        ),
      ),
    );
  }
}
