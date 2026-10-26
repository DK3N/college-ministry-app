import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_back_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_page.dart';
import 'package:provider/provider.dart';
import '../state/user_state.dart';

// =============================================================================
// DATABASE ENUMS (Styled as Enhanced Enums with Postgres string labels)
// =============================================================================

enum MyersBriggsEnum {
  intj('intj', 'INTJ'), intp('intp', 'INTP'), entj('entj', 'ENTJ'), entp('entp', 'ENTP'),
  infj('infj', 'INFJ'), infp('infp', 'INFP'), enfj('enfj', 'ENFJ'), enfp('enfp', 'ENFP'),
  istj('istj', 'ISTJ'), isfj('isfj', 'ISFJ'), estj('estj', 'ESTJ'), esfj('esfj', 'ESFJ'),
  istp('istp', 'ISTP'), isfp('isfp', 'ISFP'), estp('estp', 'ESTP'), esfp('esfp', 'ESFP');
  final String dbValue;
  final String uiLabel;
  const MyersBriggsEnum(this.dbValue, this.uiLabel);
}

enum SeasonEnum {
  spring('spring', 'Spring'),
  summer('summer', 'Summer'),
  fall('fall', 'Fall'),
  winter('winter', 'Winter');
  final String dbValue;
  final String uiLabel;
  const SeasonEnum(this.dbValue, this.uiLabel);
}

enum DogsCatsEnum {
  cats('cats', 'Cats'),
  dogs('dogs', 'Dogs');
  final String dbValue;
  final String uiLabel;
  const DogsCatsEnum(this.dbValue, this.uiLabel);
}

enum VanillaChocolateEnum {
  vanilla('vanilla', 'Vanilla'),
  chocolate('chocolate', 'Chocolate');
  final String dbValue;
  final String uiLabel;
  const VanillaChocolateEnum(this.dbValue, this.uiLabel);
}

enum MountainBeachEnum {
  mountain('mountain', 'Mountains'),
  beach('beach', 'Beach');
  final String dbValue;
  final String uiLabel;
  const MountainBeachEnum(this.dbValue, this.uiLabel);
}

enum IntrovertExtrovertEnum {
  introvert('introvert', 'Introvert'),
  extrovert('extrovert', 'Extrovert');
  final String dbValue;
  final String uiLabel;
  const IntrovertExtrovertEnum(this.dbValue, this.uiLabel);
}

enum CoffeeTeaEnum {
  coffee('coffee', 'Coffee'),
  tea('tea', 'Tea');
  final String dbValue;
  final String uiLabel;
  const CoffeeTeaEnum(this.dbValue, this.uiLabel);
}

enum BibleBookEnum {
  genesis('genesis', 'Genesis'), exodus('exodus', 'Exodus'), leviticus('leviticus', 'Leviticus'), numbers('numbers', 'Numbers'),
  deuteronomy('deuteronomy', 'Deuteronomy'), joshua('joshua', 'Joshua'), judges('judges', 'Judges'), ruth('ruth', 'Ruth'),
  samuel1('1_samuel', '1 Samuel'), samuel2('2_samuel', '2 Samuel'), kings1('1_kings', '1 Kings'), kings2('2_kings', '2 Kings'),
  chronicles1('1_chronicles', '1 Chronicles'), chronicles2('2_chronicles', '2 Chronicles'), ezra('ezra', 'Ezra'),
  nehemiah('nehemiah', 'Nehemiah'), esther('esther', 'Esther'), job('job', 'Job'), psalms('psalms', 'Psalms'),
  proverbs('proverbs', 'Proverbs'), ecclesiastes('ecclesiastes', 'Ecclesiastes'), songOfSongs('song_of_songs', 'Song of Songs'),
  isaiah('isaiah', 'Isaiah'), jeremiah('jeremiah', 'Jeremiah'), lamentations('lamentations', 'Lamentations'),
  ezekiel('ezekiel', 'Ezekiel'), daniel('daniel', 'Daniel'), hosea('hosea', 'Hosea'), joel('joel', 'Joel'),
  amos('amos', 'Amos'), obadiah('obadiah', 'Obadiah'), jonah('jonah', 'Jonah'), micah('micah', 'Micah'),
  nahum('nahum', 'Nahum'), habakkuk('habakkuk', 'Habakkuk'), zephaniah('zephaniah', 'Zephaniah'), haggai('haggai', 'Haggai'),
  zechariah('zechariah', 'Zechariah'), malachi('malachi', 'Malachi'), matthew('matthew', 'Matthew'), mark('mark', 'Mark'),
  luke('luke', 'Luke'), john('john', 'John'), acts('acts', 'Acts'), romans('romans', 'Romans'),
  corinthians1('1_corinthians', '1 Corinthians'), corinthians2('2_corinthians', '2 Corinthians'), galatians('galatians', 'Galatians'),
  ephesians('ephesians', 'Ephesians'), philippians('philippians', 'Philippians'), colossians('colossians', 'Colossians'),
  thessalonians1('1_thessalonians', '1 Thessalonians'), thessalonians2('2_thessalonians', '2 Thessalonians'),
  timothy1('1_timothy', '1 Timothy'), timothy2('2_timothy', '2 Timothy'), titus('titus', 'Titus'), philemon('philemon', 'Philemon'),
  hebrews('hebrews', 'Hebrews'), james('james', 'James'), peter1('1_peter', '1 Peter'), peter2('2_peter', '2 Peter'),
  john1('1_john', '1 John'), john2('2_john', '2 John'), john3('3_john', '3 John'), jude('jude', 'Jude'),
  relevation('relevation', 'Revelation');

  final String dbValue;
  final String uiLabel;
  const BibleBookEnum(this.dbValue, this.uiLabel);
}

enum LoveLanguageEnum {
  wordsOfAffirmation('words_of_affirmation', 'Words of Affirmation'),
  gifts('gifts', 'Gifts'),
  qualityTime('quality_time', 'Quality Time'),
  physicalTouch('physical_touch', 'Physical Touch'),
  actsOfService('acts_of_service', 'Acts of Service');
  final String dbValue;
  final String uiLabel;
  const LoveLanguageEnum(this.dbValue, this.uiLabel);
}

enum SpiceToleranceEnum {
  zero('zero', 'Zero'),
  low('low', 'Low'),
  medium('medium', 'Medium'),
  high('high', 'High'),
  dontTryMe('dont_try_me', "Don't Try Me");
  final String dbValue;
  final String uiLabel;
  const SpiceToleranceEnum(this.dbValue, this.uiLabel);
}

enum PreferredCommunicationEnum {
  text('text', 'Text'),
  phoneCall('phone_call', 'Phone Call'),
  faceToFace('face_to_face', 'Face to Face'),
  email('email', 'Email'),
  paperMail('paper_mail', 'Paper Mail');
  final String dbValue;
  final String uiLabel;
  const PreferredCommunicationEnum(this.dbValue, this.uiLabel);
}

// =============================================================================
// FORM PAGE WIDGET
// =============================================================================

class EncouragementFormPage extends StatefulWidget {
  const EncouragementFormPage({super.key});

  @override
  State<EncouragementFormPage> createState() => _EncouragementFormPageState();
}

class _EncouragementFormPageState extends State<EncouragementFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Single Map to hold all form data securely and cleanly!
  final Map<String, dynamic> _formData = {};

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formData.clear(); // Clear old data to prevent stale inputs
      _formKey.currentState!.save(); // Triggers all onSaved callbacks to populate _formData!

      // Inherit the memberId from UserState provider
      final int? memberId = context.read<UserState>().memberId;

      if (memberId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Member ID not found. Please log in again.'), backgroundColor: Colors.red),
        );
        return;
      }

      try {
        // inject the primary key into the data payload
        _formData['member_id'] = memberId;

        // Send data payload to supabase using upsert()
        if (_formData.length > 1) { // length should be greater than 1 because we already added member_id
          await Supabase.instance.client.from("MEMBER_FACTS").upsert(_formData);
        }

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
              SingleChildScrollView(
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
                      _buildTextField('Nickname', 'nickname'),
                      _buildTextField('Hometown', 'hometown'),
                      _buildTextField('Major', 'major'),
                      _buildEnumDropdown(
                        'Preferred Method of Communication',
                        'preferred_communication',
                        PreferredCommunicationEnum.values,
                      ),
                      const SizedBox(height: 10),

                      // SECTION 2: PERSONALITY
                      _buildSubHeader('😄PERSONALITY'),
                      _buildEnumDropdown('Myers-Briggs Type', 'myers_briggs', MyersBriggsEnum.values),
                      _buildIntegerField('Enneagram (1-9)', 'enneagram', min: 1, max: 9),
                      _buildEnumDropdown('Introvert or Extrovert?', 'introvert_extrovert', IntrovertExtrovertEnum.values),
                      _buildEnumDropdown('Love Language', 'love_language', LoveLanguageEnum.values),
                      const SizedBox(height: 10),

                      // SECTION 3: FOOD, DRINKS, CRAVINGS
                      _buildSubHeader('🍎FOOD, DRINKS, CRAVINGS'),
                      _buildTextField('Favorite Food', 'fav_food'),
                      _buildTextField('Favorite Restaurant', 'fav_restaurant'),
                      _buildEnumDropdown('Spice Tolerance', 'spice_tolerance', SpiceToleranceEnum.values),
                      _buildTextField('Starbucks Order', 'starbucks_order'),
                      _buildEnumDropdown('Coffee or Tea?', 'coffee_tea', CoffeeTeaEnum.values),
                      _buildTextField('Favorite Drink', 'fav_drink'),
                      _buildTextField('Favorite Candy', 'fav_candy'),
                      _buildTextField('Favorite Dessert', 'fav_dessert'),
                      _buildTextField('Favorite Baked Good', 'fav_baked_good'),
                      _buildEnumDropdown('Vanilla or Chocolate?', 'vanilla_chocolate', VanillaChocolateEnum.values),
                      const SizedBox(height: 10),

                      // SECTION 4: INTERESTS & ENTERTAINMENT
                      _buildSubHeader('🎬INTERESTS & ENTERTAINMENT'),
                      _buildTextField('Favorite Scripture', 'fav_scripture'),
                      _buildEnumDropdown('Favorite Book of the Bible', 'fav_bible_book', BibleBookEnum.values),
                      _buildIntegerField('Favorite Psalm (1-150)', 'fav_psalm', min: 1, max: 150),
                      _buildTextField('Hobbies', 'hobbies'),
                      _buildTextField('Favorite Sport', 'fav_sport'),
                      _buildTextField('Favorite Book', 'fav_book'),
                      _buildTextField('Favorite Movie / Show', 'fav_movie'),
                      _buildTextField('Favorite Music Genre', 'fav_music_genre'),
                      const SizedBox(height: 10),

                      // SECTION 5: GENERAL FAVORITES
                      _buildSubHeader('⭐GENERAL FAVORITES'),
                      _buildTextField('Favorite Color', 'fav_color'),
                      _buildTextField('Favorite Flower', 'fav_flower'),
                      _buildTextField('Favorite Animal', 'fav_animal'),
                      _buildEnumDropdown('Dogs or Cats?', 'dogs_cats', DogsCatsEnum.values),
                      _buildEnumDropdown('Mountains or Beach?', 'mountains_beach', MountainBeachEnum.values),
                      _buildEnumDropdown('Favorite Season', 'fav_season', SeasonEnum.values),
                      _buildTextField('Favorite Holiday', 'fav_holiday'),
                      _buildTextField('Dream / Favorite Destination', 'fav_destination'),
                      const SizedBox(height: 35),

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
  Widget _buildTextField(String label, String dbKey) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontFamily: 'Yeseva', fontSize: 14)),
          const SizedBox(height: 6),
          TextFormField(
            style: const TextStyle(color: Colors.white, fontFamily: 'Yeseva', fontSize: 16),
            onSaved: (value) {
              if (value != null && value.trim().isNotEmpty) {
                _formData[dbKey] = value.trim();
              }
            },
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
  Widget _buildIntegerField(String label, String dbKey, {required int min, required int max}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontFamily: 'Yeseva', fontSize: 14)),
          const SizedBox(height: 6),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Locks the keyboard to numbers only!
            style: const TextStyle(color: Colors.white, fontFamily: 'Yeseva', fontSize: 16),
            validator: (value) {
              if (value == null || value.isEmpty) return null; // 👈 Field is fully optional!
              final intVal = int.tryParse(value);
              if (intVal == null) return 'Must be a valid number.';
              if (intVal < min || intVal > max) return 'Must be between $min and $max.';
              return null;
            },
            onSaved: (value) {
              if (value != null && value.trim().isNotEmpty) {
                _formData[dbKey] = int.parse(value.trim()); // Save as an actual int
              }
            },
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
    String dbKey,
    List<T> items,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontFamily: 'Yeseva', fontSize: 14)),
          const SizedBox(height: 6),
          DropdownButtonFormField<T>(
            onSaved: (value) {
              if (value != null) {
                // Dynamically extract the dbValue from our enhanced enum!
                final dynamic enumItem = value;
                _formData[dbKey] = enumItem.dbValue;
              }
            },
            // 👈 No validator means this field is completely optional!
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
            onChanged: (value) {}, // Required property but we let onSaved handle the state!
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
}
