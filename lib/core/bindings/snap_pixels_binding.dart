import 'package:get/get.dart';
import '../controllers/snap_controllers/snap_pixels_controller.dart';

class SnapPixelsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SnapPixelsController>(() => SnapPixelsController(),
        fenix: true);
  }
}
