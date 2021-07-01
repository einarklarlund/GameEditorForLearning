import QtQuick 2.0
import Felgo 3.0
import "../../common"

DialogBase {
  id: renameLevelDialog

  property var levelName

  Text {
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: 100

    text: "There is already a level with the name " + levelName + ". Please enter a different name."

    color: "white"
  }

  // Buttons ------------------------------------------

  PlatformerTextButton {
    id: okButton

    screenText: "ok"

    width: 175

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 50

    // when clicking "ok" we only close the dialog and return to
    // the editor
    onClicked: renameLevelDialog.opacity = 0
  }
}

