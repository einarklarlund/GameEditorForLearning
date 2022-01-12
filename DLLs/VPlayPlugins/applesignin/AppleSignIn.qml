import QtQuick 2.0
import Felgo 3.0
import Qt.labs.settings 1.1


Item {
  readonly property bool isAvailable: false
  readonly property string userId: ""
  readonly property string userName: ""
  readonly property string email: ""
  readonly property string identityToken: ""
  readonly property string authorizationCode: ""
  readonly property var authorizedScopes: []
  property bool isSignedIn: false

  signal signInCompleted()
  signal signInFailed(string message)

  function signIn() {  }
  function getCredentialState(userId, callback) {  }
}
