import QtQuick 2.0
import Felgo 3.0

EntityBaseDraggable {
  id: entityBase

  // this is the scene this entity is in
  // NOTE: if your scene's id is NOT gameScene change this to make it fit to your implementation
  property var scene: gameScene

  // alias, to be able to access the sprite from the outside
  property alias image: sprite

  // this property stores the entity's last snapped position
  property point lastPosition

  // the entitybase needs a variable to track whether or not the entity is customized
  // i had trouble with just setting the customConfiguration and checking if it is defined
  property var isCustomized: false

  // DEPRECATED:
  // this variable is necessary so that the entitybase can check for custom configuration
  // while it is being draggged from the sidebar
  property var customIndex: -1

  entityType: "emptyEntityBase"

  property var customConfiguration
  // the customConfiguration is in the following form:
  /*
    {
       imageSource: Url,
       width: Number,
       height: Number
    }
  */

  // custom image source that customized entities will carry
  property var customImageSource

  // size variables that keep track of the initial size of the sprite
  // they are set in the onCompleted method so that they're not binded to any variables
  property var startWidth: 32
  property var startHeight: 32

  width: sprite.width;
  height: sprite.height;
//  colliderComponent: draggingCollider

  // when this component is loaded, set lastPosition to the
  // current position and set the size
  Component.onCompleted: {
      lastPosition = Qt.point(x, y);
      startWidth = 32;
      startHeight = 32;
  }

  // this is the grid size the entity gets snapped to when it's dragged and dropped
  gridSize: scene.gridSize

  // this property must be set for EntityBaseDraggable
  selectionMouseArea {
    anchors.fill: sprite

    // if the hand tool is active, entities should not be draggable
    // so we don't accept the mouse event - it gets forwarded to the base mouse area (in GameScene)
    onPressed: {
      if(scene.editorOverlay.sidebar.activeTool == "hand") {
        mouse.accepted = false
      }
    }
  }

  // in levelEditingMode drag and drop is enabled
  // NOTE: if your editing state is not "edit", change this to make it fit to your implementation
  inLevelEditingMode: scene.state === "edit"

  // set dragOffset to (0, 0)
  dragOffset: Qt.point(0, 0)

  // this enables clicking on an object - we want this for removing entities
  delayDragOffset: true

  // make the notAllowedRectangle fit to the sprite
  notAllowedRectangle.anchors.fill: sprite

  // enable entity pooling to improve performance
  poolingEnabled: true

  // since our levels have no size limit, we don't want any
  // boundaries when dragging our entities
  ignoreBounds: true

  // this event is handled in the editorOverlay
  onEntityClicked: scene.editorOverlay.clickEntity(entityBase)

  onEntityStateChanged: {
    if(entityState == "entityDragged") {
        audioManager.playSound("dragEntity")
    }

    if(isCustomized)
        loadCustomConfiguration();
  }

  onEntityReleased: {
    // If lastPosition is < 0, it means, that this entity
    // was dragged from the sidebar. In this case we don't
    // want to create a "move"-undoObject, but a "create".
    // We handle this in PlatformerBuildEntityButton.    
      if(lastPosition.x < 0) return

    // get new position
    var currentPosition = scene.editorOverlay.snapToGrid(x, y)

    // if the entity's position has changed...
    if(lastPosition !== currentPosition) {
      var config = customConfiguration == undefined || customConfiguration == null ? 
                    undefined : customConfiguration;
      
      // ...add a new "move"-undoObject to the undoHandler
      var undoObjectProperties = {"target": entityBase, "action": "move",
        "otherPosition": lastPosition, "currentPosition": currentPosition,
        "customConfiguration": config}

      var undoObject = scene.editorOverlay.undoHandler.createUndoObject(undoObjectProperties)
      scene.editorOverlay.undoHandler.push([undoObject])

      // update lastPosition
      lastPosition = currentPosition

      audioManager.playSound("createOrDropEntity")
    }
  }

  // handle position changes
  onXChanged: positionChanged()
  onYChanged: positionChanged()

  // when this entity is taken from the entity pool, set it's lastPosition property
  onUsedFromPool: {
    lastPosition = Qt.point(x, y)
    if(isCustomized)
       loadCustomConfiguration();
  }

  // the sprite of the entity
  MultiResolutionImage {
    id: sprite
    source:  "../../assets/EmptyPicture.png"
  }

  function loadCustomConfiguration() {
      if(isCustomized){
        if(gameScene.customItemManager.isEntityRegistered(entityId))
          customConfiguration = gameScene.customItemManager.getCustomConfigurationById(entityId);
        else{
          console.log("[PlatformerEntityBaseDraggable] " + entityId + " is customized but isn't registered in the customItemManager.");
        }

        // set the custom configuration
        if(customIndex == -1)
          console.log("[PlatformerEntityBaseDraggable] " + entityId + " is customized but doesn't have its customIndex set.");

        customConfiguration = gameScene.customItemManager.getCustomConfigurationAt(customIndex);

        sprite.width = customConfiguration.width;
        sprite.height = customConfiguration.height;
        sprite.source = customConfiguration.imageSource;
      }
  }

  // in this function we check if the entity is dragged out of bounds
  function positionChanged() {
    // if entity is dragged, check if entity is in bounds
    if(entityBase.entityState == "entityDragged") {
      // calculate x screen coordinate
      // adjust entity position to scale, and add container position
      var xScreen = entityBase.x * scene.container.scale + scene.container.x

      // The leftLimit is the leftmost point where the entity
      // may be released.
      // To get this value, we take the width of the sidebar,
      // and subtract a small tolerance value.
      var leftLimit = scene.editorOverlay.sidebar.width - 8 * scene.container.scale

      // calculate y screen coordinate
      // adjust entity position to scale, and add container position
      var yScreen = entityBase.y * scene.container.scale + scene.container.y

      // The bottomLimit is the lowest point on the screen, where
      // the entity may be released. This value is calculated by
      // subtracting a small tolerance value from the game window
      // height.
      var bottomLimit = scene.gameWindowAnchorItem.height - 17 * scene.container.scale

      // If this entity is too far left or too low, forbid building.
      // We check if yScreen is larger than bottomLimit, because
      // the origin of the coordinate system is in the top left
      // corner. This means, that a higher y value is actually
      // lower on the screen.
      if(xScreen < leftLimit || yScreen > bottomLimit)
        forbidBuild = true
      else // otherwise allow it
        forbidBuild = false
    }
  }

  function scaleSize(widthScale, heightScale) {
      sprite.width *= widthScale;
      sprite.height*= heightScale;
  }

  function resetSizeAndImage() {
      if(isCustomized) {
          if(gameScene.customItemManager.isEntityRegistered(entityId))
            customConfiguration = gameScene.customItemManager.getCustomConfigurationById(entityId);
          else if (customIndex != -1)
            customConfiguration = gameScene.customItemManager.getCustomConfigurationAt(customIndex);
          else if (customConfiguration == undefined || customConfiguration == null){
              console.log("[PlatformerEntityBaseDraggable] tried to reset size and image to custom configuration, but couldn't load the configuration.");
              return;
          }
          else {
              sprite.width = customConfiguration.width;
              sprite.height = customConfiguration.height;
              sprite.source = customConfiguration.imageSource;
          }
      }
  }
}
