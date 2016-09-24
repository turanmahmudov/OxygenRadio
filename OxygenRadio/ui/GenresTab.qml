import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQuick.LocalStorage 2.0
import QtQuick.XmlListModel 2.0
import Ubuntu.Components.ListItems 1.3 as ListItem

import "../components"

import "../static/genres.js" as GenresJS
import "../js/scripts.js" as Scripts
import "../js/localdb.js" as LocalDB

Page {
    id: genres

    TabsList {
        id: tabsList
    }

    header: PageHeader {
        title: i18n.tr("Genres")
        leadingActionBar {
            actions: tabsList.actions
        }
        trailingActionBar {
            numberOfSlots: 2
            actions: [settingsAction, searchAction]
        }
    }

    Component.onCompleted: {
        home()
    }

    function home() {
        var genresData = GenresJS.genresData;
        var i;
        for (i in genresData) {
            genresModel.append({"tag": genresData[i][1], "title": genresData[i][0]});
        }
    }

    ListModel {
        id: genresModel
    }

    ListView {
        id: genresList
        anchors {
            fill: parent
            topMargin: units.gu(1)
            bottomMargin: common_bmrgn
        }
        clip: true
        model: genresModel
        delegate: ListItem.Empty {
            id: genresDelegate
            divider.visible: true
            height: entry_row.height

            Row {
                id: entry_row
                width: parent.width
                height: entry_column.height + units.gu(3)

                Column {
                    id: entry_column
                    spacing: units.gu(0.5)
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width

                    Label {
                        id: titleEl
                        x: units.gu(1.5)
                        width: parent.width - units.gu(3)
                        text: title
                        fontSize: "medium"
                        wrapMode: Text.WordWrap
                    }
                }
            }

            onClicked: {
                genre.header.title = title;
                genrePage.get_stations(tag)
                pagestack.push(genre);
            }
        }
    }
}
