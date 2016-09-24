import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
import Ubuntu.Components.Popups 1.3

Page {
    id: creditsPage
    header: PageHeader {
        title: i18n.tr("Credits")
    }

    Flickable {
        id: flickable
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            bottomMargin: common_bmrgn
            top: creditsPage.header.bottom
            topMargin: units.gu(1)
        }
        contentHeight: columnSuperior.height

        Column {
           id: columnSuperior
           width: parent.width

           ListItem.Header {
               text: i18n.tr("Creator")
           }

           ListItem.Base {
               width: parent.width
               progression: true
               showDivider: false
               onClicked: {
                   Qt.openUrlExternally("mailto:turan.mahmudov@gmail.com")
               }
               Column {
                   anchors.verticalCenter: parent.verticalCenter
                   anchors.right: parent.right
                   anchors.left: parent.left
                   Label {
                       width: parent.width
                       wrapMode: Text.WordWrap
                       text: "Turan Mahmudov"
                   }

                   Label {
                       fontSize: "small"
                       color: UbuntuColors.darkGrey
                       width: parent.width
                       wrapMode: Text.WordWrap
                       elide: Text.ElideRight
                       text: "turan.mahmudov@gmail.com"
                   }
               }
           }

           ListItem.Header {
               text: i18n.tr("Developers")
           }

           ListItem.Base {
               width: parent.width
               progression: true
               showDivider: false
               onClicked: {
                   Qt.openUrlExternally("mailto:turan.mahmudov@gmail.com")
               }
               Column {
                   anchors.verticalCenter: parent.verticalCenter
                   anchors.right: parent.right
                   anchors.left: parent.left
                   Label {
                       width: parent.width
                       wrapMode: Text.WordWrap
                       text: "Turan Mahmudov"
                   }

                   Label {
                       fontSize: "small"
                       color: UbuntuColors.darkGrey
                       width: parent.width
                       wrapMode: Text.WordWrap
                       elide: Text.ElideRight
                       text: "turan.mahmudov@gmail.com"
                   }
               }
           }
        }
    }
}
