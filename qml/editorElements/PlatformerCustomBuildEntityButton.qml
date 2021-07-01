import QtQuick 2.0
import Felgo 3.0
import "../common/"

BuildEntityButton {

  // width and height of the button
  property int buttonSize: 32

  // this property is true, when the button is selected
  property bool isSelected: false

  property var index

    property var customConfiguration

  // set size
  width: buttonSize
  height: buttonSize

  anchors.horizontalCenter: parent.horizontalCenter

  // set initialEntityPosition to a point outside the level
  initialEntityPosition: Qt.point(-100, 0)

  // set variationType to the variationType of the createdEntity
  variationType: createdEntity ? createdEntity.variationType : ""

  // these signals are emitted when the button gets selected/unselected
  signal selected
  signal unselected

  // bind the information for the custom items, so that they load whenever the signal customItemManager.itemsLoaded goes off
  Binding on customConfiguration {
      when: customItemManager.itemsLoaded
      value: customItemManager.isItemLoadedAt(index) ?
                 customItemManager.getCustomConfigurationAt(index) :
                 null
  }

  Binding on toCreateEntityTypeUrl {
      when: customItemManager.itemsLoaded
      value: customItemManager.isItemLoadedAt(index) ?
                 customItemManager.getEntityUrlAt(index) :
                 Qt.resolvedUrl("./PlatformerEntityBaseDraggable.qml")

//      value: customItemManager.getEntityUrlAt(index)
  }

  creationProperties: {
        "customImageSource": customConfiguration != undefined ? customConfiguration.imageSource : "",
        "width": customConfiguration != undefined ? customConfiguration.width : 32,
        "height": customConfiguration != undefined ? customConfiguration.height : 32,
        "isCustomized": true,
        "customIndex": index,
        "ignoreBounds": true
    }

    IconButton {
      id: deleteButton

      anchors.rightMargin: 5
      anchors.right: parent.left
      anchors.verticalCenter: parent.verticalCenter

      width: parent.width * 2 / 3
      height: parent.height * 2 / 3

      icon: IconType.remove
//      image.source: "../../assets/ui/deletebutton.png"

      onClicked: {
          customItemManager.removeItem(index);
      }
  }

    // PlatformerImageButton {
    //   id: debugButton

    //   anchors.rightMargin: 5
    //   anchors.right: deleteButton.left
    //   anchors.verticalCenter: deleteButton.verticalCenter

    //   width: parent.width / 2
    //   height: parent.height / 2

    //   image.source: "../../assets/ui/deletebutton.png"

    //   onClicked: {
    //     console.log(JSON.stringify(customConfiguration));
    //     console.log(toCreateEntityTypeUrl);
    //     console.log(buttonImage.source);
    //   }
    // }

  // if this button is selected, this rectangle emphasizes this
  Rectangle {
    id: selectedRectangle

    // only visible if the button is selected
    visible: isSelected

    // make it a little larger than the actual button
    width: parent.width + 8
    height: parent.height + 8

    // center this in the button
    anchors.centerIn: parent

    radius: 3

    // set color to white
    color: "white"
  }

  // this rectangle adds a grey background to the entity image,
  // this improves the visibility of part transparent entities
  Rectangle {
    id: background

    anchors.fill: buttonImage

    radius: 3

    color: "#a0b0b0b0"
  }

  // the image of the entity
  MultiResolutionImage {
    id: buttonImage

    source: createdEntity ?
                (customItemManager.isItemLoadedAt(index) ?
                     customItemManager.getCustomConfigurationAt(index).imageSource : createdEntity.image.source) : ""

    // increase buttonImage size, when button is selected
    width: isSelected ? 36 : 32
    height: isSelected ? 36 : 32

    anchors.centerIn: parent
  }

  onClicked: {
    // toggle isSelected
    isSelected = !isSelected

    // if the button is now selected, emit the selected signal
    if(isSelected)
      selected()
    else
      unselected()
  }

  onEntityWasBuilt: {
    // get built entity by it's id
    var builtEntity = entityManager.getEntityById(builtEntityId)

    // if buildEntity exists...
    if(builtEntity) {
      // ...add undoObject to undoHandler
      var undoObjectProperties = {"target": builtEntity, "action": "create",
        "currentPosition": Qt.point(builtEntity.x, builtEntity.y), "customConfiguration": customConfiguration}
      var undoObject = editorOverlay.undoHandler.createUndoObject(undoObjectProperties)
      editorOverlay.undoHandler.push([undoObject])

      // set custom image and custom size
      builtEntity.image.source = customConfiguration.imageSource;
      builtEntity.image.width = customConfiguration.width;
      builtEntity.image.height = customConfiguration.height;
      
      // Register the entity's custom configuration to the customItemManager.
      // if it was already registered, the registration will be overwritten.
      customItemManager.registerCustomItem(builtEntityId);      
    }
  }

  /**
    * JS FUNCITONS
    */
}

