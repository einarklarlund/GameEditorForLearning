function createCustomItemButtons(items) {
    items.forEach(item => {
        Qt.createComponent("../editorElements/PlatformerBuildEntityButton.qml");
    });
    component = Qt.createComponent("Sprite.qml");
    if (component.status == Component.Ready) {
        finishCreation();
    }
    else
        component.statusChanged.connect(finishCreation);
}

function createButton() {

}

function finishCreation() {
    if (component.status == Component.Ready) {
        sprite = component.createObject(appWindow, {"x": 100, "y": 100});
        if (sprite == null) {
            // Error Handling
            console.log("Error creating object");
        }
    } else if (component.status == Component.Error) {
        // Error Handling
        console.log("Error loading component:", component.errorString());
    }
}
