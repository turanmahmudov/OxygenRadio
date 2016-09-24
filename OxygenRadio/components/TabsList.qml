import QtQuick 2.4
import Ubuntu.Components 1.3

ActionList {
    id: tabsList

    children: [
        Action {
            text: i18n.tr("Featured")
            iconName: "stock_music"
            onTriggered: {
                tabs.selectedTabIndex = 0
                startupSettings.tabIndex = 0
            }
        },
        Action {
            text: i18n.tr("Genres")
            iconName: "filters"
            onTriggered: {
                tabs.selectedTabIndex = 1
                startupSettings.tabIndex = 1
            }
        },
        Action {
            text: i18n.tr("Favorites")
            iconName: "like"
            onTriggered: {
                tabs.selectedTabIndex = 2
                startupSettings.tabIndex = 2
            }
        },
        Action {
            text: i18n.tr("Custom")
            iconName: "edit"
            onTriggered: {
                tabs.selectedTabIndex = 3
                startupSettings.tabIndex = 3
            }
        }
    ]
}
