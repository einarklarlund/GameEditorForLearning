import QtQuick 2.0
import Felgo 3.0
import "../editorElements"

// this is the base class for all Ground objects
PlatformerEntityBaseDraggable {
  // both the id and entityType should be assigned at instantiation from sidebar.qml
  id: customItem
  entityType: "customItem"
  variationType: baseEntity.variationType
}
