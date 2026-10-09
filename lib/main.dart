import 'package:flutter/material.dart';
import 'reservation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '🍽️ จองโต๊ะอาหาร',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Kanit',
      ),
      home: const TableReservationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TableReservationScreen extends StatefulWidget {
  const TableReservationScreen({super.key});

  @override
  State<TableReservationScreen> createState() => _TableReservationScreenState();
}

class _TableReservationScreenState extends State<TableReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  int _people = 2;
  String _tableType = 'โต๊ะทั่วไป';
  final List<Reservation> _reservations = [];

  final List<String> _tableTypes = [
    'โต๊ะทั่วไป',
    'โต๊ะริมหน้าต่าง',
    'ห้องส่วนตัว',
    'โต๊ะใหญ่ (กลุ่ม)',
  ];

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) {
      _dateCtrl.text = '${picked.day}/${picked.month}/${picked.year}';
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 18, minute: 0),
    );
    if (picked != null) {
      _timeCtrl.text = '${picked.hour}:${picked.minute.toString().padLeft(2,'0')}';
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _reservations.add(Reservation(
          name: _nameCtrl.text,
          phone: _phoneCtrl.text,
          date: _dateCtrl.text,
          time: _timeCtrl.text,
          people: _people,
          tableType: _tableType,
          note: _noteCtrl.text.isEmpty ? '-' : _noteCtrl.text,
        ));
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ จองโต๊ะสำเร็จ! ขอบคุณครับ')),
      );

      _formKey.currentState!.reset();
      _dateCtrl.clear();
      _timeCtrl.clear();
      _noteCtrl.clear();
      _people = 2;
      _tableType = 'โต๊ะทั่วไป';
    }
  }

  Color _getTableColor(String type) {
    switch (type) {
      case 'โต๊ะริมหน้าต่าง': return Colors.lightBlue.shade50;
      case 'ห้องส่วนตัว': return Colors.purple.shade50;
      case 'โต๊ะใหญ่ (กลุ่ม)': return Colors.green.shade50;
      default: return Colors.orange.shade50;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('🍽️ จองโต๊ะอาหาร'),
          backgroundColor: Colors.orange,
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: '📝 จองโต๊ะ'),
              Tab(text: '📋 รายการจอง'),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            // ✅ หน้า 1: ฟอร์มจองโต๊ะ
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('กรอกข้อมูลเพื่อจองโต๊ะ', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(
                        labelText: '👤 ชื่อ-นามสกุล',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (v) => v!.isEmpty ? 'กรุณากรอกชื่อ' : null,
                    ),
                    const SizedBox(height: 15),

                    TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: '📱 เบอร์โทรศัพท์',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      validator: (v) => v!.length < 10 ? 'กรุณากรอกเบอร์ให้ครบ' : null,
                    ),
                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _dateCtrl,
                            readOnly: true,
                            onTap: _pickDate,
                            decoration: const InputDecoration(
                              labelText: '📅 วันที่',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            validator: (v) => v!.isEmpty ? 'กรุณาเลือกวันที่' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _timeCtrl,
                            readOnly: true,
                            onTap: _pickTime,
                            decoration: const InputDecoration(
                              labelText: '🕐 เวลา',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.access_time),
                            ),
                            validator: (v) => v!.isEmpty ? 'กรุณาเลือกเวลา' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    Row(
                      children: [
                        const Text('👥 จำนวนคน: ', style: TextStyle(fontSize: 16)),
                        IconButton(
                          onPressed: () => setState(() => _people = _people > 1 ? _people - 1 : 1),
                          icon: const Icon(Icons.remove_circle),
                          color: Colors.orange,
                        ),
                        Text('$_people คน', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        IconButton(
                          onPressed: () => setState(() => _people++),
                          icon: const Icon(Icons.add_circle),
                          color: Colors.orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    DropdownButtonFormField(
                      value: _tableType,
                      decoration: const InputDecoration(
                        labelText: '🪑 ประเภทโต๊ะ',
                        border: OutlineInputBorder(),
                      ),
                      items: _tableTypes.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (v) => setState(() => _tableType = v!),
                    ),
                    const SizedBox(height: 15),

                    TextFormField(
                      controller: _noteCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: '📝 หมายเหตุ (ต้องการอะไรเป็นพิเศษ)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('✅ ยืนยันการจอง', style: TextStyle(fontSize: 17)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ✅ หน้า 2: รายการจอง
            _reservations.isEmpty
                ? const Center(child: Text('ยังไม่มีรายการจอง 📭', style: TextStyle(fontSize: 16)))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _reservations.length,
                    itemBuilder: (context, i) {
                      final r = _reservations[i];
                      return Card(
                        color: _getTableColor(r.tableType),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('👤 ${r.name}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text('📱 ${r.phone}'),
                              Text('📅 ${r.date}  🕐 ${r.time}'),
                              Text('👥 จำนวน ${r.people} คน'),
                              Text('🪑 ${r.tableType}'),
                              Text('📝 หมายเหตุ: ${r.note}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}