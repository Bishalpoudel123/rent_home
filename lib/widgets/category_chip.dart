import 'package:flutter/material.dart';

class CategoryChip extends StatefulWidget {
  final String label;
  
  CategoryChip({required this.label});
  
  @override
  _CategoryChipState createState() => _CategoryChipState();
}

class _CategoryChipState extends State<CategoryChip> {
  bool _isSelected = false;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(widget.label),
        selected: _isSelected,
        onSelected: (selected) {
          setState(() {
            _isSelected = selected;
          });
        },
        backgroundColor: Colors.grey.shade200,
        selectedColor: Colors.blue.shade100,
        checkmarkColor: Colors.blue.shade700,
      ),
    );
  }
}