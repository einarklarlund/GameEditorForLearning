import QtQuick 2.0
import Felgo 3.0
import "../../common"

DialogBase {
  id: removeLevelDialog

  Text {
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: 100

    text: "What do you want to do?"

    color: "white"
  }

  // Buttons ------------------------------------------

  PlatformerTextButton {
    id: saveAndExitButton

    screenText: "Save and Exit"

    width: 175

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 150

    onClicked: {
      // there should be only level by the name levelName in the authorGenerated levels.
      // if there is more than one, the user is saving the current level with the same name as
      // a level that already exists
      let nameMatches = 0;
      for(let i = 0; i < levelEditor.authorGeneratedLevels.length; ++i) {
          nameMatches += levelEditor.authorGeneratedLevels[i].levelName === levelEditor.currentLevelName ? 1 : 0;
        //  console.log("found a name match. levelBeingEdited is " + levelBeingEdited + " and levelEditor.currentLevelName is " + levelEditor.currentLevelName);
          if(((levelBeingEdited != levelEditor.currentLevelName) || levelBeingEdited == "newLevel") && nameMatches > 0) {
              renameLevelDialog.levelName = levelEditor.currentLevelName;
              renameLevelDialog.opacity = 1;
            //  console.log("cannot saved level " + levelEditor.currentLevelName + ". editingNewLevel is " + editingNewLevel);
              return;
          }
      }

      // when clicking "save and exit" the level gets saved, we
      // emit the gameScene's backPressed signal and close the dialog
      editorOverlay.saveLevel()
      editorOverlay.scene.backPressed()

      removeLevelDialog.opacity = 0
    }
  }

  PlatformerTextButton {
    id: discardAndExitButton

    screenText: "Exit"

    width: 175

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 100

    onClicked: {
      // when clicking "exit" we only emit the gameScene's backPressed
      // signal and close the dialog
      editorOverlay.scene.backPressed()

      removeLevelDialog.opacity = 0
    }
  }

  PlatformerTextButton {
    id: cancelButton

    screenText: "Cancel"

    width: 175

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 50

    // when clicking "exit" we only close the dialog and return to
    // the editor
    onClicked: removeLevelDialog.opacity = 0
  }
}

