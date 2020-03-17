
import 'package:flutter/material.dart';
import 'package:flutter_remote_control/models/draggable_type.dart';

import '../models/draggable_info_model.dart';
import 'draggable_button.dart';

class DraggableButtonMenu extends StatefulWidget {
  
  const DraggableButtonMenu({
    Key key,
    this.index
  }): super(key: key);
  
  final int index;
  
  @override
  _DraggableButtonMenuState createState() => _DraggableButtonMenuState();
}

class _DraggableButtonMenuState extends State<DraggableButtonMenu> {

  List _img1 = ['assets/svg_new_close.png', 'assets/svg_new_home.png', 'assets/offered_exit.png', 
    'assets/svg_new_back.png', 'assets/svg_new_setting.png', 'assets/svg_new_source.png', 'Text', 
    'assets/offered_menu.png', 'assets/offered_out.png', 'assets/offered_mute.png'
  ];

  List _img2 = ['assets/offered_play.png', 'assets/offered_stop.png', 'assets/offered_pause.png',
    'assets/offered_pause2.png', 'assets/offered_previous.png', 'assets/offered_next.png', 'assets/offered_backward.png',
    'assets/offered_forward.png', 'assets/offered_height.png', 'assets/offered_width.png'
  ];

  List<DraggableInfo> _list;

  @override
  void initState() {
    super.initState();
    // 初始化不同菜单的按键信息
    if (widget.index == 0) {
      _list = List.generate(_img1.length, (index) {
        String id = '${widget.index}$index';
        if (_img1[index] == 'Text') {
          return DraggableInfo(id, 'Text', '', DraggableType.text);
        }
        return DraggableInfo(id, '', _img1[index], DraggableType.imageOneToOne);
      });
    } else if (widget.index == 1) {
      _list = List();
      _list.add(DraggableInfo('${widget.index}0', '', 'assets/offered_cursor.png', DraggableType.imageThreeToThree));
      _list.add(DraggableInfo('${widget.index}1', '', 'assets/offered_channel.png', DraggableType.imageOneToTwo));
      _list.add(DraggableInfo('${widget.index}2', '', 'assets/offered_vol.png', DraggableType.imageOneToTwo));
      _list.add(DraggableInfo('${widget.index}3', '', 'assets/offered_playloop.png', DraggableType.imageOneToOne));
      _list.add(DraggableInfo('${widget.index}4', '', 'assets/offered_random.png', DraggableType.imageOneToOne));
    } else if (widget.index == 2) {
      _list = List.generate(_img2.length, (index) {
        String id = '${widget.index}$index';
        return DraggableInfo(id, '', _img2[index], DraggableType.imageOneToOne);
      });
    } else if (widget.index == 3) {
      _list = List.generate(10, (index) {
        String id = '${widget.index}$index';
        return DraggableInfo(id, '$index', '', DraggableType.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.index == 1 ? menu : GridView.builder(
        itemCount: _list.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 1
        ),
        itemBuilder: (_, index) {
          return DraggableButton(data: _list[index]);
        }
    );
  }
  
  get menu => Container(
    padding: const EdgeInsets.only(bottom: 20),
    child: Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: DraggableButton(data: _list[0])
        ),
        Expanded(
          child: DraggableButton(data: _list[1])
        ),
        Expanded(
          child: DraggableButton(data: _list[2])
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              DraggableButton(data: _list[3]),
              DraggableButton(data: _list[4])
            ],
          ),
        )
      ],
    ),
  );
}
