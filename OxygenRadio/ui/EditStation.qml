import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQuick.LocalStorage 2.0
import QtQuick.XmlListModel 2.0

import "../components"

import "../js/scripts.js" as Scripts
import "../js/localdb.js" as LocalDB

Page {
    id: newstation

    property var radio_id

    header: PageHeader {
        title: i18n.tr("Edit Station")
        trailingActionBar {
            numberOfSlots: 2
            actions: [
                Action {
                    id: tickAction
                    text: i18n.tr("Save")
                    iconName: "tick"
                    onTriggered: {
                        Scripts.edit_custom_radio(radio_id)
                    }
                }
            ]
        }
    }

    function get_stations(id) {
        bouncingProgress.visible = true

        var db = LocalDB.init();
        db.transaction(function(tx) {
            var rs = tx.executeSql("SELECT * FROM Custom WHERE channel_id = ?", id);
            if (rs.rows.length != 0) {
                for(var i = 0; i < rs.rows.length; i++) {
                    nameOfStation.text = rs.rows.item(i).title;
                    urlOfStation.text = rs.rows.item(i).listen_url;
                    logoOfStation.text = rs.rows.item(i).image;
                    descriptionOfStation.text = rs.rows.item(i).description;
                }
            }
        });

        bouncingProgress.visible = false
    }

    Component.onCompleted: {
        get_stations(radio_id)
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
