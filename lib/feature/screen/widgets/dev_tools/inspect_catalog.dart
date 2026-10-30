/// What the inspector shows for one widget on the website.
class InspectInfo {
  /// Widget class name, as written in the code.
  final String widget;

  /// Path in the repo, used for the "View source" link.
  final String file;

  final String en;
  final String ar;
  final List<String> tags;

  const InspectInfo({
    required this.widget,
    required this.file,
    required this.en,
    required this.ar,
    this.tags = const [],
  });

  String get sourceUrl =>
      'https://github.com/MahmoudReda0o0/personal_website_v2/blob/main/$file';

  String describe(String lang) => lang == 'ar' ? ar : en;
}

/// Every inspectable part of the website. Keep these in sync with the code
/// they describe.
class InspectCatalog {
  InspectCatalog._();

  static const header = InspectInfo(
    widget: 'WebsiteHeader',
    file: 'lib/feature/screen/widgets/website_header.dart',
    en: "Name and title, loaded from the personal_info table in Supabase. "
        "The green line under the name is live: it reads Mahmoud's latest "
        "public push from the GitHub API, and only shows if it happened in "
        "the last 3 days.",
    ar: 'الاسم والمسمّى الوظيفي، جايين من جدول personal_info على Supabase. '
        'والسطر الأخضر تحت الاسم لايف: بيجيب آخر push عمله محمود من '
        'GitHub API، وبيظهر بس لو كان في آخر 3 أيام.',
    tags: ['Supabase', 'GitHub API', 'Provider'],
  );

  static const mivo = InspectInfo(
    widget: 'MivoImageWidget',
    file: 'lib/feature/screen/widgets/mivo_image_widget.dart',
    en: "Mivo's avatar follows the AI's state in MivoAiProvider: loading "
        'while the answer is on its way, success when it lands, sad if '
        'something fails.',
    ar: 'صورة Mivo بتمشي مع حالة الـ AI في MivoAiProvider: loading وهو '
        'بيجهّز الرد، وsuccess لما الرد يوصل، وsad لو حصلت مشكلة.',
    tags: ['Provider', 'State'],
  );

  static const intro = InspectInfo(
    widget: 'ChatIntro',
    file: 'lib/feature/screen/widgets/chat_empty_state.dart',
    en: 'The intro and the personal greeting. When the page is opened from '
        'a link like ?c=k7f3q2, it calls open_custom_link, a Postgres '
        'function that returns only the name and message for that one '
        'code and records the visit. Visitors can never list the links.',
    ar: 'المقدمة والترحيب الشخصي. لو الصفحة اتفتحت من لينك زي ?c=k7f3q2، '
        'بتنادي open_custom_link، وده function في Postgres بترجّع الاسم '
        'والرسالة بتوع الكود ده بس، وبتسجّل الزيارة. ومحدش من الزوار '
        'يقدر يشوف قايمة اللينكات.',
    tags: ['Supabase RPC', 'RLS', 'Postgres'],
  );

  static const input = InspectInfo(
    widget: 'WebsiteInputSection',
    file: 'lib/feature/screen/widgets/website_input_section.dart',
    en: 'The question field. Sending calls the ask_mivo_v2 Edge Function; '
        'the button turns into a spinner until the answer arrives.',
    ar: 'خانة السؤال. لما تبعت، بتنادي Edge Function اسمها ask_mivo_v2، '
        'والزرار بيتحوّل لـ loading لحد ما الرد يوصل.',
    tags: ['Provider', 'Edge Functions'],
  );

  static const chips = InspectInfo(
    widget: 'SuggestionChips',
    file: 'lib/feature/screen/widgets/suggestion_chips.dart',
    en: 'Ready-made questions. Before the first question they come from '
        'the suggested_questions table, in English or Arabic by browser '
        'language. After each answer, Gemini returns 2–3 follow-ups as '
        'structured JSON. Tapping one fills the field and sends it.',
    ar: 'أسئلة جاهزة. قبل أول سؤال بتيجي من جدول suggested_questions، '
        'عربي أو إنجليزي حسب لغة المتصفّح. وبعد كل رد، Gemini بيرجّع '
        '2 أو 3 أسئلة متابعة كـ JSON. ولما تدوس على واحد، بيتكتب في '
        'الخانة ويتبعت.',
    tags: ['Gemini', 'JSON schema', 'Supabase'],
  );

  static const chat = InspectInfo(
    widget: 'WebsiteChatSection',
    file: 'lib/feature/screen/widgets/website_chat_section.dart',
    en: "Question and answer. The answer comes from a Supabase Edge "
        "Function (Deno) that builds a prompt from Mahmoud's CV data and "
        'asks Gemini, falling back to another model if one is busy or out '
        'of quota.',
    ar: 'السؤال والرد. الرد جاي من Edge Function على Supabase (مكتوبة '
        'بـ Deno)، بتبني prompt من بيانات الـ CV بتاعة محمود وتسأل '
        'Gemini، ولو موديل مشغول أو الحصة بتاعته خلصت، بتجرّب موديل تاني.',
    tags: ['Edge Functions', 'Gemini', 'Deno'],
  );

  static const ticTacToe = InspectInfo(
    widget: 'TicTacToeSection',
    file:
        'lib/feature/screen/widgets/mini_games/tic_tac_toe/tic_tac_toe_section.dart',
    en: 'The AI plays with minimax. Easy plays randomly, Medium picks the '
        'best move 70% of the time, and Hard never loses.',
    ar: 'الـ AI بيلعب بخوارزمية minimax. في Easy بيلعب عشوائي، وفي Medium '
        'بيختار أحسن حركة 70% من الوقت، وفي Hard عمره ما يخسر.',
    tags: ['Minimax', 'Provider'],
  );

  static const simonSays = InspectInfo(
    widget: 'SimonSaysSection',
    file:
        'lib/feature/screen/widgets/mini_games/simon_says/simon_says_section.dart',
    en: 'Simon Says with levels you unlock as you go. A session counter '
        'cancels the old playback when you restart, so a delayed '
        'animation never touches the new round.',
    ar: 'لعبة Simon Says بمستويات بتتفتح وانت بتكسب. وفيه session counter '
        'بيلغي العرض القديم لما تبدأ من جديد، علشان أي animation متأخرة '
        'ما تبوّظش الجولة الجديدة.',
    tags: ['Provider', 'Async'],
  );
}
