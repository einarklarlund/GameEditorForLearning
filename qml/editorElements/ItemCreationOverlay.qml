import QtQuick 2.0
import Felgo 3.0
import QtQuick.Controls 2.4
import "../common"

// this item is the overlay that displays options for item creation

Column {

    id: itemCreationOverlay

    // the savedItemOverlay is tightly coupled with the sidebar, which has the resposibility of instantiating the overlay
    // and controlling the overlay's visibility
    width: parent.width
    height: 300

    spacing: 5

    property int maxItems: 20

    property var tileVariatons: ["Grass", "Dirt", "Platform", "Spike Ball", "Spikes"]
    property var enemyVariatons: ["Jumper", "Walker"]
    property var powerUpVariatons: ["Coin", "Mushroom", "Star", "Finish"]

    /**
      * IMAGE COMPONENTS --------------------------------
      */

    // a button to prompt image selection
    PlatformerTextButton {
      id: selectImageButton
//      anchors.top: parent.top
      anchors.horizontalCenter: parent.horizontalCenter
      width: parent.width
      height: 25
      screenText: "Select an image"
      onClicked: {
        nativeUtils.displayImagePicker("test")
      }
    }

    // AppImage object that will store the image selected by the NativeUtils ImagePicker and preview it
    AppImage {
      id: image
//      anchors.top: selectImageButton.bottom
      anchors.horizontalCenter: parent.horizontalCenter
      width: 30
      height: 25
      // important to automatically rotate the image taken from the camera
      autoTransform: true
      fillMode: Image.PreserveAspectFit
    }

    // the connections bewteen the NativeUtils and AppImage
    Connections {
      target: nativeUtils
      onImagePickerFinished: {
        if(accepted) {
            image.source = path
        }
      }
    }

    /**
      * BEHAVIOUR COMPONENTS --------------------------------
      */

    // title for the behavior input
    Text {
        id: behaviourTitle
        text: "Behaviour:"
//        anchors.top: image.bottom
        anchors.topMargin: 3
        font.pointSize: 9
        // align text in the vertical center
        verticalAlignment: Text.AlignVCenter
    }

    // input for the behavior/type of the item
    ComboBox {
        id:behaviorInput
//        anchors.top: behaviourTitle.bottom
        width:parent.width
        height: 20
        indicator.width: 25
        indicator.height: 20
        font.pointSize: 7
        model: ["Tile", "Enemy", "Power Up"]
    }

    // title for the variant of the item
    Text {
        id: variantTitle
        text: "Variant:"
//        anchors.top: behaviorInput.bottom
        anchors.topMargin: 3
        font.pointSize: 9
        // align text in the vertical center
        verticalAlignment: Text.AlignVCenter
    }

    // input for the variant of the item
    ComboBox {
        id:variantInput
//        anchors.top: variantTitle.bottom
        width:parent.width
        height: 20
        indicator.width: 25
        indicator.height: 20
        font.pointSize: 7
        model: tileVariatons
    }

    // connections between behavior input and variant input
    Connections {
        target: behaviorInput
        onActivated: {
            if (behaviorInput.currentIndex == 0) {
                variantInput.model = tileVariatons
            }
            else if (behaviorInput.currentIndex == 1) {
                variantInput.model = enemyVariatons
            }
            else if (behaviorInput.currentIndex == 2) {
                variantInput.model = powerUpVariatons
            }
        }
    }

    /**
      * SIZE COMPONENTS --------------------------------
      */

    // title for the width input
    Text {
        id: widthTitle
        text: "Width:"
//        anchors.top: variantInput.bottom
        anchors.topMargin: 10
        font.pointSize: 9
        // align text in the vertical center
        verticalAlignment: Text.AlignVCenter
    }

    // input for width
    SpinBox {
        id: widthInput
//        anchors.top: widthTitle.bottom
        width:parent.width
        height: 20
        down.indicator.width: parent.width / 3
        up.indicator.width: parent.width / 3
        font.pointSize: 7.5
        from: 1
        to : 10
    }

    // title for the height input
    Text {
        id: heightTitle
        text: "Height:"
//        anchors.top: widthInput.bottom
        anchors.topMargin: 3
        font.pointSize: 9
        // align text in the vertical center
        verticalAlignment: Text.AlignVCenter
    }

    // input for height
    SpinBox {
        id: heightInput
//        anchors.top: heightTitle.bottom
        width:parent.width
        height: 20
        down.indicator.width: parent.width / 3
        up.indicator.width: parent.width / 3
        font.pointSize: 7.5
        from: 1
        to : 10
    }

    /**
      * SAVING COMPONENTS --------------------------------
      */

    // Clear all saved items button
    // PlatformerTextButton {
    //   id: clearButton
    //   screenText: "Clear all saved items"
    //   anchors.topMargin: 10
    //   anchors.horizontalCenter: parent.horizontalCenter
    //   width: parent.width * 0.8
    //   height: 25
    //   font.pixelSize: 7
    //   onClicked: {
    //       storage.setValue("customItems", undefined)
    //     }
    // }

    // Save button
    PlatformerTextButton {
      id: saveCustomItemButton
      screenText: "Save"
//      anchors.top: clearButton.bottom
      anchors.topMargin: 10
      width: parent.width
      height: 30
      onClicked: {
          // save the new item
          let customItems = storage.getValue("customItems");
          let itemUrl = "";

          customItems = (typeof customItems == "undefined") ? [] : customItems;

          if(customItems.length < maxItems) {
              if(behaviorInput.currentIndex == 0) {
                  if(variantInput.currentIndex == 0) {
                      itemUrl = "../entities/GroundGrass.qml";
                  }
                  else if(variantInput.currentIndex == 1) {
                      itemUrl = "../entities/GroundDirt.qml";
                  }
                  else if(variantInput.currentIndex == 2) {
                      itemUrl = "../entities/Platform.qml";
                  }
                  else if(variantInput.currentIndex == 3) {
                      itemUrl = "../entities/Spikeball.qml";
                  }
                  else if(variantInput.currentIndex == 4) {
                      itemUrl = "../entities/Spikes.qml";
                  }
              }
              else if(behaviorInput.currentIndex == 1) {
                if(variantInput.currentIndex == 0) {
                    itemUrl = "../entities/OpponentJumper.qml";
                }
                else if(variantInput.currentIndex == 1) {
                    itemUrl = "../entities/OpponentWalker.qml";
                }
              }
              else if(behaviorInput.currentIndex == 2) {
                  if(variantInput.currentIndex == 0) {
                      itemUrl = "../entities/Coin.qml";
                  }
                  else if(variantInput.currentIndex == 1) {
                      itemUrl = "../entities/Mushroom.qml";
                  }
                  else if(variantInput.currentIndex == 2) {
                      itemUrl = "../entities/Star.qml";
                  }
                  else if(variantInput.currentIndex == 3) {
                      itemUrl = "../entities/Finish.qml";
                  }
              }
              else {
                console.log("Tried to save an object, but no corresponding entity url was found.")
              }

              customItems.push({
                                   toCreateEntityTypeUrl: itemUrl,
                                   customConfiguration: {
                                       imageSource: image.source,
                                       width: widthInput.value * 32,
                                       height: heightInput.value * 32
                                   }
                               });

              storage.setValue("customItems", customItems);

              customItemManager.loadItems();
          }
          else {
              console.log("Tried to save an object, but the max number of saved objects has been reached.")
          }
      }
    }
}
