import QtQuick 2.0

Item {

  property real size

  property string icon

  property string selectedIcon

  property color color

  property color selectedColor

  property color disabledColor

  property bool toggle

  property bool selected

  signal pressed

  signal released

  signal clicked

  signal toggled

}
