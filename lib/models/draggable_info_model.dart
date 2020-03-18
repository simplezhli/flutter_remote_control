
import 'draggable_type.dart';

class DraggableInfo {

  String id;
  String text;
  String img;
  DraggableType type;
  double dx = 0;
  double dy = 0;

  DraggableInfo(this.id, this.text, this.img, this.type);
  
  setOffset(double dx, double dy) {
    this.dx = dx;
    this.dy = dy;
  }

  @override
  String toString() {
    return '$runtimeType(id: $id, text: $text, img: $img, type: $type, dx: $dx, dy: $dy)';
  }

}
