import Felgo 3.0
import QtQuick 2.0

Item {
  property int latestVersionCodeIOS: 0
  property int latestVersionCodeAndroid: 0
  property int latestVersionCodeMac: 0
  property int latestVersionCodeWindows: 0
  property int latestVersionCodeLinux: 0
  property int latestVersionCodeQNX: 0
  property int latestVersionCodeEmbeddedLinux: 0

  property int latestVersionCode: 0

  property string updateUrlIOS: ""
  property string updateUrlAndroid: ""
  property string updateUrlMac: ""
  property string updateUrlWindows: ""
  property string updateUrlLinux: ""
  property string updateUrlQNX: ""
  property string updateUrlEmbeddedLinux: ""

  property string updateUrl: ""

  property string dialogTitle: ""

  property string dialogText: ""
}
