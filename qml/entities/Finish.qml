import QtQuick 2.0
import Felgo 3.0
import "../editorElements"

PlatformerEntityBaseDraggable {
  id: finish
  entityType: "item"
  variationType: "finish"

  // define colliderComponent for collision detection while dragging
  colliderComponent: collider

  // set image
  image.source: "../../assets/finish/finish.png"

  Component.onCompleted: {
    variationType = "finish"
  }

  function collect() {
      console.debug("Player touches finish")

      // ...we emit the player's finish() signal
      gameScene.player.finish()
  }

  BoxCollider {
    id: collider

    anchors.fill: parent
    bodyType: Body.Static

    // Category5: solids
    categories: Box.Category5
    // Category1: player body, Category2: player feet sensor,
    // Category3: opponent body, Category4: opponent sensor
    collidesWith: Box.Category1 | Box.Category2 | Box.Category3 | Box.Category4

    // this is called whenever the contact with another entity begins
//    fixture.onBeginContact: {
//      var otherEntity = other.getBody().target

//      // if the collided entity is the player...
//      if(otherEntity.entityType === "player") {
//        console.debug("Player touches finish")

//        // ...we emit the player's finish() signal
//        gameScene.player.finish()
//      }
//    }
  }
}
