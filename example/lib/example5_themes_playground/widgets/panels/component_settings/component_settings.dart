import 'package:flutter/material.dart';

import '../../../../shared/controllers/theme_controller.dart';
import '../../../../shared/model/adaptive_theme.dart';
import '../../../../shared/model/splash_type_enum.dart';
import '../../../../shared/model/visual_density_enum.dart';
import '../../../../shared/utils/link_text_span.dart';
import '../../../../shared/widgets/app/show_sub_theme_colors.dart';
import '../../../../shared/widgets/universal/list_tile_reveal.dart';
import '../../../../shared/widgets/universal/switch_list_tile_reveal.dart';
import '../../shared/adaptive_theme_popup_menu.dart';
import '../../shared/back_to_actual_platform.dart';
import '../../shared/component_colors_reveal.dart';
import '../../shared/is_web_list_tile.dart';
import '../../shared/platform_popup_menu.dart';
import '../../shared/splash_type_popup_menu.dart';
import '../../shared/visual_density_popup_menu.dart';

// Panel used to turn usage ON/OFF usage of opinionated component sub-themes.
//
// Settings are available for border radius and a few other options.
class ComponentSettings extends StatelessWidget {
  const ComponentSettings(this.controller, {super.key});
  final ThemeController controller;

  static final Uri _fcsFlutterIssue117755 = Uri(
    scheme: 'https',
    host: 'github.com',
    path: 'flutter/flutter/issues/117755',
  );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isLight = theme.brightness == Brightness.light;
    final bool useMaterial3 = theme.useMaterial3;
    final TextStyle spanTextStyle = theme.textTheme.bodySmall!;
    final TextStyle linkStyle = theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.primary, fontWeight: FontWeight.bold);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 8),
        VisualDensityPopupMenu(
          title: const Text('VisualDensity'),
          subtitle: const Text(
            'Defines the visual density of user interface components. '
            'Density, in the context of a UI, is the vertical and horizontal '
            '"compactness" of the components in the UI. It is without unit, '
            'since it means different things to different UI components.\n',
          ),
          index: controller.usedVisualDensity?.index ?? -1,
          onChanged: controller.useFlexColorScheme
              ? (int index) {
                  if (index < 0 || index >= VisualDensityEnum.values.length) {
                    controller.setUsedVisualDensity(null);
                  } else {
                    controller
                        .setUsedVisualDensity(VisualDensityEnum.values[index]);
                  }
                }
              : null,
        ),
        SwitchListTile(
          title: const Text('Use component sub themes'),
          value: controller.useSubThemes && controller.useFlexColorScheme,
          onChanged:
              controller.useFlexColorScheme ? controller.setUseSubThemes : null,
        ),
        const Divider(),
        SwitchListTileReveal(
          title: const Text('Use M2 style divider in M3'),
          subtitleDense: true,
          subtitle: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  style: spanTextStyle,
                  text: 'In Material-3 the primary color tinted outlineVariant '
                      'Divider may not fit on all background colors. The '
                      'Material-2 style based on black or white, with opacity, '
                      'always fits. It is also less prominent than the M3 '
                      'style and may be preferred. In Flutter 3.3 to at least '
                      '3.10, the Divider color also has theming '
                      'inconsistencies, it gets different colors depending on '
                      'used ThemeData constructor. For more information see ',
                ),
                LinkTextSpan(
                  style: linkStyle,
                  uri: _fcsFlutterIssue117755,
                  text: 'issue #117755',
                ),
                TextSpan(
                  style: spanTextStyle,
                  text: '. FCS fixes this issue, but if you do not use FCS, '
                      'it is a theming issue to be aware of.\n',
                ),
              ],
            ),
          ),
          value: controller.useM2StyleDividerInM3 &&
              controller.useSubThemes &&
              controller.useMaterial3 &&
              controller.useFlexColorScheme,
          onChanged: controller.useSubThemes &&
                  controller.useFlexColorScheme &&
                  controller.useMaterial3
              ? controller.setUseM2StyleDividerInM3
              : null,
        ),
        SwitchListTileReveal(
          title: const Text('Tinted disabled components'),
          subtitleDense: true,
          subtitle: const Text(
            'Disabled controls get a slight primary color '
            'tint or tint of its own color, if it is not primary colored. '
            'Turn OFF for Flutter grey defaults. '
            'Impacts ThemeData disabledColor, but also disabled state color on '
            'all individual components. Material-3 UI components typically '
            'ignore the ThemeData disabledColor. Their disabled styling is '
            'defined on component themes. This setting applies tinted '
            'disabled style on all components that support it.\n',
          ),
          value: controller.tintedDisabledControls &&
              controller.useSubThemes &&
              controller.useFlexColorScheme,
          onChanged: controller.useSubThemes && controller.useFlexColorScheme
              ? controller.setTintedDisabledControls
              : null,
        ),
        SwitchListTileReveal(
          title: const Text('Tinted interactions'),
          subtitleDense: true,
          subtitle: const Text(
            'Hover, focus, highlight, pressed and splash '
            'colors get a slight primary color tint, or tint of its '
            'own color, if it is not primary colored. '
            'Turn OFF for Flutter grey defaults. '
            'Impacts ThemeData hover, focus, highlight and splash colors. '
            'Material-3 components implement their own interaction '
            'effects. This setting also styles all of them on component theme '
            'level. Most components are covered, a few cases may not be fully '
            'supported due to lack of support in the Flutter framework. Their '
            'later inclusion in this setting will be reported as new features, '
            'not as style breaking.\n',
          ),
          value: controller.interactionEffects &&
              controller.useSubThemes &&
              controller.useFlexColorScheme,
          onChanged: controller.useSubThemes && controller.useFlexColorScheme
              ? controller.setInteractionEffects
              : null,
        ),
        const Divider(),
        ListTileReveal(
          enabled: controller.useSubThemes && controller.useFlexColorScheme,
          title: const Text('Border width'),
          subtitleDense: true,
          subtitle: const Text('Default border width for InputDecorator, '
              'OutlinedButton, ToggleButtons and SegmentedButton.\n'),
        ),
        ListTile(
          enabled: controller.useSubThemes && controller.useFlexColorScheme,
          title: Slider(
            min: 0,
            max: 5,
            divisions: 10,
            label: controller.useSubThemes && controller.useFlexColorScheme
                ? controller.thinBorderWidth == null ||
                        (controller.thinBorderWidth ?? 0) <= 0
                    ? 'default 1'
                    : (controller.thinBorderWidth?.toStringAsFixed(1) ?? '')
                : 'default 1',
            value: controller.useSubThemes && controller.useFlexColorScheme
                ? controller.thinBorderWidth ?? 0
                : 0,
            onChanged: controller.useSubThemes && controller.useFlexColorScheme
                ? (double value) {
                    controller.setThinBorderWidth(value <= 0 ? null : value);
                  }
                : null,
          ),
          trailing: Padding(
            padding: const EdgeInsetsDirectional.only(end: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'WIDTH',
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  controller.useSubThemes && controller.useFlexColorScheme
                      ? controller.thinBorderWidth == null ||
                              (controller.thinBorderWidth ?? 0) < 0
                          ? controller.useMaterial3
                              ? 'default 1' // M3
                              : 'default 1' // M2
                          : (controller.thinBorderWidth?.toStringAsFixed(1) ??
                              '')
                      : 'default 1',
                  style: theme.textTheme.bodySmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        ListTileReveal(
          enabled: controller.useSubThemes && controller.useFlexColorScheme,
          title: const Text('Thick border width'),
          subtitleDense: true,
          subtitle: const Text('Default border width for focused '
              'InputDecorator and pressed or error OutlinedButton.\n'),
        ),
        ListTile(
          enabled: controller.useSubThemes && controller.useFlexColorScheme,
          title: Slider(
            min: 0,
            max: 5,
            divisions: 10,
            label: controller.useSubThemes && controller.useFlexColorScheme
                ? controller.thickBorderWidth == null ||
                        (controller.thickBorderWidth ?? 0) < 0
                    ? useMaterial3
                        ? 'default 1'
                        : 'default 2'
                    : (controller.thickBorderWidth?.toStringAsFixed(1) ?? '')
                : 'default 1',
            value: controller.useSubThemes && controller.useFlexColorScheme
                ? controller.thickBorderWidth ?? 0
                : 0,
            onChanged: controller.useSubThemes && controller.useFlexColorScheme
                ? (double value) {
                    controller.setThickBorderWidth(value <= 0 ? null : value);
                  }
                : null,
          ),
          trailing: Padding(
            padding: const EdgeInsetsDirectional.only(end: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'WIDTH',
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  controller.useSubThemes && controller.useFlexColorScheme
                      ? controller.thickBorderWidth == null ||
                              (controller.thickBorderWidth ?? 0) <= 0
                          ? useMaterial3
                              ? 'default 1'
                              : 'default 2'
                          : (controller.thickBorderWidth?.toStringAsFixed(1) ??
                              '')
                      : 'default 1',
                  style: theme.textTheme.bodySmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const Divider(),
        SplashTypePopupMenu(
          title: const Text('Ink splash effect'),
          subtitle: const Text(
            'Defines the type of tap ink splash effect used on Material '
            'UI components.\n',
          ),
          index: controller.splashType?.index ?? -1,
          onChanged: controller.useFlexColorScheme && controller.useSubThemes
              ? (int index) {
                  if (index < 0 || index >= SplashTypeEnum.values.length) {
                    controller.setSplashType(null);
                  } else {
                    controller.setSplashType(SplashTypeEnum.values[index]);
                  }
                }
              : null,
        ),
        SplashTypePopupMenu(
          title: const Text('Adaptive ink splash effect'),
          subtitle: const Text(
            'Defines the type of tap ink splash effect used on Material '
            'UI components when running on below selected platforms. When not '
            'on running on these platforms or the if the platform adaptive ink '
            'feature is OFF, the ink splash effect above is used.\n',
          ),
          index: controller.splashTypeAdaptive?.index ?? -1,
          onChanged: controller.useFlexColorScheme &&
                  controller.useSubThemes &&
                  controller.adaptiveSplash != AdaptiveTheme.off &&
                  controller.adaptiveSplash != null
              ? (int index) {
                  if (index < 0 || index >= SplashTypeEnum.values.length) {
                    controller.setSplashTypeAdaptive(null);
                  } else {
                    controller
                        .setSplashTypeAdaptive(SplashTypeEnum.values[index]);
                  }
                }
              : null,
        ),
        const Divider(),
        const ListTileReveal(
          title: Text('Platform adaptive behavior'),
          // subtitleDense: true,
          subtitle: Text('With platform adaptive settings you can modify theme '
              'properties to have a different response on selected platforms. '
              'You can select which platforms the platform adaptive value '
              'should be used on. All other platforms not included '
              'in this choice, will continue to use the none adaptive '
              'value or default behavior.\n'
              '\n'
              'Using the API you can customize which platform an adaptive '
              'feature is used on, including separate definitions when using '
              'the app in a web build on each platform. The selections here '
              'use built-in combinations, they cover most use cases.'),
        ),
        AdaptiveThemePopupMenu(
          title: const Text('Platform adaptive ink splash'),
          subtitle: const Text(
            'An adaptive theme response used to select a different ink '
            'splash effect on selected platforms.\n',
          ),
          index: controller.adaptiveSplash?.index ?? -1,
          onChanged: controller.useFlexColorScheme && controller.useSubThemes
              ? (int index) {
                  if (index < 0 || index >= AdaptiveTheme.values.length) {
                    controller.setAdaptiveSplash(null);
                  } else {
                    controller.setAdaptiveSplash(AdaptiveTheme.values[index]);
                  }
                }
              : null,
        ),
        if (isLight) ...<Widget>[
          AdaptiveThemePopupMenu(
            title: const Text('Bring elevation shadows back'),
            subtitle: const Text(
              'An adaptive theme response to bring elevation shadows back in '
              'Material-3 in light theme mode on selected platforms. '
              'Has no impact in Material-2 mode. '
              'Applies to AppBar, BottomAppBar, BottomSheet, DatePickerDialog, '
              'Dialog, Drawer, NavigationBar, NavigationDrawer.\n',
            ),
            index: controller.adaptiveElevationShadowsBackLight?.index ?? -1,
            onChanged: controller.useFlexColorScheme &&
                    controller.useSubThemes &&
                    controller.useMaterial3
                ? (int index) {
                    if (index < 0 || index >= AdaptiveTheme.values.length) {
                      controller.setAdaptiveElevationShadowsBackLight(null);
                    } else {
                      controller.setAdaptiveElevationShadowsBackLight(
                          AdaptiveTheme.values[index]);
                    }
                  }
                : null,
          ),
          AdaptiveThemePopupMenu(
            title: const Text('Remove elevation tint'),
            subtitle: const Text(
              'An adaptive theme response to remove elevation tint on elevated '
              'surfaces in Material-3 in light theme mode on selected '
              'platforms. This is not recommended unless shadows are also '
              'brought back. '
              'This setting has no impact in Material-2 mode. '
              'Applies to BottomAppBar, BottomSheet, Card, Chip, '
              'DatePickerDialog, Dialog, Drawer, DropdownMenu, MenuBar, '
              'MenuAnchor, NavigationBar, NavigationDrawer, PopupMenuButton.\n',
            ),
            index: controller.adaptiveRemoveElevationTintLight?.index ?? -1,
            onChanged: controller.useFlexColorScheme &&
                    controller.useSubThemes &&
                    controller.useMaterial3
                ? (int index) {
                    if (index < 0 || index >= AdaptiveTheme.values.length) {
                      controller.setAdaptiveRemoveElevationTintLight(null);
                    } else {
                      controller.setAdaptiveRemoveElevationTintLight(
                          AdaptiveTheme.values[index]);
                    }
                  }
                : null,
          ),
        ] else ...<Widget>[
          AdaptiveThemePopupMenu(
            title: const Text('Bring elevation shadows back'),
            subtitle: const Text(
              'An adaptive theme response to bring elevation shadows back in '
              'Material-3 in dark theme mode on selected platforms. '
              'Has no impact in Material-2 mode. '
              'Applies to AppBar, BottomAppBar, BottomSheet, DatePickerDialog, '
              'Dialog, Drawer, NavigationBar, NavigationDrawer.\n',
            ),
            index: controller.adaptiveElevationShadowsBackDark?.index ?? -1,
            onChanged: controller.useFlexColorScheme &&
                    controller.useSubThemes &&
                    controller.useMaterial3
                ? (int index) {
                    if (index < 0 || index >= AdaptiveTheme.values.length) {
                      controller.setAdaptiveElevationShadowsBackDark(null);
                    } else {
                      controller.setAdaptiveElevationShadowsBackDark(
                          AdaptiveTheme.values[index]);
                    }
                  }
                : null,
          ),
          AdaptiveThemePopupMenu(
            title: const Text('Remove elevation tint'),
            subtitle: const Text(
              'An adaptive theme response to remove elevation tint on elevated '
              'surfaces in Material-3 in dark theme mode on selected '
              'platforms. This is not recommended in dark mode, unless '
              'shadows are also brought back. However, even then it is bad '
              'idea since shadows are not very visible in dark mode. Recommend '
              'keeping elevation tint in M3 mode in dark mode. You can '
              'still bring shadows back in dark mode, it can further increase '
              'elevation separation in dark mode. '
              'This setting sas no impact in Material-2 mode. '
              'Applies to BottomAppBar, BottomSheet, Card, Chip, '
              'DatePickerDialog, Dialog, Drawer, DropdownMenu, MenuBar, '
              'MenuAnchor, NavigationBar, NavigationDrawer, PopupMenuButton.\n',
            ),
            index: controller.adaptiveRemoveElevationTintDark?.index ?? -1,
            onChanged: controller.useFlexColorScheme &&
                    controller.useSubThemes &&
                    controller.useMaterial3
                ? (int index) {
                    if (index < 0 || index >= AdaptiveTheme.values.length) {
                      controller.setAdaptiveRemoveElevationTintDark(null);
                    } else {
                      controller.setAdaptiveRemoveElevationTintDark(
                          AdaptiveTheme.values[index]);
                    }
                  }
                : null,
          ),
        ],
        const Divider(),
        PlatformPopupMenu(
          platform: controller.platform,
          onChanged: controller.setPlatform,
        ),
        IsWebListTile(controller: controller),
        BackToActualPlatform(controller: controller),
        const Divider(),
        const ComponentColorsReveal(),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: ShowSubThemeColors(showTitle: false),
        ),
      ],
    );
  }
}
