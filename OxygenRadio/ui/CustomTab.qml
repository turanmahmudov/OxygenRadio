import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQuick.LocalStorage 2.0
import QtQuick.XmlListModel 2.0

import "../components"

import "../js/scripts.js" as Scripts
import "../js/localdb.js" as LocalDB

Page {
    id: customtab

    TabsList {
        id: tabsList
    }

    header: PageHeader {
        title: i18n.tr("Custom")
        leadingActionBar {
            actions: tabsList.actions
        }
        trailingActionBar {
            numberOfSlots: 3
            actions: [settingsAction, searchAction, addAction]
        }
    }

    function get_stations() {
        bouncingProgress.visible = true

        customModel.clear()

        var db = LocalDB.init();
        db.transaction(function(tx) {
            var rs = tx.executeSql("SELECT * FROM Custom");
            if (rs.rows.length != 0) {
                for(var i = 0; i < rs.rows.length; i++) {
                    customModel.append({"id": rs.rows.item(i).channel_id, "title": rs.rows.item(i).title, "description": rs.rows.item(i).description, "image": rs.rows.item(i).image, "listen_url": rs.rows.item(i).listen_url});
                }
            }
        });

        bouncingProgress.visible = false
    }

    Component.onCompleted: {
        get_stations()
    }

    ListModel {
        id: customModel
    }

    ListView {
        id: featuredChannelsList
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            bottomMargin: common_bmrgn
            top: customtab.header.bottom
            topMargin: units.gu(1)
        }
        clip: true
        model: customModel
        delegate: ListItem {
            id: featuredChannelsDelegate
            divider.visible: false
            height: entry_row.height

            property var removalAnimation

            leadingActions: ListItemActions {
                actions: [
                    Action {
                        iconName: "delete"
                        text: i18n.tr("Remove")
                        onTriggered: {
                            Scripts.delete_channel(id)
                            removalAnimation.start()
                        }
                    }
                ]
            }

            trailingActions: ListItemActions {
                delegate: Item {
                    width: units.gu(6)
                    Icon {
                        name: action.iconName
                        width: units.gu(2)
                        height: width
                        color: action.iconColor ? action.iconColor : UbuntuColors.darkGrey
                        anchors.centerIn: parent
                    }
                }
                actions: [
                    Action {
                        iconName: "edit"
                        text: i18n.tr("Edit")
                        onTriggered: {
                            pagestack.push(Qt.resolvedUrl("EditStation.qml"), {"radio_id": id})
                        }
                    }
                ]
            }

            removalAnimation: SequentialAnimation {
                alwaysRunToEnd: true

                PropertyAction {
                    target: featuredChannelsDelegate
                    property: "ListView.delayRemove"
                    value: true
                }

                UbuntuNumberAnimation {
                    target: featuredChannelsDelegate
                    property: "height"
                    to: 0
                }

                PropertyAction {
                    target: featuredChannelsDelegate
                    property: "ListView.delayRemove"
                    value: false
                }
            }

            Row {
                id: entry_row
                width: parent.width
                height: entry_column.height + units.gu(3)

                Item {
                    width: units.gu(1.5)
                    height: entry_column.height
                }

                UbuntuShape {
                    id: imageShape
                    anchors.verticalCenter: parent.verticalCenter
                    width: units.gu(6)
                    height: units.gu(6)
                    radius: "medium"
                    source: Image {
                        source: image
                    }
                }

                Column {
                    id: entry_column
                    spacing: units.gu(0.5)
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - units.gu(7.5)

                    Label {
                        id: titleEl
                        x: units.gu(1.5)
                        width: parent.width - units.gu(3)
                        text: title
                        fontSize: "medium"
                        wrapMode: Text.WordWrap
                    }

                    Label {
                        id: descriptionEl
                        x: units.gu(1.5)
                        width: parent.width - units.gu(3)
                        text: description
                        fontSize: "small"
                        wrapMode: Text.WordWrap
                        elide: Text.ElideRight
                        maximumLineCount: 2
                    }
                }
            }

            onClicked: {
                Scripts.play_custom_song(id, title, image, listen_url);
            }
        }
    }
}
