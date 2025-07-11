import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static const Color lightPrimary = LightThemeColors.primary;
  static const Color darkPrimary = DarkThemeColors.primary;
  static const double borderRadius = 10.0;
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: LightThemeColors.primary),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: LightThemeColors.darkBlue,
        ),
        bodyMedium: TextStyle(
          color: LightThemeColors.darkBlue,
        ),
        bodySmall: TextStyle(
          color: LightThemeColors.darkBlue,
        ),
        displaySmall: TextStyle(
          color: LightThemeColors.darkBlue,
        ),
        displayMedium: TextStyle(
          color: LightThemeColors.darkBlue,
        ),
        displayLarge: TextStyle(
          color: LightThemeColors.darkBlue,
        ),
        headlineLarge: TextStyle(
          color: LightThemeColors.darkBlue,
        ),
        headlineMedium: TextStyle(
          color: LightThemeColors.darkBlue,
        ),
        headlineSmall: TextStyle(
          color: LightThemeColors.darkBlue,
        ),
        titleMedium: TextStyle(
          color: LightThemeColors.darkBlue,
        ),
        titleLarge: TextStyle(
          color: LightThemeColors.darkBlue,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
        titleSmall: TextStyle(
          color: LightThemeColors.darkBlue,
        ),
      ),
      listTileTheme: ListTileThemeData(
          dense: true,
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius))),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: LightThemeColors.primary,
        foregroundColor: Colors.white,
        splashColor: LightThemeColors.primary,
        hoverColor: LightThemeColors.primary,
        focusColor: LightThemeColors.primary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
      splashColor: Colors.grey[200],
      highlightColor: Colors.grey[100],
      tooltipTheme: TooltipThemeData(
        textStyle: const TextStyle(color: Colors.white, fontSize: 18),
        decoration: BoxDecoration(
          color: LightThemeColors.primary,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      iconTheme: const IconThemeData(
        color: LightThemeColors.primary,
      ),
      iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
        iconColor: WidgetStateProperty.all<Color>(LightThemeColors.primary),
        iconSize: WidgetStateProperty.all<double>(35),
        splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
      )),
      dividerTheme: const DividerThemeData(
        color: LightThemeColors.grey,
        thickness: 2,
      ),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
        splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)))),
      )),

      // Color primario
      primaryColor: LightThemeColors.primary,
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all<Color>(LightThemeColors.primary),
        trackColor: WidgetStateProperty.all<Color>(
            DarkThemeColors.primary.withAlpha(50)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.all<Color>(LightThemeColors.primary),
      ),
      primaryIconTheme: const IconThemeData(color: LightThemeColors.primary),
      // AppB ar Theme
      appBarTheme: AppBarTheme(
        
        elevation: 0,actionsIconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueGrey[800],
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
      ),
      scrollbarTheme: const ScrollbarThemeData(
          radius: Radius.circular(24),
          thumbColor: WidgetStatePropertyAll(Colors.grey)),
      scaffoldBackgroundColor: LightThemeColors.background,
      cardTheme: CardThemeData(
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(backgroundColor: const WidgetStatePropertyAll(Colors.white),
        elevation: WidgetStateProperty.all<double>(-0),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius))),
      )),
      inputDecorationTheme: InputDecorationTheme(
        prefixIconColor: LightThemeColors.darkGrey,
        suffixIconColor: LightThemeColors.primary,
        fillColor: Colors.white,
        filled: true,
        iconColor: LightThemeColors.primary,
        contentPadding:
            const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        floatingLabelStyle: const TextStyle(color: LightThemeColors.primary),
        hintStyle: const TextStyle(fontSize: 14),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: Colors.transparent, width: 2)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: Colors.transparent, width: 2)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: Colors.transparent, width: 2)),
        // prefixIcon: Icon( Icons.verified_user_outlined ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 1,
      ),
      snackBarTheme: const SnackBarThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        elevation: 1,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF505050),
        contentTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
          shadowColor: Colors.black.withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 2,
          color: Colors.white,
          textStyle: const TextStyle(
            color: LightThemeColors.darkBlue,
            fontSize: 18,
          )),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: LightThemeColors.primary,
      ),
      filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
        backgroundColor:
            WidgetStateProperty.all<Color>(LightThemeColors.primary),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(borderRadius * 2)))),
      )),
      dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: const TextStyle(
            color: LightThemeColors.primary,
            fontSize: 18,
            overflow: TextOverflow.ellipsis,
          ),
          menuStyle: MenuStyle(
              maximumSize: WidgetStateProperty.all(Size.infinite),
              backgroundColor: const WidgetStatePropertyAll(Colors.white),
              elevation: const WidgetStatePropertyAll(0),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius)))),
          inputDecorationTheme: const InputDecorationTheme(
            fillColor: Colors.white,
            filled: true,
            contentPadding:
                EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            floatingLabelStyle: TextStyle(color: LightThemeColors.primary),
            outlineBorder: BorderSide(color: Colors.transparent, width: 2),
          )));

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
      dividerTheme: DividerThemeData(
        color: DarkThemeColors.grey.withAlpha(80),
        thickness: 1,
      ),
      tooltipTheme: TooltipThemeData(
        textStyle: const TextStyle(color: Colors.white, fontSize: 18),
        decoration: BoxDecoration(
          color: DarkThemeColors.primary,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
      splashColor: DarkThemeColors.primary.withAlpha(160),
      highlightColor: DarkThemeColors.primary.withAlpha(1),
      iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
        iconColor: WidgetStateProperty.all<Color>(DarkThemeColors.primary),
        iconSize: WidgetStateProperty.all<double>(35),
        splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
      )),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: DarkThemeColors.primary,
        foregroundColor: Colors.white,
        splashColor: DarkThemeColors.primary,
        hoverColor: DarkThemeColors.primary,
        focusColor: DarkThemeColors.primary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(Colors.white),
        splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)))),
      )),
      // Color primario
      primaryColor: DarkThemeColors.primary,
      iconTheme: const IconThemeData(color: DarkThemeColors.primary),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: DarkThemeColors.primary,
      ),
      filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
        backgroundColor:
            WidgetStateProperty.all<Color>(DarkThemeColors.primary),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(borderRadius * 2)))),
      )),
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white, size: 30),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.all<Color>(DarkThemeColors.primary),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: DarkThemeColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        elevation: 0,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all<Color>(DarkThemeColors.primary),
        trackColor: WidgetStateProperty.all<Color>(
            DarkThemeColors.primary.withAlpha(50)),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 0,
      ),
      //   dialogBackgroundColor: AppColorsLightTheme.background,
      scaffoldBackgroundColor: DarkThemeColors.background,
      cardTheme: CardThemeData(
        color: DarkThemeColors.cardBackground,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
        elevation: WidgetStateProperty.all<double>(0),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius))),
      )),
      inputDecorationTheme: InputDecorationTheme(
        prefixIconColor: DarkThemeColors.grey,
        suffixIconColor: DarkThemeColors.primary,
        fillColor: DarkThemeColors.darkGrey,
        filled: true,
        iconColor: DarkThemeColors.primary,
        contentPadding:
            const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        floatingLabelStyle: const TextStyle(color: DarkThemeColors.primary),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: Colors.transparent, width: 2)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: Colors.transparent, width: 2)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: Colors.transparent, width: 2)),
        // prefixIcon: Icon( Icons.verified_user_outlined ),
      ),
      snackBarTheme: const SnackBarThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color.fromARGB(255, 80, 80, 80),
        contentTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          color: DarkThemeColors.background,
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          )),
      dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: const TextStyle(
            color: DarkThemeColors.primary,
            overflow: TextOverflow.ellipsis,
            fontSize: 18,
          ),
          menuStyle: MenuStyle(
              maximumSize: WidgetStateProperty.all(Size.infinite),
              backgroundColor: const WidgetStatePropertyAll(
                  DarkThemeColors.cardBackground),
              elevation: const WidgetStatePropertyAll(0),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius)))),
          inputDecorationTheme: const InputDecorationTheme(
            fillColor: DarkThemeColors.cardBackground,
            filled: true,
            contentPadding:
                EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            floatingLabelStyle: TextStyle(color: DarkThemeColors.primary),
            outlineBorder: BorderSide(color: Colors.transparent, width: 2),
          )));
}
