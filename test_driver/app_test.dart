// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:screenshots/screenshots.dart';
import 'package:test/test.dart';

/*
Integration tests that make sure pages load and also does automatic screenshotting.

Workflow from light mode:

Home -> Search Empty -> Search completed -> Fiction -> Chapter ->
Tap (bring up options) -> Chapter comments -> Back x3 -> Settings ->
Settings go Dark Mode -> Back -> Home -> Cancel search -> Search completed ->
Fiction -> Chapter -> Tap (bring up options) -> Chapter comments
 */

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

    test('check flutter driver extension', () async {
      final health = await driver.checkHealth();
      print(health.status);
    });

    test('Screenshot home light', () async {
      await Future.delayed(const Duration(seconds: 2), () {});
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
      await Future.delayed(const Duration(seconds: 2), () {});
      await screenshot(driver, config, 'SearchScrResultLight');
    });

    test('Click novel result & screenshot', () async {
      final result = find.descendant(
          of: find.byType('StaggeredGridView'),
          matching: find.byType('InkWell'),
          firstMatchOnly: true);
      await driver.tap(result);
      await Future.delayed(const Duration(seconds: 2), () {});
      await screenshot(driver, config, 'FictionScrLight');
    });

    test('Click chapter & screenshot', () async {
      final chapter = find.byValueKey('chapterList_item_0');
      await driver.tap(chapter);
      await Future.delayed(const Duration(seconds: 2), () {});
      await screenshot(driver, config, 'ChapterScrTextLight');
    });

    test('Open chapter options & screenshot', () async {
      final html = find.byValueKey('chapter_contents');
      // tap taps on center, so have to move to center
      final center = await driver.getCenter(html);
      print(center.dx);
      print(center.dy);
      await driver.scroll(html, 0, -center.dy, Duration(seconds: 2));
      await driver.tap(html);
      await screenshot(driver, config, 'ChapterOptionsScrLight');
    });

    test('Chapter comments & screenshot', () async {
      final commentButton = find.byValueKey('chapter_comments_btn');
      await driver.tap(commentButton);
      await Future.delayed(const Duration(seconds: 2), () {});
      await screenshot(driver, config, 'ChapterCommentsScrLight');
    });

    test('Go back to main tabs', () async {
      await driver.tap(find.byTooltip('Back'));
      await driver.tap(find.byTooltip('Back'));
      await driver.tap(find.byTooltip('Back'));
    });

    test('Navigate & screenshot settings light', () async {
      await driver.tap(settingsIcon);
      await screenshot(driver, config, 'SettingsScrLight');
    });

    test('Go to dark mode & screenshot settings', () async {
      await driver.tap(darkModeSwitch);
      await screenshot(driver, config, 'SettingsScrDark');
    });

    // NOW IN DARK MODE

    test('Go back to home & screenshot', () async {
      await driver.tap(find.byTooltip('Back'));
      await driver.tap(homeTabButton);
      await screenshot(driver, config, 'HomeScrDark');
    });

    test('Cancel search & screenshot', () async {
      driver.tap(searchTabButton);
      // Cancel search to get to default screen
      final cancelButton = find.text('Cancel');
      await driver.tap(cancelButton);
      // On Android, this screenshot does not look good due to
      // the textfield being focused
      await screenshot(driver, config, 'SearchScrDark');
    });

    test('Search for novel & screenshot dark', () async {
      final searchBarTextField = find.byType('TextField');
      await driver.tap(searchBarTextField);
      // await driver.setTextEntryEmulation(enabled: true);
      await driver.enterText('Data');
      await Future.delayed(const Duration(seconds: 2), () {});
      await screenshot(driver, config, 'SearchScrResultDark');
    });

    test('Click novel result & screenshot dark', () async {
      final result = find.descendant(
          of: find.byType('StaggeredGridView'),
          matching: find.byType('InkWell'),
          firstMatchOnly: true);
      await driver.tap(result);
      await Future.delayed(const Duration(seconds: 2), () {});
      await screenshot(driver, config, 'FictionScrLight');
    });

    test('Click chapter & screenshot dark', () async {
      final chapter = find.byValueKey('chapterList_item_0');
      await driver.tap(chapter);
      await Future.delayed(const Duration(seconds: 2), () {});
      await screenshot(driver, config, 'ChapterScrTextLight');
    });

    // Rest go here after I fix options dialog bug

    /*
    test('', () async {

    });
    */
  });
}
