# flutter_remote_control

主要使用`LongPressDraggable`与`DragTarget`实现的万能遥控器交互效果。

Android 原生实现版本：[RemoteControlView](https://github.com/simplezhli/RemoteControlView)

## 实现效果

| 单指 | 多指 |
| :---------------------------: | :-----------------------------: |
| ![Preview](./preview/preview.gif)    |  ![Preview1](./preview/preview1.gif)    |

## 实现过程

flutter 1.20 在`DragTarget`新增`onAcceptWithDetails`回调，目前对于本项目实现无作用。还是需要去修改源码实现。。。

发现flutter 2.0.0 在`Draggable`新增`onDragUpdate`回调、`DragTarget`新增`onMove`回调，基本可以满足此项目使用，但无法实现二次拖动。还是需要去修改源码实现。。。

修改源码部分有TODO标记，感兴趣可自行查看。

[玩玩Flutter的拖拽——实现一款万能遥控器](https://weilu.blog.csdn.net/article/details/105237677)

## License

	Copyright 2020 simplezhli

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

