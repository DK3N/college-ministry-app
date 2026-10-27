// flutter / supabase imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// page imports
import 'home_page.dart';

// state management with provider
import 'package:provider/provider.dart';
import '../state/user_state.dart';

// reusable components
import '../widgets/custom_back_button.dart';

// DATA ENUMS
enum SchoolEnum {
  fiu('fiu', 'Florida International University (FIU)'),
  um('um', 'University of Miami (UM)'),
  mdc('mdc', 'Miami-Dade College (MDC)'),
  other('other', 'Other');
  final String dbValue;
  final String uiLabel;
  const SchoolEnum(this.dbValue, this.uiLabel);
}

enum SexEnum {
  male('male', 'Male'),
  female('female', 'Female');
  final String dbValue;
  final String uiLabel;
  const SexEnum(this.dbValue, this.uiLabel);
}

// =============================================================================
// FORM PAGE WIDGET
// =============================================================================

class MemberFormPage extends StatefulWidget {
  const MemberFormPage({super.key});

  @override
  State<MemberFormPage> createState() => _MemberFormPageState();
}

class _MemberFormPageState extends State<MemberFormPage> {
  final _formKey = GlobalKey<FormState>();

  // if the user already exists, we want to preload their
  // existing data into the form fields
  bool _isFetchingData = true;

  // Member data
  String? _firstName;
  String? _lastName;
  SchoolEnum? _school;
  SexEnum? _sex;
  DateTime? _birthday;

  // Baptism data
  DateTime? _baptismDate;
  String? _baptismLocation;

  // Performed Baptism data
  List<int> _selectedBaptizerIds = [];
  List<Map<String, dynamic>> _allMembers = [];

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Triggers all onSaved callbacks to populate _formData!

      // Inherit the memberId from UserState provider
      final int? memberId = context.read<UserState>().memberId;

      if (memberId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Member ID not found. Please log in again.'), backgroundColor: Colors.red),
        );
        return;
      }

      final currentUserId = Supabase.instance.client.auth.currentUser?.id;

      // Data payloads -- we include every field since every field in the form is mandatory
      final memberData = {
        "member_id": memberId,
        "user_id": currentUserId,
        "first_name": _firstName,
        "last_name": _lastName,
        "school": _school?.dbValue,
        "sex": _sex?.dbValue,
        "birthdate": _birthday?.toIso8601String().split('T')[0],
      };
      
      final baptismData = {
        "baptized_member_id": memberId,
        "date": _baptismDate?.toIso8601String().split('T')[0],
        "location": _baptismLocation
      };
      
      final baptizerData = {
        "baptized_member_id": memberId,
        "performer_member_ids": _selectedBaptizerIds
      };

      try {
        // Send data payload to supabase table MEMBER using upsert()
        await Supabase.instance.client.from("MEMBER").upsert(memberData);

        // Send data payload to supabase table BAPTISM using upsert()
        await Supabase.instance.client.from("BAPTISM").upsert(baptismData);

        // Send data payload to supabase table PERFORMED_BAPTISM using upsert()
        await Supabase.instance.client.from("PERFORMED_BAPTISM").upsert(baptizerData);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile form submitted successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // navigate to HomePage
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving profile: $e'), backgroundColor: Colors.red));
        }
      }

    } else {
      // Form has invalid fields (e.g. Enneagram > 9)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the invalid inputs in red before submitting.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // call our async fetch method as soon as the page loads
    _fetchExistingData();
  }

  String? _cleanString(dynamic value) {
    if (value == null) return null;
    final str = value.toString().trim();
    if (str.isEmpty || str.toLowerCase() == 'null') return null;
    return str;
  }

  Future<void> _fetchExistingData() async {
    // get the memberId from our UserState provider
    final memberId = context.read<UserState>().memberId;
    // quick check to verify that memberId exists (which it should...)
    if (memberId == null) {
      setState(() => _isFetchingData = false);
      return;
    }

    try {
      // query the database for this user
      // maybeSingle() because a new user would not have data in the MEMBERS table yet!
      final memberResponse = await Supabase.instance.client.from("MEMBER").select().eq("member_id", memberId).maybeSingle();
      final baptismResponse = await Supabase.instance.client.from("BAPTISM").select().eq("baptized_member_id", memberId).maybeSingle();
      final baptizerResponse = await Supabase.instance.client.from("PERFORMED_BAPTISM").select().eq("baptized_member_id", memberId).maybeSingle();

      if (memberResponse != null) {
        _firstName = _cleanString(memberResponse['first_name']);
        _lastName = _cleanString(memberResponse['last_name']);
        if (memberResponse['school'] != null) {
          final dbSchool = _cleanString(memberResponse['school']);
          if (dbSchool != null) {
            _school = SchoolEnum.values.firstWhere(
              (enumItem) => enumItem.dbValue.toLowerCase() == dbSchool.toLowerCase(),
              orElse: () => SchoolEnum.other,
            );
          }
        }
        if (memberResponse['sex'] != null) {
          final dbSex = _cleanString(memberResponse['sex']);
          if (dbSex != null) {
            _sex = SexEnum.values.firstWhere(
              (enumItem) => enumItem.dbValue.toLowerCase() == dbSex.toLowerCase(),
              orElse: () => SexEnum.male,
            );
          }
        }
        if (memberResponse['birthdate'] != null) {
          final parsedDate = DateTime.tryParse(memberResponse['birthdate'].toString());
          // Ignore dummy default dates (like 1970-01-01)
          if (parsedDate != null && parsedDate.year > 1920) {
            _birthday = parsedDate;
          }
        }
      }
      
      if (baptismResponse != null) {
        if (baptismResponse['date'] != null) {
          final parsedDate = DateTime.tryParse(baptismResponse['date'].toString());
          if (parsedDate != null && parsedDate.year > 1920) {
            _baptismDate = parsedDate;
          }
        }
        _baptismLocation = _cleanString(baptismResponse['location']);
      }
      
      if (baptizerResponse != null && baptizerResponse['performer_member_ids'] != null) {
        // Parse the Postgres int8[] array directly into our Dart List<int>
        _selectedBaptizerIds = List<int>.from(baptizerResponse['performer_member_ids']);
      }
      
      // Fetch all members to populate our multi-select dialog checkboxes!
      final allMembersResponse = await Supabase.instance.client.from("MEMBER").select('member_id, first_name, last_name');
      final fetchedMembers = <Map<String, dynamic>>[
        {'member_id': -1, 'first_name': 'Other / Out of town', 'last_name': ''}
      ];

      for (var row in allMembersResponse) {
        final fName = _cleanString(row['first_name']);
        final lName = _cleanString(row['last_name']);
        // Only include members who actually have a name filled out (filters out uninitialized "NULL NULL" users)
        if (fName != null || lName != null) {
          fetchedMembers.add({
            'member_id': row['member_id'],
            'first_name': fName ?? '',
            'last_name': lName ?? '',
          });
        }
      }
      if (mounted) setState(() => _allMembers = fetchedMembers);
    } catch (e) {
      debugPrint("Error fetching existing data: $e");
    } finally {
      if (mounted) setState(() => _isFetchingData = false);
    }
  }

  /// Opens a Date Picker and saves the result
  Future<void> _pickDate(BuildContext context, DateTime? initialDate, Function(DateTime) onSaved) async {
    // store the results of showDatePicker into pickedDate
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF3E6990),
              surface: Color(0xFF1C1C1C),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      onSaved(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1C1C1C), Color(0xFF0C0C0C)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              _isFetchingData
                  ? const Expanded(child: Center(child: CircularProgressIndicator(color: Color(0xFF3E6990))))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction, // Shows errors as you type/select!
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitle(),
                            const SizedBox(height: 10),
                            const Center(
                              child: Text(
                                'Help us get to know you better!\nFill out as much or as little as you want.',
                                style: TextStyle(color: Colors.white70, fontFamily: 'Yeseva', fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 30),

                            // SECTION 1: BASIC BACKGROUND
                            _buildSubHeader('👤BASIC BACKGROUND'),
                            _buildTextField('First Name', _firstName, (val) => _firstName = val),
                            _buildTextField('Last Name', _lastName, (val) => _lastName = val),
                            _buildEnumDropdown(
                              'School',
                              _school,
                              SchoolEnum.values,
                              (v) => setState(() => _school = v!),
                            ),
                            _buildEnumDropdown(
                              'Sex',
                              _sex,
                              SexEnum.values,
                              (v) => setState(() => _sex = v!),
                            ),
                            
                            // SECTION 2: DATES & BAPTISM
                            _buildSubHeader('📅 DATES & BAPTISM'),
                            _buildDatePickerTile(
                              'Birthday', 
                              _birthday, 
                              (newDate) => setState(() => _birthday = newDate)
                            ),
                            _buildDatePickerTile(
                              'Baptism Date', 
                              _baptismDate, 
                              (newDate) => setState(() => _baptismDate = newDate)
                            ),
                            _buildTextField('Baptism Location', _baptismLocation, (val) => _baptismLocation = val),

                            // baptism disciples (list of existing members, up to four)
                            _buildMultiSelectBaptizers(),

                            const SizedBox(height: 10),

                            _buildSubmitButton(),
                          ],
                        ),
                      ),
                    ),

              const Positioned(
                top: 10,
                left: 10,
                child: CustomBackButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // MODULAR UI BUILDERS
  // ===========================================================================

  Widget _buildTitle() {
    return const Center(
      child: Text(
        'Member Profile',
        style: TextStyle(
          fontFamily: 'Caprasimo',
          fontSize: 32,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSubHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 10.0),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Yeseva',
          fontSize: 16,
          color: Color(0xFF3E6990),
          letterSpacing: 1.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Extracted Label approach: Label sits *above* the box to prevent overlapping
  Widget _buildTextField(String label, String? initialValue, Function(String?) onSaved) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontFamily: 'Yeseva', fontSize: 14)),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: initialValue,
            style: const TextStyle(color: Colors.white, fontFamily: 'Yeseva', fontSize: 16),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'This field is required.';
              return null;
            },
            onSaved: onSaved,
            decoration: InputDecoration(
              hintText: 'Enter $label',
              hintStyle: const TextStyle(color: Colors.white24, fontFamily: 'Yeseva'),
              filled: true,
              fillColor: const Color(0xFF282828),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), // Gives internal breathing room
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Integer Field with Hardware Keyboard Enforcement
  Widget _buildIntegerField(String label, String? initialValue, Function(String?) onSaved, {required int min, required int max}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontFamily: 'Yeseva', fontSize: 14)),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: initialValue,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Locks the keyboard to numbers only!
            style: const TextStyle(color: Colors.white, fontFamily: 'Yeseva', fontSize: 16),
            validator: (value) {
              if (value == null || value.isEmpty) return "This field is required.";
              final intVal = int.tryParse(value);
              if (intVal == null) return 'Must be a valid number.';
              if (intVal < min || intVal > max) return 'Must be between $min and $max.';
              return null;
            },
            onSaved: onSaved,
            decoration: InputDecoration(
              hintText: 'e.g. $min',
              hintStyle: const TextStyle(color: Colors.white24, fontFamily: 'Yeseva'),
              filled: true,
              fillColor: const Color(0xFF282828),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Enum Dropdown with proper 'Select...' hint
  Widget _buildEnumDropdown<T extends Enum>(
      String label,
      T? currentValue,
      List<T> items,
      ValueChanged<T?> onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontFamily: 'Yeseva', fontSize: 14)),
          const SizedBox(height: 6),
          DropdownButtonFormField<T>(
            initialValue: currentValue,
            validator: (value) => value == null ? 'This field is required.' : null,
            hint: const Text('Select...', style: TextStyle(color: Colors.white24, fontFamily: 'Yeseva', fontSize: 16)),
            dropdownColor: const Color(0xFF282828),
            style: const TextStyle(color: Colors.white, fontFamily: 'Yeseva', fontSize: 16),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF282828),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
            items: items.map((item) {
              final dynamic enumItem = item;
              return DropdownMenuItem<T>(
                value: item,
                child: Text(enumItem.uiLabel),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickerTile(String label, DateTime? currentValue, Function(DateTime) onUpdate) {
    // Format the date nicely for the user: MM/DD/YYYY
    final displayString = currentValue != null
        ? '${currentValue.month.toString().padLeft(2, '0')}/${currentValue.day.toString().padLeft(2, '0')}/${currentValue.year}'
        : 'Tap to select...';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontFamily: 'Yeseva', fontSize: 14)),
          const SizedBox(height: 6),
          InkWell(
            onTap: () => _pickDate(context, currentValue, onUpdate),
            borderRadius: BorderRadius.circular(15),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF282828),
                borderRadius: BorderRadius.circular(15),
                border: currentValue == null ? Border.all(color: Colors.red.withValues(alpha: 0.5)) : null,
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Color(0xFF3E6990)),
                  const SizedBox(width: 12),
                  Text(displayString, style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Yeseva')),
                  const Spacer(),
                  const Icon(Icons.edit, color: Colors.white24, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: const Color(0xFF3E6990),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Save Profile',
          style: TextStyle(fontSize: 18, fontFamily: 'Yeseva', color: Colors.white),
        ),
      ),
    );
  }

  // --- MULTI SELECT COMPONENT FOR BAPTIZERS ---
  Widget _buildMultiSelectBaptizers() {
    // Generate a display string of currently selected names
    String displayString = 'Tap to select up to 4...';
    if (_selectedBaptizerIds.isNotEmpty) {
      final selectedNames = _allMembers
          .where((m) => _selectedBaptizerIds.contains(m['member_id']))
          .map((m) => m['member_id'] == -1 
              ? 'Other / Out of town' 
              : '${m['first_name']} ${m['last_name']}'.trim())
          .toList();
      displayString = selectedNames.join(', ');
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Baptism Disciples (Who baptized you?)', style: TextStyle(color: Colors.white70, fontFamily: 'Yeseva', fontSize: 14)),
          const SizedBox(height: 6),
          InkWell(
            onTap: _showMultiSelectDialog,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF282828),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Icon(Icons.people, color: Color(0xFF3E6990)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      displayString,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Yeseva'),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.white24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMultiSelectDialog() {
    // We use a StatefulBuilder so the checkboxes can redraw independently of the main page!
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Create a temporary list to track selections before they hit "Save"
        List<int> tempSelected = List.from(_selectedBaptizerIds);

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1C1C1C),
              title: const Text('Select Disciples', style: TextStyle(fontFamily: 'Yeseva', color: Colors.white)),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _allMembers.length,
                  itemBuilder: (context, index) {
                    final member = _allMembers[index];
                    final memberId = member['member_id'] as int;
                    final isChecked = tempSelected.contains(memberId);

                    return CheckboxListTile(
                      activeColor: const Color(0xFF3E6990),
                      checkColor: Colors.white,
                      title: Text(
                        member['member_id'] == -1
                            ? 'Other / Out of town'
                            : '${member['first_name']} ${member['last_name']}'.trim(),
                        style: const TextStyle(fontFamily: 'Yeseva', color: Colors.white),
                      ),
                      value: isChecked,
                      onChanged: (bool? value) {
                        setStateDialog(() {
                          if (value == true) {
                            if (tempSelected.length < 4) {
                              tempSelected.add(memberId);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You can only select up to 4 disciples.')));
                            }
                          } else {
                            tempSelected.remove(memberId);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
                ),
                TextButton(
                  onPressed: () {
                    // Save the temporary list to the real state variable and redraw main page!
                    setState(() => _selectedBaptizerIds = tempSelected);
                    Navigator.pop(context);
                  },
                  child: const Text('Save', style: TextStyle(color: Color(0xFF3E6990), fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
