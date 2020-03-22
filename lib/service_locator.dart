import 'package:flutterroad/services/localstorge_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future setupLocator() async {
  final localStorage = await LocalStorageService.getInstance();
  getIt.registerSingleton<LocalStorageService>(localStorage);
}