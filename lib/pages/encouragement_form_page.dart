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

  bool _isFetchingData = true;

  // Text Fields
  String? _nickname;
  String? _hometown;
  String? _major;
  String? _favFood;
  String? _favRestaurant;
  String? _starbucksOrder;
  String? _favDrink;
  String? _favCandy;
  String? _favDessert;
  String? _favBakedGood;
  String? _favScripture;
  String? _hobbies;
  String? _favSport;
  String? _favBook;
  String? _favMovie;
  String? _favMusicGenre;
  String? _favColor;
  String? _favFlower;
  String? _favAnimal;
  String? _favHoliday;
  String? _favDestination;

  // Integer Fields
  int? _enneagram;
  int? _favPsalm;

  // Enum Fields
  PreferredCommunicationEnum? _preferredCommunication;
  MyersBriggsEnum? _myersBriggs;
  IntrovertExtrovertEnum? _introvertExtrovert;
  LoveLanguageEnum? _loveLanguage;
  SpiceToleranceEnum? _spiceTolerance;
  CoffeeTeaEnum? _coffeeTea;
  VanillaChocolateEnum? _vanillaChocolate;
  BibleBookEnum? _favBibleBook;
  DogsCatsEnum? _dogsCats;
  MountainBeachEnum? _mountainsBeach;
  SeasonEnum? _favSeason;

  @override
  void initState() {
    super.initState();
    _fetchExistingData();
  }

  String? _cleanString(dynamic value) {
    if (value == null) return null;
    final str = value.toString().trim();
    if (str.isEmpty || str.toLowerCase() == 'null') return null;
    return str;
  }

  Future<void> _fetchExistingData() async {
    final memberId = context.read<UserState>().memberId;
    if (memberId == null) {
      setState(() => _isFetchingData = false);
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from("MEMBER_FACTS")
          .select()
          .eq("member_id", memberId)
          .maybeSingle();

      if (response != null) {
        _nickname = _cleanString(response['nickname']);
        _hometown = _cleanString(response['hometown']);
        _major = _cleanString(response['major']);
        _favFood = _cleanString(response['fav_food']);
        _favRestaurant = _cleanString(response['fav_restaurant']);
        _starbucksOrder = _cleanString(response['starbucks_order']);
        _favDrink = _cleanString(response['fav_drink']);
        _favCandy = _cleanString(response['fav_candy']);
        _favDessert = _cleanString(response['fav_dessert']);
        _favBakedGood = _cleanString(response['fav_baked_good']);
        _favScripture = _cleanString(response['fav_scripture']);
        _hobbies = _cleanString(response['hobbies']);
        _favSport = _cleanString(response['fav_sport']);
        _favBook = _cleanString(response['fav_book']);
        _favMovie = _cleanString(response['fav_movie']);
        _favMusicGenre = _cleanString(response['fav_music_genre']);
        _favColor = _cleanString(response['fav_color']);
        _favFlower = _cleanString(response['fav_flower']);
        _favAnimal = _cleanString(response['fav_animal']);
        _favHoliday = _cleanString(response['fav_holiday']);
        _favDestination = _cleanString(response['fav_destination']);

        // Integers
        _enneagram = response['enneagram'] is int ? response['enneagram'] : int.tryParse(response['enneagram']?.toString() ?? '');
        _favPsalm = response['fav_psalm'] is int ? response['fav_psalm'] : int.tryParse(response['fav_psalm']?.toString() ?? '');

        // Enums
        final prefComm = _cleanString(response['preferred_communication']);
        if (prefComm != null) {
          _preferredCommunication = PreferredCommunicationEnum.values.firstWhere((e) => e.dbValue.toLowerCase() == prefComm.toLowerCase(), orElse: () => PreferredCommunicationEnum.text);
        }
        final mb = _cleanString(response['myers_briggs']);
        if (mb != null) {
          _myersBriggs = MyersBriggsEnum.values.firstWhere((e) => e.dbValue.toLowerCase() == mb.toLowerCase(), orElse: () => MyersBriggsEnum.intj);
        }
        final ie = _cleanString(response['introvert_extrovert']);
        if (ie != null) {
          _introvertExtrovert = IntrovertExtrovertEnum.values.firstWhere((e) => e.dbValue.toLowerCase() == ie.toLowerCase(), orElse: () => IntrovertExtrovertEnum.introvert);
        }
        final ll = _cleanString(response['love_language']);
        if (ll != null) {
          _loveLanguage = LoveLanguageEnum.values.firstWhere((e) => e.dbValue.toLowerCase() == ll.toLowerCase(), orElse: () => LoveLanguageEnum.wordsOfAffirmation);
        }
        final st = _cleanString(response['spice_tolerance']);
        if (st != null) {
          _spiceTolerance = SpiceToleranceEnum.values.firstWhere((e) => e.dbValue.toLowerCase() == st.toLowerCase(), orElse: () => SpiceToleranceEnum.medium);
        }
        final ct = _cleanString(response['coffee_tea']);
        if (ct != null) {
          _coffeeTea = CoffeeTeaEnum.values.firstWhere((e) => e.dbValue.toLowerCase() == ct.toLowerCase(), orElse: () => CoffeeTeaEnum.coffee);
        }
        final vc = _cleanString(response['vanilla_chocolate']);
        if (vc != null) {
          _vanillaChocolate = VanillaChocolateEnum.values.firstWhere((e) => e.dbValue.toLowerCase() == vc.toLowerCase(), orElse: () => VanillaChocolateEnum.chocolate);
        }
        final bb = _cleanString(response['fav_bible_book']);
        if (bb != null) {
          _favBibleBook = BibleBookEnum.values.firstWhere((e) => e.dbValue.toLowerCase() == bb.toLowerCase(), orElse: () => BibleBookEnum.john);
        }
        final dc = _cleanString(response['dogs_cats']);
        if (dc != null) {
          _dogsCats = DogsCatsEnum.values.firstWhere((e) => e.dbValue.toLowerCase() == dc.toLowerCase(), orElse: () => DogsCatsEnum.dogs);
        }
        final mbBeach = _cleanString(response['mountains_beach']);
        if (mbBeach != null) {
          _mountainsBeach = MountainBeachEnum.values.firstWhere((e) => e.dbValue.toLowerCase() == mbBeach.toLowerCase(), orElse: () => MountainBeachEnum.beach);
        }
        final fs = _cleanString(response['fav_season']);
        if (fs != null) {
          _favSeason = SeasonEnum.values.firstWhere((e) => e.dbValue.toLowerCase() == fs.toLowerCase(), orElse: () => SeasonEnum.fall);
        }
      }
    } catch (e) {
      debugPrint("Error fetching encouragement facts: $e");
    } finally {
      if (mounted) setState(() => _isFetchingData = false);
    }
  }

  Future<void> _submitForm() async {
    // TODO: Write your _submitForm logic here!
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
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF3E6990)))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            _buildTextField('Nickname', _nickname, (v) => _nickname = v),
                            _buildTextField('Hometown', _hometown, (v) => _hometown = v),
                            _buildTextField('Major', _major, (v) => _major = v),
                            _buildEnumDropdown(
                              'Preferred Method of Communication',
                              _preferredCommunication,
                              PreferredCommunicationEnum.values,
                              (v) => setState(() => _preferredCommunication = v),
                            ),
                            const SizedBox(height: 10),

                            // SECTION 2: PERSONALITY
                            _buildSubHeader('😄PERSONALITY'),
                            _buildEnumDropdown(
                              'Myers-Briggs Type',
                              _myersBriggs,
                              MyersBriggsEnum.values,
                              (v) => setState(() => _myersBriggs = v),
                            ),
                            _buildIntegerField(
                              'Enneagram (1-9)',
                              _enneagram?.toString(),
                              (v) => _enneagram = int.tryParse(v ?? ''),
                              min: 1,
                              max: 9,
                            ),
                            _buildEnumDropdown(
                              'Introvert or Extrovert?',
                              _introvertExtrovert,
                              IntrovertExtrovertEnum.values,
                              (v) => setState(() => _introvertExtrovert = v),
                            ),
                            _buildEnumDropdown(
                              'Love Language',
                              _loveLanguage,
                              LoveLanguageEnum.values,
                              (v) => setState(() => _loveLanguage = v),
                            ),
                            const SizedBox(height: 10),

                            // SECTION 3: FOOD, DRINKS, CRAVINGS
                            _buildSubHeader('🍎FOOD, DRINKS, CRAVINGS'),
                            _buildTextField('Favorite Food', _favFood, (v) => _favFood = v),
                            _buildTextField('Favorite Restaurant', _favRestaurant, (v) => _favRestaurant = v),
                            _buildEnumDropdown(
                              'Spice Tolerance',
                              _spiceTolerance,
                              SpiceToleranceEnum.values,
                              (v) => setState(() => _spiceTolerance = v),
                            ),
                            _buildTextField('Starbucks Order', _starbucksOrder, (v) => _starbucksOrder = v),
                            _buildEnumDropdown(
                              'Coffee or Tea?',
                              _coffeeTea,
                              CoffeeTeaEnum.values,
                              (v) => setState(() => _coffeeTea = v),
                            ),
                            _buildTextField('Favorite Drink', _favDrink, (v) => _favDrink = v),
                            _buildTextField('Favorite Candy', _favCandy, (v) => _favCandy = v),
                            _buildTextField('Favorite Dessert', _favDessert, (v) => _favDessert = v),
                            _buildTextField('Favorite Baked Good', _favBakedGood, (v) => _favBakedGood = v),
                            _buildEnumDropdown(
                              'Vanilla or Chocolate?',
                              _vanillaChocolate,
                              VanillaChocolateEnum.values,
                              (v) => setState(() => _vanillaChocolate = v),
                            ),
                            const SizedBox(height: 10),

                            // SECTION 4: INTERESTS & ENTERTAINMENT
                            _buildSubHeader('🎬INTERESTS & ENTERTAINMENT'),
                            _buildTextField('Favorite Scripture', _favScripture, (v) => _favScripture = v),
                            _buildEnumDropdown(
                              'Favorite Book of the Bible',
                              _favBibleBook,
                              BibleBookEnum.values,
                              (v) => setState(() => _favBibleBook = v),
                            ),
                            _buildIntegerField(
                              'Favorite Psalm (1-150)',
                              _favPsalm?.toString(),
                              (v) => _favPsalm = int.tryParse(v ?? ''),
                              min: 1,
                              max: 150,
                            ),
                            _buildTextField('Hobbies', _hobbies, (v) => _hobbies = v),
                            _buildTextField('Favorite Sport', _favSport, (v) => _favSport = v),
                            _buildTextField('Favorite Book', _favBook, (v) => _favBook = v),
                            _buildTextField('Favorite Movie / Show', _favMovie, (v) => _favMovie = v),
                            _buildTextField('Favorite Music Genre', _favMusicGenre, (v) => _favMusicGenre = v),
                            const SizedBox(height: 10),

                            // SECTION 5: GENERAL FAVORITES
                            _buildSubHeader('⭐GENERAL FAVORITES'),
                            _buildTextField('Favorite Color', _favColor, (v) => _favColor = v),
                            _buildTextField('Favorite Flower', _favFlower, (v) => _favFlower = v),
                            _buildTextField('Favorite Animal', _favAnimal, (v) => _favAnimal = v),
                            _buildEnumDropdown(
                              'Dogs or Cats?',
                              _dogsCats,
                              DogsCatsEnum.values,
                              (v) => setState(() => _dogsCats = v),
                            ),
                            _buildEnumDropdown(
                              'Mountains or Beach?',
                              _mountainsBeach,
                              MountainBeachEnum.values,
                              (v) => setState(() => _mountainsBeach = v),
                            ),
                            _buildEnumDropdown(
                              'Favorite Season',
                              _favSeason,
                              SeasonEnum.values,
                              (v) => setState(() => _favSeason = v),
                            ),
                            _buildTextField('Favorite Holiday', _favHoliday, (v) => _favHoliday = v),
                            _buildTextField('Dream / Favorite Destination', _favDestination, (v) => _favDestination = v),
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
        'Encouragement Facts',
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
            onSaved: onSaved,
            decoration: InputDecoration(
              hintText: 'Enter $label',
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
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(color: Colors.white, fontFamily: 'Yeseva', fontSize: 16),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return null; // 👈 Fully optional!
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
