import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'gen/languages.dart';
import 'logic/language.dart';
import 'logic/theme.dart';
import 'screens/file_manager.dart';
import 'utils/material_ink_well.dart';

// todo before migrating locales:
// - design review (colors, spacing, animations, etc)
// - accessibility
// - create sharing intent (android, ios, maybe desktop?)
// - code cleanup & to-do review
// - review imports (cupertino, material, etc -> use only foundation or widgets)
// - cleanup assets & fonts
// - check fonts for usage
// - font licenses
// - get rid of all prints
// - add an icon to the android notifications bar

// todo review variables' access scope
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageManager()),
        ChangeNotifierProvider(create: (_) => ThemeManager()),
      ],
      child: SharikApp(),
    ),
  );
}

class SharikApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.watch<ThemeManager>().brightness == Brightness.dark
          ? SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.grey.shade900.withOpacity(0.4),
              systemNavigationBarColor: Colors.deepPurple.shade100,
              // systemNavigationBarDividerColor: Colors.deepPurple.shade100,
              systemNavigationBarIconBrightness: Brightness.dark,
            )
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.grey.shade100.withOpacity(0.6),
              systemNavigationBarColor: Colors.deepPurple.shade100,
              // systemNavigationBarDividerColor: Colors.deepPurple.shade100,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return ResponsiveWrapper.builder(
            ScrollConfiguration(
              behavior: BouncingScrollBehavior(),
              child: child!,
            ),
            minWidth: 400,
            defaultScale: true,
            breakpoints: [
              const ResponsiveBreakpoint.resize(400, name: MOBILE),
              const ResponsiveBreakpoint.autoScale(680, name: TABLET),
              const ResponsiveBreakpoint.autoScale(
                1100,
                name: DESKTOP,
                scaleFactor: 1.2,
              ),
            ],
            breakpointsLandscape: [
              const ResponsiveBreakpoint.autoScaleDown(
                400,
                name: MOBILE,
                scaleFactor: 0.7,
              ),
              const ResponsiveBreakpoint.autoScale(
                680,
                name: TABLET,
                scaleFactor: 0.7,
              ),
              // const ResponsiveBreakpoint.autoScale(1100, name: DESKTOP, scaleFactor: 0.5),
            ],
          );
        },
        // builder: DevicePreview.appBuilder, //
        locale: context.watch<LanguageManager>().language.locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: languageListGen.map((e) => e.locale),
        title: 'Sharik',
        theme: ThemeData(
          splashFactory: MaterialInkSplash.splashFactory,
          brightness: Brightness.light,
          inputDecorationTheme: InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade900.withOpacity(0.8),
                width: 2,
              ),
            ),
          ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.grey.shade600,
            selectionHandleColor: Colors.grey.shade200.withOpacity(0.9),
            selectionColor: Colors.deepPurple.shade100.withOpacity(0.6),
          ),

          // sharik top icon color
          colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: Colors.deepPurple.shade500),

          // primarySwatch: Colors.deepPurple,

          // right click selection color
          cardColor: Colors.grey.shade200.withOpacity(0.9),

          // color of the button on the default background
          dividerColor: Colors.deepPurple.shade400,

          // about card color
          highlightColor: Colors.deepPurple.shade50.withOpacity(0.6),
        ),
        darkTheme: ThemeData(
          splashFactory: MaterialInkSplash.splashFactory,
          inputDecorationTheme: InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.deepPurple.shade50.withOpacity(0.8),
                width: 2,
              ),
            ),
          ),

          // primarySwatch: Colors.grey,

          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.deepPurple.shade50,
            selectionHandleColor: Colors.deepPurple.shade300.withOpacity(0.9),
            selectionColor: Colors.deepPurple.shade50.withOpacity(0.4),
          ),

          colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: Colors.deepPurple.shade500, brightness: Brightness.dark),

          // right click selection color
          cardColor: Colors.deepPurple.shade400.withOpacity(0.9),

          // color of the button on the default background
          dividerColor: Colors.deepPurple.shade50,

          // about card color
          highlightColor: Colors.deepPurple.shade100.withOpacity(0.8),
        ),
        themeMode: context.watch<ThemeManager>().theme,
        home: FileManagerScreen(),
      ),
    );
  }
}
