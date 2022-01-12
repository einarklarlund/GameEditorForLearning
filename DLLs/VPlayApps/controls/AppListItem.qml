import QtQuick 2.8
import QtQuick.Layouts 1.3
import Felgo 3.0

Item {
  property RippleMouseArea mouseArea

  property real topPadding
  property real bottomPadding
  property real leftPadding
  property real rightPadding

  property color backgroundColor
  property color selectedBackgroundColor
  property color activeBackgroundColor

  property string text
  property color textColor
  property color selectedTextColor
  property color activeTextColor
  property real textFontSize
  property int textMaximumLineCount
  property real textVerticalSpacing

  property string detailText
  property color detailTextColor
  property color selectedDetailTextColor
  property color activeDetailTextColor
  property real detailTextFontSize
  property int detailTextMaximumLineCount

  property string rightText
  property color rightTextColor
  property real rightTextFontSize
  property real rightTextMaxWidth

  property bool showDisclosure
  property color disclosureColor

  property bool showDivider
  property real dividerLeftSpacing
  property real dividerHeight
  property color dividerColor

  property string image
  property int imageSize
  property real imageRadius
  property real imageFillMode

  property real disabledOpacity

  property bool muted

  property bool active

  property bool lastInSection

  property real textItemAvailableWidth

  property Item leftItem
  property Item textItem
  property Item detailTextItem
  property Item rightItem
  property Item disclosureItem

  signal selected(int index)
}
