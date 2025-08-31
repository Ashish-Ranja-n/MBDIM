import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileInfoScreen extends StatefulWidget {
  final VoidCallback onNext;
  const ProfileInfoScreen({super.key, required this.onNext});

  @override
  State<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  int _age = 30;
  FixedExtentScrollController? _ageCtrl;

  @override
  void initState() {
    super.initState();
    _ageCtrl = FixedExtentScrollController(initialItem: _age - 18);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl?.dispose();
    super.dispose();
  }

  Future<void> _saveAndNext() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', _nameCtrl.text.trim());
    await prefs.setInt('profile_age', _age);
    // save dummy location for now
    await prefs.setString('profile_location', 'Bengaluru, India');
    // mark startup flow completed (we no longer collect experience)
    await prefs.setBool('flow_completed', true);
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final ages = List.generate(63, (i) => i + 18); // 18..80
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete profile', style: GoogleFonts.poppins()),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                Center(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          const CircleAvatar(
                            radius: 46,
                            backgroundColor: Color(0xFF12171C),
                            child: Icon(
                              Icons.person,
                              size: 44,
                              color: Colors.white,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: InkWell(
                              onTap: () {
                                // Image picker intentionally omitted — implement with image_picker later.
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Add photo feature coming soon',
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.add_a_photo,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Profile photo (optional)',
                        style: GoogleFonts.poppins(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Name',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameCtrl,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Your full name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Enter your name'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Location',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.teal),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Bengaluru, India',
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Location detection coming soon',
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'Detect',
                                style: GoogleFonts.poppins(color: Colors.teal),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Age',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 100,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: ListWheelScrollView.useDelegate(
                            controller: _ageCtrl,
                            itemExtent: 48,
                            diameterRatio: 1.6,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (i) =>
                                setState(() => _age = ages[i]),
                            childDelegate: ListWheelChildBuilderDelegate(
                              builder: (context, index) {
                                if (index < 0 || index >= ages.length)
                                  return null;
                                final val = ages[index];
                                return RotatedBox(
                                  quarterTurns: 1,
                                  child: Center(
                                    child: Container(
                                      width: 64,
                                      height: 36,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: val == _age
                                            ? Colors.teal
                                            : Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '$val',
                                        style: GoogleFonts.poppins(
                                          color: val == _age
                                              ? Colors.white
                                              : Colors.black87,
                                          fontWeight: val == _age
                                              ? FontWeight.bold
                                              : FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              childCount: ages.length,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _saveAndNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Next',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
