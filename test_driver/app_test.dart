// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:screenshots/screenshots.dart';
import 'package:test/test.dart';

void main() {
  group('Screens', () {
    final settingsIcon = find.byValueKey('settings');
    final searchTabButton = find.text('Search');
    final homeTabButton = find.text('Home');
    final darkModeSwitch = find.byType('Switch');

    // Screenshot config
    final config = Config();

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Scr home light', () async {
      await Future.delayed(const Duration(seconds: 2), (){});
      await screenshot(driver, config, 'HomeScrLight');
    });

    test('Navigate & screenshot search light', () async {
      await driver.tap(searchTabButton);
      await screenshot(driver, config, 'SearchScrLight');
    });

    test('Search for novel & screenshot light', () async {
      final searchBarTextField = find.byType('TextField');
      await driver.tap(searchBarTextField);
      // await driver.setTextEntryEmulation(enabled: true);
      await driver.enterText('Data');
      await Future.delayed(const Duration(seconds: 2), (){});
      await screenshot(driver, config, 'SearchScrResultLight');
    });

    test('Navigate & screenshot settings light', () async {
      await driver.tap(settingsIcon);
      await screenshot(driver, config, 'SettingsScrLight');
    });

    test('Go to dark mode & screenshot settings', () async {
      await driver.tap(darkModeSwitch);
      await screenshot(driver, config, 'SettingsScrDark');
    });

    test('Search for novel & screenshot dark', () async {
      final backButtonAppBar = find.byTooltip('Back');
      await driver.tap(backButtonAppBar);
      // Already typed from before, so don't need to
      await screenshot(driver, config, 'SearchScrResultDark');
    });

    test('Navigate to search & screenshot dark', () async {
      // Cancel search to get to default screen
      final cancelButton = find.text('Cancel');
      await driver.tap(cancelButton);
      // On Android, this screenshot does not look good due to
      // the textfield being focused
      await screenshot(driver, config, 'SearchScrDark');
    });

    test('Navigate home & screenshot dark', () async {
      await driver.tap(homeTabButton);
      await screenshot(driver, config, 'HomeScrDark');
    });
    /*
    test('', () async {

    });
    */

  });
}
