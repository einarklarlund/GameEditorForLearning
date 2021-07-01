import QtQuick 2.0
import Felgo 3.0
import "../editorElements"

// this is the base class for all Ground objects
PlatformerEntityBaseDraggable {
  id: ground
  entityType: "ground"

  // define colliderComponent for collision detection while dragging
  colliderComponent: collider

  property alias collider: collider

  BoxCollider {
    id: collider

    anchors.fill: parent
    width: parent.width
    height: parent.height
    bodyType: Body.Static

    // Category5: solids
    categories: Box.Category5
    // Category1: player body, Category2: player feet sensor,
    // Category3: opponent body, Category4: opponent sensor
    collidesWith: Box.Category1 | Box.Category2 | Box.Category3 | Box.Category4
  }

}
