import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'dart:typed_data';

class AdvancedForm extends StatefulWidget {
  const AdvancedForm({super.key});

  @override
  State<AdvancedForm> createState() => _AdvancedFormState();
}

class _AdvancedFormState extends State<AdvancedForm> {
  // Inisialisasi variabel tanggal
  DateTime _dueDate = DateTime.now();
  final currentDate = DateTime.now();
  Color _currentColor = Colors.orange;
  String? _dataFile; // Untuk menyimpan nama file
  Uint8List? _imageBytes; // Untuk menyimpan byte dari gambar

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final file = result.files.first;

      // Jika file adalah gambar, gunakan bytes
      if (file.extension == 'jpg' ||
          file.extension == 'png' ||
          file.extension == 'jpeg') {
        setState(() {
          _imageBytes = file.bytes; // Simpan bytes dari file
        });
      }

      // Simpan nama file untuk ditampilkan
      setState(() {
        _dataFile = file.name;
      });
    }
  }

  void _openFile(PlatformFile file) {
    OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Widget'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            buildDatePicker(context),
            const SizedBox(height: 20),
            buildColorPicker(context),
            const SizedBox(height: 20),
            buildFilePicker(context),
          ],
        ),
      ),
    );
  }

  // Method untuk Date Picker
  Widget buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Date'),
            TextButton(
              child: const Text('Select'),
              onPressed: () async {
                // Memperbaiki logika pemanggilan showDatePicker
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: currentDate,
                  firstDate: DateTime(1990),
                  lastDate: DateTime(currentDate.year + 5),
                );

                setState(() {
                  if (selectedDate != null) {
                    _dueDate = selectedDate;
                  }
                });
              },
            ),
          ],
        ),
        Text(DateFormat('dd MMMM yyyy').format(_dueDate))
      ],
    );
  }

  Widget buildColorPicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Color'),
        const SizedBox(height: 10),
        Container(
          height: 100,
          width: double.infinity,
          color: _currentColor,
        ),
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _currentColor,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Pick Your Color'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ColorPicker(
                              pickerColor: _currentColor,
                              onColorChanged: (color) {
                                setState(() {
                                  _currentColor = color;
                                });
                              }),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            return Navigator.of(context).pop();
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    );
                  });
            },
            child: const Text('Pick Color'),
          ),
        ),
      ],
    );
  }

  Widget buildFilePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pick File'),
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            onPressed: () {
              _pickFile();
            },
            child: const Text('Pick and Open File'),
          ), // ElevatedButton
        ), // Center
        if (_dataFile != null) Text('File Name: $_dataFile'),
        const SizedBox(height: 10),

        if (_imageBytes != null)
          Image.memory(
            _imageBytes!,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          )
      ],
    ); // Column
  }
}
