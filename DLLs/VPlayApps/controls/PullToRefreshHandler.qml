import QtQuick 2.0
import VPlayApps 1.0

Item {
  property bool pullToRefreshEnabled

  property Flickable listView

  property bool refreshing

  property color contentColor

  signal refresh

}
