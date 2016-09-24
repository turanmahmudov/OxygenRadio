import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQuick.LocalStorage 2.0
import QtQuick.XmlListModel 2.0
import Ubuntu.Content 1.1
import Ubuntu.Components.Popups 1.3

import "../components"

import "../js/scripts.js" as Scripts
import "../js/localdb.js" as LocalDB

Page {
    id: search

    TabsList {
        id: tabsList
    }

    header: PageHeader {
        title: i18n.tr("Search")
        contents: Rectangle {
            color: "transparent"
            anchors.fill: parent
            TextField {
                id: searchField
                anchors {
                    right: parent.right
                    rightMargin: units.gu(2)
                    centerIn: parent
                }
                hasClearButton: true
                inputMethodHints: Qt.ImhNoPredictiveText
                placeholderText: i18n.tr("Search")
                onVisibleChanged: {
                    if (visible) {
                        forceActiveFocus()
                    }
                }
                onTextChanged: {
                    get_stations(searchField.text)
                }
                onAccepted: {
                    get_stations(searchField.text)
                }
            }
        }
    }

    function get_stations(search_text) {
        bouncingProgress.visible = true

        searchModel.clear()

        var i=0;
        for (i = 0; i < xmlModel.count; i++) {
            var id = xmlModel.get(i).id;
            var featured = xmlModel.get(i).featured; // this should come from local db
            var title = xmlModel.get(i).title;
            var playlist_url = xmlModel.get(i).playlist_url;
            var listen_url = xmlModel.get(i).listen_url;
            var description = xmlModel.get(i).description;
            var image = xmlModel.get(i).image;
            var uid = xmlModel.get(i).uid;
            var genre = xmlModel.get(i).genre;
            var stars = xmlModel.get(i).stars;

            if (title.toLowerCase().search(search_text.toLowerCase()) != -1 || genre.search(search_text.toLowerCase()) != -1) {
                var is_favorited = false;
                var db = LocalDB.init();
                db.transaction(function(tx) {
                    var rs = tx.executeSql("SELECT channel_id FROM Favorites WHERE channel_id = ?", id);
                    if (rs.rows.length === 0) {
                        is_favorited = false;
                    } else {
                        is_favorited = true;
                    }
                });

                searchModel.append({"id": id, "title": title, "description": description, "image": image, "playlist_url": playlist_url, "listen_url": listen_url, "uid": uid, "stars": stars, "featured": featured, "is_favorited": is_favorited});
            }
        }

        // Sort for stars
        var n;
        var j;
        for (n=0; n < searchModel.count; n++) {
            for (j=n+1; j < searchModel.count; j++)
            {
                if (searchModel.get(n).stars < searchModel.get(j).stars) {
                    searchModel.move(j, n, 1);
                    n=0;
                }
            }
        }

        bouncingProgress.visible = false
    }

    ListModel {
        id: searchModel
    }

    XmlListModel {
        id: xmlModel
        source: Qt.resolvedUrl("../static/newstations.xml")
        query: "/stations/station"
        XmlRole { name: "id"; query: "@id/string()" }
        XmlRole { name: "featured"; query: "boolean(@featured)" }
        XmlRole { name: "title"; query: "name/string()" }
        XmlRole { name: "playlist_url"; query: "playlist_url/string()" }
        XmlRole { name: "listen_url"; query: "listen_url/string()" }
        XmlRole { name: "description"; query: "description/string()" }
        XmlRole { name: "image"; query: "image/string()" }
        XmlRole { name: "uid"; query: "uid/string()" }
        XmlRole { name: "genre"; query: "genre[1]/string()" }
        XmlRole { name: "stars"; query: "stars/number()" }
    }

    ListView {
        id: featuredChannelsList
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            bottomMargin: common_bmrgn
            top: search.header.bottom
            topMargin: units.gu(1)
        }
        clip: true
        model: searchModel
        delegate: ListItem {
            id: featuredChannelsDelegate
            divider.visible: false
            height: entry_row.height

            property var removalAnimation

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
                        iconName: "like"
                        property var iconColor: is_favorited ? UbuntuColors.red : UbuntuColors.lightGrey
                        text: i18n.tr("Favorite")
                        onTriggered: {
                            if (is_favorited) {
                                Scripts.fav_channel(id, 0)
                                searchModel.setProperty(index, "is_favorited", false)
                            } else {
                                Scripts.fav_channel(id, 1)
                                searchModel.setProperty(index, "is_favorited", true)
                            }
                        }
                    },
                    Action {
                        iconName: "share"
                        text: i18n.tr("Share")
                        onTriggered: {
                            // Share radio
                            PopupUtils.open(shareDialog, pagestack, {"contentType": ContentType.Links, "path": listen_url});
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
                Scripts.play_song(id, uid, title, image, playlist_url, listen_url);
            }
        }
    }
}
