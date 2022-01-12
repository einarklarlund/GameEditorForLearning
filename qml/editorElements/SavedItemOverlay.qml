import QtQuick 2.0
import Felgo 3.0

Column {

    id: savedItemOverlay

    // the savedItemOverlay is tightly coupled with the sidebar, which has the resposibility of instantiating the overlay
    // and controlling the overlay's visibility
    width: parent.width

    spacing: 5

//    property var savedItemButtons:
//        [customButton0, customButton1, customButton2, customButton3, customButton4, customButton5, customButton6, customButton7, customButton8, customButton9]

    property var savedItemButtons:
        [button0, button1, button2, button3, button4, button5, button6, button7, button8, button9,
        button10, button11, button12, button13, button14, button15, button16, button17, button18, button19]

    property alias button0: customButton0
    property alias button1: customButton1
    property alias button2: customButton2
    property alias button3: customButton3
    property alias button4: customButton4
    property alias button5: customButton5
    property alias button6: customButton6
    property alias button7: customButton7
    property alias button8: customButton8
    property alias button9: customButton9
    property alias button10: customButton10
    property alias button11: customButton11
    property alias button12: customButton12
    property alias button13: customButton13
    property alias button14: customButton14
    property alias button15: customButton15
    property alias button16: customButton16
    property alias button17: customButton17
    property alias button18: customButton18
    property alias button19: customButton19

    PlatformerCustomBuildEntityButton {
      id: customButton0
      index: 0
      visible: isButtonLoaded(index)

      onSelected: sidebar.selectBuildEntityButton(this)
      onUnselected: sidebar.unselectBuildEntityButton()
    }

    PlatformerCustomBuildEntityButton {
      id: customButton1
      index: 1
      visible: isButtonLoaded(index)

      onSelected: sidebar.selectBuildEntityButton(this)
      onUnselected: sidebar.unselectBuildEntityButton()
    }

    PlatformerCustomBuildEntityButton {
      id: customButton2
      index: 2
      visible: isButtonLoaded(index)

      onSelected: sidebar.selectBuildEntityButton(this)
      onUnselected: sidebar.unselectBuildEntityButton()
    }

    PlatformerCustomBuildEntityButton {
      id: customButton3
      index: 3
      visible: isButtonLoaded(index)

      onSelected: sidebar.selectBuildEntityButton(this)
      onUnselected: sidebar.unselectBuildEntityButton()
    }

    PlatformerCustomBuildEntityButton {
      id: customButton4
      index: 4
      visible: isButtonLoaded(index)

      onSelected: sidebar.selectBuildEntityButton(this)
      onUnselected: sidebar.unselectBuildEntityButton()
    }

    PlatformerCustomBuildEntityButton {
      id: customButton5
      index: 5
      visible: isButtonLoaded(index)

      onSelected: sidebar.selectBuildEntityButton(this)
      onUnselected: sidebar.unselectBuildEntityButton()
    }

    PlatformerCustomBuildEntityButton {
      id: customButton6
      index: 6
      visible: isButtonLoaded(index)

      onSelected: sidebar.selectBuildEntityButton(this)
      onUnselected: sidebar.unselectBuildEntityButton()
    }

    PlatformerCustomBuildEntityButton {
      id: customButton7
      index: 7
      visible: isButtonLoaded(index)

      onSelected: sidebar.selectBuildEntityButton(this)
      onUnselected: sidebar.unselectBuildEntityButton()
    }

    PlatformerCustomBuildEntityButton {
      id: customButton8
      index: 8
      visible: isButtonLoaded(index)

      onSelected: sidebar.selectBuildEntityButton(this)
      onUnselected: sidebar.unselectBuildEntityButton()
    }

    PlatformerCustomBuildEntityButton {
      id: customButton9
      index: 9
      visible: isButtonLoaded(index)

      onSelected: sidebar.selectBuildEntityButton(this)
      onUnselected: sidebar.unselectBuildEntityButton()
    }

    PlatformerCustomBuildEntityButton {
      id: customButton10
      index: 10
      visible: isButtonLoaded(index)

      onSelected: sidebar.selectBuildEntityButton(this)
      onUnselected: sidebar.unselectBuildEntityButton()
    }

    PlatformerCustomBuildEntityButton {
      id: customButton11
      index: 11
      visible: isButtonLoaded(index)

      onSelected: sidebar.selectBuildEntityButton(this)
      onUnselected: sidebar.unselectBuildEntityButton()
    }

    PlatformerCustomBuildEntityButton {
      id: customButton12
      index: 12
      visible: isButtonLoaded(index)

      onSelected: sidebar.selectBuildEntityButton(this)
      onUnselected: sidebar.unselectBuildEntityButton()
    }

    PlatformerCustomBuildEntityButton {
      id: customButton13
      index: 13
      visible: isButtonLoaded(index)

      onSelected: sidebar.selectBuildEntityButton(this)
      onUnselected: sidebar.unselectBuildEntityButton()
    }

    PlatformerCustomBuildEntityButton {
      id: customButton14
      index: 14
      visible: isButtonLoaded(index)

      onSelected: sidebar.selectBuildEntityButton(this)
      onUnselected: sidebar.unselectBuildEntityButton()
    }

    PlatformerCustomBuildEntityButton {
      id: customButton15
      index: 15
      visible: isButtonLoaded(index)

      onSelected: sidebar.selectBuildEntityButton(this)
      onUnselected: sidebar.unselectBuildEntityButton()
    }

    PlatformerCustomBuildEntityButton {
      id: customButton16
      index: 16
      visible: isButtonLoaded(index)

      onSelected: sidebar.selectBuildEntityButton(this)
      onUnselected: sidebar.unselectBuildEntityButton()
    }

    PlatformerCustomBuildEntityButton {
      id: customButton17
      index: 17
      visible: isButtonLoaded(index)

      onSelected: sidebar.selectBuildEntityButton(this)
      onUnselected: sidebar.unselectBuildEntityButton()
    }

    PlatformerCustomBuildEntityButton {
      id: customButton18
      index: 18
      visible: isButtonLoaded(index)

      onSelected: sidebar.selectBuildEntityButton(this)
      onUnselected: sidebar.unselectBuildEntityButton()
    }

    PlatformerCustomBuildEntityButton {
      id: customButton19
      index: 19
      visible: isButtonLoaded(index)

      onSelected: sidebar.selectBuildEntityButton(this)
      onUnselected: sidebar.unselectBuildEntityButton()
    }

    /**
      * JS FUNCTIONS
      */

    function isButtonLoaded(buttonIndex) {
        return customItemManager.getCustomConfigurationAt(buttonIndex) !== null;
    }
}

