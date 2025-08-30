import 'package:flutter/material.dart';
import '../design_tokens.dart';

class SearchFilters extends StatelessWidget {
  final TextEditingController controller;
  final List<String> filters;
  final String selectedFilter;
  final void Function(String) onFilterSelected;
  final void Function(String) onSearchChanged;

  const SearchFilters({
    Key? key,
    required this.controller,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.onSearchChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          onChanged: onSearchChanged,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, color: AppColors.mutedText),
            hintText: 'Search shops, city, category',
            hintStyle: AppTypography.body.copyWith(color: AppColors.mutedText),
            filled: true,
            fillColor: AppColors.cardBackground,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide.none,
            ),
          ),
          style: AppTypography.body,
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filters.map((filter) {
              final bool selected = filter == selectedFilter;
              return Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        filter,
                        style: AppTypography.body.copyWith(
                          fontWeight: selected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      if (selected)
                        const Padding(
                          padding: EdgeInsets.only(left: 4.0),
                          child: Icon(
                            Icons.check,
                            color: AppColors.marketPrimary,
                            size: 18,
                          ),
                        ),
                    ],
                  ),
                  selected: selected,
                  onSelected: (_) => onFilterSelected(filter),
                  selectedColor: const Color(0xFFE6F9EA),
                  backgroundColor: AppColors.neutralLight,
                  labelStyle: AppTypography.body,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.button),
                  ),
                  side: BorderSide.none,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 0,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
