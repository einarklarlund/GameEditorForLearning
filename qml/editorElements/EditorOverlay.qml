import Felgo 3.0
import QtQuick 2.0
import "../common"
import "../undo"
import "../scenes/dialogs"
import "EditorLogic.js" as EditorLogic

Item {
  id: editorOverlay

  // make components accessible from the outside
  property alias grid: grid
  property alias sidebar: sidebar
  property alias itemEditor: itemEditor
  property alias undoHandler: undoHandler

  // holds the currently selected BuildEntityButton
  property var selectedButton

  // this is the gameScene, over which this overlay is put
  // by default this is this item's parent
  property var scene: parent

  // makes accessing the gameScene's container easier
  property var containerComponent: scene.container

  // keeps track of the name of the last level that was opened in edit mode
  property var currentlyEditing

  property bool editingNewLevel: true

  property string nameOfOpenedLevel

  // this switches between true and false, if the user clicks the itemEditorButton
  property bool itemEditorVisible: false

  property bool inEditMode: false
  visible: false

  anchors.fill: scene.gameWindowAnchorItem

  EditorGrid {
    id: grid

    visible: inEditMode

    container: containerComponent
  }

  /**
   * SIDEBAR --------------------------------------
   */
  Sidebar {
    id: sidebar

    visible: inEditMode

    // set all components, that can be accessed in the sidebar
    bgImage: scene.bgImage
    grid: grid
    undoHandler: undoHandler
  }

  /**
   * Item editor ----------------------------------
   */
  // item editor for balancing the game
  ItemEditor {
    id: itemEditor

    // invisible by default
    visible: false

    anchors.right: parent.right
    anchors.top: topbar.bottom
    anchors.bottom: parent.bottom

    opacity: 0.9
  }

  // button to show/hide itemEditor
  PlatformerTextButton {
    id: itemEditorButton

    screenText: itemEditorVisible ? ">" : "<"

    width: 12

    // if the item editor is visible, anchor this button to the left of the editor;
    // otherwise anchor it to the game window
    anchors.right: itemEditor.visible ? itemEditor.left : parent.right
    anchors.verticalCenter: parent.verticalCenter

    onClicked: {
      itemEditor.visible = !itemEditor.visible
    }
  }

  /**
   * TOP BAR --------------------------------------
   */

  // this button enables switching between edit and test mode
  PlatformerImageButton {
    id: testButton

    width: 50
    height: 30

    visible: false

    // place on top, centered
    anchors.horizontalCenter: editorOverlay.horizontalCenter
    anchors.top: editorOverlay.top

    // set image source, depending on if we're in edit mode
    image.source: inEditMode ? "../../assets/ui/play.png" : "../../assets/ui/edit.png"

    // set opacity to 0.5 when in test mode, to be less distracting
    opacity: inEditMode ? 1 : 0.5

    // set game state depending on current game state
    onClicked: {
      if(inEditMode) {
        scene.state = "test"
      }
      else
        scene.state = "edit"
    }
  }

  // this row holds the buttons in the top right corner
  Row {
    id: topbar

    visible: inEditMode

    height: 30

    anchors.right: editorOverlay.right
    anchors.top: editorOverlay.top

    spacing: 4

    // save level button
    PlatformerImageButton {
      id: saveButton

      width: 40

      image.source: "../../assets/ui/save.png"

      onClicked: {
        // there should be only level by the name levelName in the authorGenerated levels.
        // if there is more than one, the user is saving the current level with the same name as
        // a level that already exists
       let nameMatches = 0;

        // show renameLevelDialog and don't save if the current level name isn't unique
        if(!isCurrentLevelNameUnique()) {
          renameLevelDialog.levelName = levelEditor.currentLevelName;
          renameLevelDialog.opacity = 1;
          return;
        }

        // set nameOfOpenedLevel to the current level name if the current level
        // was opened from the
        if(nameOfOpenedLevel == "new level from new level button") {
          nameOfOpenedLevel = levelEditor.currentLevelName;
        }

        // save level
        saveLevel()

        // show saved text
        savedTextAnimation.restart()
      }

      // this text signals, that the level has been saved
      Text {
        // text and text color
        text: "saved"
        color: "#ffffff"

        // by default this text is opaque/invisible
        opacity: 0

        // anchor to the bottom of the save button
        anchors.top: saveButton.bottom

        // outline the text, to increase it's visibility
        style: Text.Outline
        styleColor: "#009900"

        // this animation shows and slowly fades out the save text
        NumberAnimation on opacity {
          id: savedTextAnimation

          // slowly reduce opacity from 1 to 0
          from: 1
          to: 0

          // duration of the animation, in ms
          duration: 2000
        }
      }
    }

    // back to menu button
    PlatformerImageButton {
      id: menuButton

      width: 40

      image.source: "../../assets/ui/home.png"

      // open save dialog when in edit mode
      onClicked: saveLevelDialog.opacity = 1
    }
  }

  /**
   * MISC
   */

  // for handling undo and redo
  UndoHandler {
    id: undoHandler
  }

  /**
   * DIALOGS
   */

  // this is the save dialog that pops up, when the user clicks
  // the backButton in edit mode
  SaveLevelDialog {
    id: saveLevelDialog
  }

  PublishDialog {
    id: publishDialog
  }

  RenameLevelDialog {
      id: renameLevelDialog
  }

  /**
   * JAVASCRIPT FUNCTIONS --------------------------------------
   */
  // handles the clicking of an entity
  function clickEntity(entity) {
    EditorLogic.clickEntity(entity);
  }

  // if entity is removable: remove entity and return the undoObject of this action
  function removeEntity(entity) {
    return EditorLogic.removeEntity(entity);
  }

  // returns the top-left coordinate of the grid the mouse is in
  function getMouseGridPos(mouseX, mouseY) {
    return EditorLogic.getMouseGridPos(mouseX, mouseY);
  }

  // This function checks, if there is a body in the 32x32 area
  // below/right the position parameter. We use this to make sure
  // there isn't already an entity at the position where we want
  // to create a new one.
  // The position parameter is the top-left point of the checked
  // area.
  // Returns true, if there is a body in this area;
  // false else.
  function isBodyIn32Grid(position) {
    return EditorLogic.isBodyIn32Grid(position);
  }

  // place a new object and return it
  function placeEntityAtPosition(mouseX, mouseY) {
    return EditorLogic.placeEntityAtPosition(mouseX, mouseY);
  }

  // converts mouse coordinates to level coordinates
  // return point with level coordinates
  function mouseToLevelCoordinates(mouseX, mouseY) {
    return EditorLogic.mouseToLevelCoordinates(mouseX, mouseY);
  }

  // calculates the grid coordinates of the grid the position (levelX, levelY) is in
  function snapToGrid(levelX, levelY) {
    return EditorLogic.snapToGrid(levelX, levelY);
  }

  // saves the current level
  function saveLevel() {
    EditorLogic.saveLevel();
  }

  function initEditor() {
    EditorLogic.initEditor();
  }

  function resetEditor() {
    EditorLogic.resetEditor();
  }

  // returns true if the currently opened level should be renamed.
  // the currently opened level should be renamed if its levelName isn't unique.
  function isCurrentLevelNameUnique() {
      // if there are no authorGeneratedLevels, then the current level name must be unique
      if(levelEditor.authorGeneratedLevels == undefined && levelEditor.authorGeneratedLevels == null)
        return true;

      var editingNewLevel = false;
      var openedLevelWasRenamed = false;

      // if nameOfOpenedLevel has been set to "new level from new level button",
      // then the user has clicked the new level button and we're not re-editing
      // an old level
      if(nameOfOpenedLevel == "new level from new level button") {
        editingNewLevel = true;
        openedLevelWasRenamed = false;
      }
      else {
        // otherwise, the user is not editing a new level
        editingNewLevel = false;
        // if the name of the opened level is different from the currentLevelName,
        // then the opened level has been renamed while the levelEditor was opened
        openedLevelWasRenamed = nameOfOpenedLevel != levelEditor.currentLevelName;
      }

      // if we're editing a new level or we're editing an old level that has been renamed,
      // then we need to check if there are any other levels with the same name
      if(editingNewLevel || openedLevelWasRenamed) {
         for(let i = 0; i < levelEditor.authorGeneratedLevels.length; ++i) {
             // if we find a level with the same name as the current level name,
             // then the current level name is not unique
             if(levelEditor.authorGeneratedLevels[i].levelName == levelEditor.currentLevelName) {
                 return false;
             }
         }
      }

      // return false if no other levels with the same name were found or if
      // the user is overwriting a level that hasn't been renamed
      return true;
  }
}
