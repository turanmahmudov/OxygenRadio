import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQuick.LocalStorage 2.0
import QtQuick.XmlListModel 2.0

import "../components"

import "../js/scripts.js" as Scripts
import "../js/localdb.js" as LocalDB

Page {
    id: newstation

    header: PageHeader {
        title: i18n.tr("Add New Station")
        trailingActionBar {
            numberOfSlots: 2
            actions: [
                Action {
                    id: tickAction
                    text: i18n.tr("Save")
                    iconName: "tick"
                    onTriggered: {
                        Scripts.add_custom_radio()
                    }
                }
            ]
        }
    }

    Flickable {
        id: flickable
        anchors {
            left: parent.left
            leftMargin: units.gu(1.5)
            right: parent.right
            rightMargin: units.gu(1.5)
            bottom: parent.bottom
            bottomMargin: common_bmrgn
            top: newstation.header.bottom
            topMargin: units.gu(2)
        }
        contentHeight: columnSuperior.height

        Column {
           id: columnSuperior
           width: parent.width - units.gu(3)

           spacing: units.gu(1)

           Label {
               text: i18n.tr("Name of station")
           }

           TextField {
               id: nameOfStation
               width: parent.width
               hasClearButton: true
               inputMethodHints: Qt.ImhNoPredictiveText
               text: i18n.tr("My station")
           }

           Label {
               text: i18n.tr("URL of station")
           }

           TextField {
               id: urlOfStation
               width: parent.width
               hasClearButton: true
               inputMethodHints: Qt.ImhNoPredictiveText
               text: i18n.tr("http://")
           }

           Label {
               text: i18n.tr("URL of logo")
           }

           TextField {
               id: logoOfStation
               width: parent.width
               hasClearButton: true
               inputMethodHints: Qt.ImhNoPredictiveText
               text: i18n.tr("http://")
           }

           Label {
               text: i18n.tr("Short description")
           }

           TextArea {
               id: descriptionOfStation
               width: parent.width
               height: units.gu(8)
               text: ''
           }
        }
    }
}
