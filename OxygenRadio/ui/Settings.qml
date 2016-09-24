import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
import QtQuick.LocalStorage 2.0
import QtQuick.XmlListModel 2.0

import "../components"

import "../js/scripts.js" as Scripts
import "../js/localdb.js" as LocalDB

Page {
    id: settings

    header: PageHeader {
        title: i18n.tr("Settings")
    }

    Flickable {
        id: flickable
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            bottomMargin: common_bmrgn
            top: settings.header.bottom
            topMargin: units.gu(1)
        }
        contentHeight: columnSuperior.height

        Column {
           id: columnSuperior
           width: parent.width

           ListItem.Header {
               text: i18n.tr("General")
           }

           ListItem.Base {
               width: parent.width
               showDivider: true
               Column {
                   anchors.verticalCenter: parent.verticalCenter
                   anchors.right: parent.right
                   anchors.left: parent.left
                   Label {
                       width: parent.width
                       wrapMode: Text.WordWrap
                       text: i18n.tr("Dark Theme")
                   }
               }

               CheckBox {
                   anchors {
                       right: parent.right
                       verticalCenter: parent.verticalCenter
                   }
                   checked: startupSettings.darkTheme == true ? true : false
                   onCheckedChanged: {
                       startupSettings.darkTheme = checked
                       themeManager.currentThemeIndex = checked ? 1 : 0
                   }
               }
           }

           ListItem.Base {
               width: parent.width
               showDivider: false
               Column {
                   anchors.verticalCenter: parent.verticalCenter
                   anchors.right: parent.right
                   anchors.left: parent.left
                   Label {
                       width: parent.width
                       wrapMode: Text.WordWrap
                       text: i18n.tr("Disable Screen Sleep")
                   }

                   Label {
                       fontSize: "small"
                       color: UbuntuColors.darkGrey
                       width: parent.width - units.gu(4)
                       wrapMode: Text.WordWrap
                       elide: Text.ElideRight
                       text: i18n.tr("Keep screen on to update playing song info")
                   }
               }

               CheckBox {
                   anchors {
                       right: parent.right
                       verticalCenter: parent.verticalCenter
                   }
                   checked: startupSettings.disableScreenSleep == true ? true : false
                   onCheckedChanged: {
                       startupSettings.disableScreenSleep = checked
                       screenSaver.screenSaverEnabled = checked ? false : trueS
                   }
               }
           }

           ListItem.Header {
               text: i18n.tr("Playing")
           }

           ListItem.Base {
               width: parent.width
               showDivider: true
               Column {
                   anchors.verticalCenter: parent.verticalCenter
                   anchors.right: parent.right
                   anchors.left: parent.left
                   Label {
                       width: parent.width
                       wrapMode: Text.WordWrap
                       text: i18n.tr("Play Last Station")
                   }

                   Label {
                       fontSize: "small"
                       color: UbuntuColors.darkGrey
                       width: parent.width - units.gu(4)
                       wrapMode: Text.WordWrap
                       elide: Text.ElideRight
                       text: i18n.tr("Play last played station on startup")
                   }
               }

               CheckBox {
                   anchors {
                       right: parent.right
                       verticalCenter: parent.verticalCenter
                   }
                   checked: startupSettings.playLastPlayedChannel == true ? true : false
                   onCheckedChanged: {
                       startupSettings.playLastPlayedChannel = checked
                   }
               }
           }

           ListItem.Base {
               width: parent.width
               showDivider: false
               Column {
                   anchors.verticalCenter: parent.verticalCenter
                   anchors.right: parent.right
                   anchors.left: parent.left
                   Label {
                       width: parent.width
                       wrapMode: Text.WordWrap
                       text: i18n.tr("Current Song Info")
                   }

                   Label {
                       fontSize: "small"
                       color: UbuntuColors.darkGrey
                       width: parent.width - units.gu(4)
                       wrapMode: Text.WordWrap
                       elide: Text.ElideRight
                       text: i18n.tr("Automatically update playing song info")
                   }
               }

               CheckBox {
                   anchors {
                       right: parent.right
                       verticalCenter: parent.verticalCenter
                   }
                   checked: startupSettings.getCurrentSongInfo == true ? true : false
                   onCheckedChanged: {
                       startupSettings.getCurrentSongInfo = checked
                   }
               }
           }

           ListItem.Header {
               text: i18n.tr("Miscellaneous")
           }

           ListItem.Base {
               width: parent.width
               progression: true
               showDivider: true
               onClicked: {
                   pagestack.push(Qt.resolvedUrl("About.qml"))
               }
               Column {
                   anchors.verticalCenter: parent.verticalCenter
                   anchors.right: parent.right
                   anchors.left: parent.left
                   Label {
                       width: parent.width
                       wrapMode: Text.WordWrap
                       text: i18n.tr("About")
                   }

                   Label {
                       fontSize: "small"
                       color: UbuntuColors.darkGrey
                       width: parent.width - units.gu(4)
                       wrapMode: Text.WordWrap
                       elide: Text.ElideRight
                       text: i18n.tr("About Oxygen Radio")
                   }
               }
           }

           ListItem.Base {
               width: parent.width
               progression: true
               showDivider: false
               onClicked: {
                   pagestack.push(Qt.resolvedUrl("Credits.qml"))
               }
               Column {
                   anchors.verticalCenter: parent.verticalCenter
                   anchors.right: parent.right
                   anchors.left: parent.left
                   Label {
                       width: parent.width
                       wrapMode: Text.WordWrap
                       text: i18n.tr("Credits")
                   }

                   Label {
                       fontSize: "small"
                       color: UbuntuColors.darkGrey
                       width: parent.width - units.gu(4)
                       wrapMode: Text.WordWrap
                       elide: Text.ElideRight
                       text: i18n.tr("Developers and Contributors")
                   }
               }
           }
        }
    }
}
