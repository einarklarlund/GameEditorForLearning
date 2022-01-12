import QtQuick 2.0
import Felgo 3.0
import "../editorElements/"

Item {

    id: customItemManager

    Component.onCompleted: loadItems()

    property var items: null

    property var customizedEntityDictionary: ({})

    signal itemsLoaded

    /**
      * JS FUNCTIONS
      */
    /*
      customizedEntityDictionary:
        [
            [
                { x: number, y: number, customIndex: number }
            ]
        ]

        each element in the inner dictionary is indexed by the id of an entity in a saved level
        the elements have info about the configuration of the entity with a custom configuration (should
        be changed so that each element has the entire custom configuration)

        each element in the outer array is indexed by the name of a saved level. each element is a dictonary
        of all the entities with customConfigurations in the level

        outer array keeps is indexed by the string "customizedEntityDictionary_levelName"

        should be
        [
            [
                {
                   imageSource: Url,
                   width: Number,
                   height: Number
                }
            ]
        ]
      */
    function initCustomizedEntityDictionary() {
        var dataQuery = storage.getValue("customizedEntityDictionary_" + levelEditor.currentLevelName);

        if(dataQuery) {
            customizedEntityDictionary = dataQuery;

            // assign custom configurations to according to the customizedEntityDictionary
            Object.keys(customizedEntityDictionary).forEach(function(key) {
                var entity = entityManager.getEntityById(key);
                if(entity) {
                    initBuildEntity(entity);
                }
                else {
                    console.log("[PlatformerCustomItemManager] dictionary entry for " + key + " was saved but wasn't found in the level ");
                }
            })

            storage.setValue("customizedEntityDictionary_" + levelEditor.currentLevelName, customizedEntityDictionary);
        }
        else {
            console.log("[PlatformerCustomItemManager] no customizedEntityDictionary for level " + levelEditor.currentLevelName + " was found in storage");
        }
    }

    // registers a customized buildEntity in the customizedEntityDictionary.
    // the entity should already have its image.source, width, and height values
    // set BEFORE registerCustomItem is called. 
    function registerCustomItem(id) {
        // find the entity from the entityManager
        var entity = entityManager.getEntityById(id);
        if(!entity.isCustomized)
            return;

        console.log("[PlatformerCustomItemManager] registering " + id);

        // place the information about the entity in the customizedEntityDictionary array
        customizedEntityDictionary[id] = { imageSource: entity.image.source, width: entity.width, height: entity.height };
        console.log("[PlatformerCustomItemManager] customizedEntityDictionary[" + id + "] now has imageSource: " + customizedEntityDictionary[id].imageSource + ", width: "
                    + customizedEntityDictionary[id].width + " and height: " + customizedEntityDictionary[id].height);
    }

    function unregisterCustomItem(id) {
        console.log("[PlatformerCustomItemManager] unregistering entity " + id);

        // find the customized BuildEntity's data
        var buildEntityData = customizedEntityDictionary[id];
        if(!buildEntityData) {
            console.log("[PlatformerCustomItemManager] unregistered entity " + id +
                           ", but it wasnt wasn't found in customizedEntityDictionary.");
        }
        customizedEntityDictionary[id] = undefined;
    }

    function isEntityRegistered(entity) {
        Object.keys(customizedEntityDictionary).forEach(key => {
                                                            if(key === entity.entityId)
                                                                return true;
                                                            })
        return false;
    }

    function saveCurrentLevel(saveProperties) {
        // save the modified list as the new value
        console.log(saveProperties.levelMetaData.levelId);
        
        storage.setValue("customizedEntityDictionary_" + levelEditor.currentLevelName, customizedEntityDictionary);
        console.log("saved customizedEntityDictionary_" + levelEditor.currentLevelName +
                    " with value: " + JSON.stringify(storage.getValue("customizedEntityDictionary_" + levelEditor.currentLevelName)));
    }

    function removeCurrentLevel() {
        storage.setValue("customizedEntityDictionary_" + levelEditor.currentLevelName, undefined);
        console.log("removed customizedEntityDictionary_ " + levelEditor.currentLevelName);
    }

    function initBuildEntity(buildEntity) {
        console.log("[PlatformerCustomItemManager] initializing buildEntity " + buildEntity.entityId);
        if(!customizedEntityDictionary[buildEntity.entityId]) {
            console.log("[PlatformerCustomItemManager] while initializing entity " + buildEntity.entityId +
                           " could not find the entity in customizedEntityDictionary");
            return;
        }

        var config = customizedEntityDictionary[buildEntity.entityId];
        buildEntity.customConfiguration = config;
        buildEntity.isCustomized = true;

        buildEntity.resetSizeAndImage();
    }

    function getCustomConfigurationAt(index) {
        if(items == null || typeof items[index] == "undefined")
            return null;

        return items[index].customConfiguration;
    }

    function getCustomConfigurationById(id) {
        return customizedEntityDictionary[id];
    }

    function getEntityUrlAt(index) {
        if(items == null || typeof items[index] == "undefined")
            return null;

        return items[index].toCreateEntityTypeUrl;
    }

    function isItemLoadedAt(index) {
        return typeof items != "undefined" && items !== null && items[index] !== null && typeof items[index] !== "undefined"
    }

    function loadItems() {
        console.log("Loading saved items...");

        items = storage.getValue("customItems");

        if(typeof items != "undefined" && items !== null) {
            itemsLoaded();
            console.log(JSON.stringify(items));
        }
        else {
            console.log("[PlatformerCustomItemManager] storage.getValue(\"customItems\") returned undefined or null.");
        }
    }

    function removeItem(index) {
        if(items == null)
            console.log("tried to remove item at index " + index +
                        " from the custom items list, but the list wasn't initialized");

        if(index > items.length)
            console.log("tried to remove item at index " + index +
                        "from the custom items list, but " + index + " is out of bounds");

        items.splice(index, 1);
        storage.setValue("customItems", items);

        console.log("removing item at index " + index + " from custom item manager.");

        loadItems();
    }
}

