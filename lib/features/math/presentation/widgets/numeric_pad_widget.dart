import 'package:flutter/material.dart';

/// A simple 0-9 numeric pad with backspace and submit.
class NumericPadWidget extends StatefulWidget {
  const NumericPadWidget({required this.onSubmitted, super.key});

  final ValueChanged<int> onSubmitted;

  @override
  State<NumericPadWidget> createState() => _NumericPadWidgetState();
}

class _NumericPadWidgetState extends State<NumericPadWidget> {
  String _input = '';

  void _addDigit(int digit) {
    if (_input.length >= 5) return; // Limit input
    setState(() {
      _input += digit.toString();
    });
  }

  void _backspace() {
    if (_input.isEmpty) return;
    setState(() {
      _input = _input.substring(0, _input.length - 1);
    });
  }

  void _submit() {
    if (_input.isEmpty) return;
    final value = int.tryParse(_input);
    if (value != null) {
      widget.onSubmitted(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _input.isEmpty ? '?' : _input,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),
        const SizedBox(height: 20),
        Table(
          children: [
            TableRow(
              children: [
                _buildButton(1),
                _buildButton(2),
                _buildButton(3),
              ],
            ),
            const TableRow(
              children: [
                SizedBox(height: 8),
                SizedBox(height: 8),
                SizedBox(height: 8),
              ],
            ),
            TableRow(
              children: [
                _buildButton(4),
                _buildButton(5),
                _buildButton(6),
              ],
            ),
            const TableRow(
              children: [
                SizedBox(height: 8),
                SizedBox(height: 8),
                SizedBox(height: 8),
              ],
            ),
            TableRow(
              children: [
                _buildButton(7),
                _buildButton(8),
                _buildButton(9),
              ],
            ),
            const TableRow(
              children: [
                SizedBox(height: 8),
                SizedBox(height: 8),
                SizedBox(height: 8),
              ],
            ),
            TableRow(
              children: [
                _buildActionButton(Icons.backspace, _backspace),
                _buildButton(0),
                _buildActionButton(Icons.check, _submit, color: Colors.green),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButton(int digit) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: () => _addDigit(digit),
          child: Text('$digit', style: const TextStyle(fontSize: 20)),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    VoidCallback onPressed, {
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: EdgeInsets.zero,
          ),
          child: Icon(
            icon,
            color: color != null ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
