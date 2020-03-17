// import 'package:hive/hive.dart';
// import 'package:instagram/core/db/adapters/image.dart';
// import 'package:instagram/core/db/objects/images.dart';

// class HiveImages {
//   var box;
//   var boxName = 'images';
//   HiveImages() {
//     init();
//   }

//   init() async {
//     Hive.registerAdapter(ImageAdapter());
//     this.box = await Hive.openBox<Image>(this.boxName);
//   }

//   clear() {
//     this.box.clear();
//   }
// }
