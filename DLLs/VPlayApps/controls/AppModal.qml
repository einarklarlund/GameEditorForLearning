import QtQuick 2.0
import QtGraphicalEffects 1.12
import Felgo 3.0

Item {
  id: modal

  property Item pushBackContent

  property bool fullscreen

  property real modalHeight

  property bool closeOnBackgroundClick

  property bool closeWithBackButton

  property color backgroundColor

  property color overlayColor

  property real overlayOpacity

  property color cornerClipColor

  property int openedStatusBarStyle

  signal opened()

  signal closed()

  function open() {}

  function close() {}
}
