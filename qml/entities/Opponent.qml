import QtQuick 2.0
import Felgo 3.0
import "../editorElements"

// this is the base class for all opponents
PlatformerEntityBaseDraggable {
  id: opponent
  entityType: "opponent"

  // the opponent's start position
  // These are the coordinates, to which the opponent gets reset,
  // when resetting the level.
  property int startX
  property int startY

  // this is true while the opponent is alive
  property bool alive: true

  // After an opponent dies, we want to show it's dead-sprite for a short
  // time, and then hide it.
  // If this property is true, the opponent is invisible.
  property bool hidden: false

  // this property is used instead to bypass Felgo's default implementation of using different pngs for dead opponents
  // if the opponent is dead, its height will be set to this
  // the default death sprites that are given by Felgo are 5 px tall. the regular sprites are 32 px trall
  property var deathHeight: image.height * 5 / 32

  z: 1 // to make opponent appear in front of the platforms

  // hide opponent after its death
  image.visible: !hidden

  // update the entity's start position when the entity is created or moved
  onEntityCreated: updateStartPosition()
  onEntityReleased: updateStartPosition()

  // this timer hides the opponent a few seconds after its death
  Timer {
    id: hideTimer
    interval: 2000

    onTriggered: hidden = true
  }

  function updateStartPosition()
  {
    startX = x
    startY = y
  }

  // this function resets all properties, which all opponents have in common
  function reset_super()
  {
    // reset alive property
    alive = true

    // stop hideTimer, to avoid unwanted, delayed hiding of the opponent
    hideTimer.stop()
    // reset hidden
    hidden = false

    // reset position
    x = startX
    y = startY

    // reset velocity
    collider.linearVelocity.x = 0
    collider.linearVelocity.y = 0

    // reset force
    collider.force = Qt.point(0, 0)

    // call resetSize Function as defined in PlatformerEntityBaseDraggable
    resetSizeAndImage();
  }

  function die() {
    alive = false

    var height = this.height;

    scaleSize(1, 5 / 19);

    y += height * 14 / 19;

    anchors.bottom = bottom;

    hideTimer.start()

    if(variationType == "walker")
      audioManager.playSound("opponentWalkerDie")
    else if(variationType == "jumper")
      audioManager.playSound("opponentJumperDie")

    // for every killed opponent, the time gets set back a little bit
    gameScene.time -= 5
  }
}
