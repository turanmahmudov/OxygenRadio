import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQuick.LocalStorage 2.0
import QtQuick.XmlListModel 2.0
import QtMultimedia 5.4
import Ubuntu.Content 1.1
import Ubuntu.Components.Popups 1.3
import QtSystemInfo 5.0
import UserMetrics 0.1
import Qt.labs.settings 1.0 as AppSettings

import "components"
import "ui"
import "themes" as Themes

import "static/genres.js" as GenresJS
import "js/scripts.js" as Scripts
import "js/localdb.js" as LocalDB

MainView {
    id: mainView
    objectName: "mainView"

    applicationName: "oxygen.turan-mahmudov-l"
    automaticOrientation: true
    anchorToKeyboard: true

    width: units.gu(50)
    height: units.gu(75)

    AppSettings.Settings {
        id: startupSettings
        category: "StartupSettings"

        property bool darkTheme: false
        property bool disableScreenSleep: false
        property int tabIndex: 0
        property bool playLastPlayedChannel: false
        property var lastPlayedChannel
        property bool getCurrentSongInfo: true
    }

    // Themes
    Themes.ThemeManager {
        id: themeManager
        themes: [
            {name: i18n.tr('Light'), source: Qt.resolvedUrl('themes/Light.qml')},
            {name: i18n.tr('Dark'), source: Qt.resolvedUrl('themes/Dark.qml')}
        ]
        source: startupSettings.darkTheme == true ? "Dark.qml" : "Light.qml"
    }
    property alias currentTheme: themeManager.theme
    property var themeManager: themeManager
    theme.name: currentTheme.baseThemeName

    // Screen Sleep
    ScreenSaver {
        id: screenSaver
        screenSaverEnabled: startupSettings.disableScreenSleep == true ? false : true
    }

    // User metrics
    Metric {
        id: oxygenRadioMetrics
        name: "oxygen-radio-metrics"
        format: "<b>%1</b> " + i18n.tr("stations played today")
        emptyFormat: i18n.tr("No stations played today")
        domain: "oxygen.turan-mahmudov-l"
    }

    property var lastPlayedChannelTemp

    // Current channel
    property bool playing: false
    property var current_channel_id
    property var current_channel_uid
    property var current_channel_title
    property var current_channel_artist
    property var current_channel_image

    property var common_bmrgn : 0
    property string current_version: "0.3"

    // Main Actions for page header
    actions: [
        Action {
            id: searchAction
            text: i18n.tr("Search")
            iconName: "search"
            onTriggered: {
                pagestack.push(Qt.resolvedUrl("ui/Search.qml"))
            }
        },
        Action {
            id: settingsAction
            text: i18n.tr("Settings")
            iconName: "settings"
            onTriggered: {
                pagestack.push(Qt.resolvedUrl("ui/Settings.qml"))
            }
        },
        Action {
            id: addAction
            text: i18n.tr("New Station")
            iconName: "add"
            onTriggered: {
                pagestack.push(Qt.resolvedUrl("ui/NewStation.qml"))
            }
        }
    ]

    function home() {
        pagestack.clear()
        pagestack.push(tabs)

        // Play last played channel
        if (startupSettings.playLastPlayedChannel == true && startupSettings.lastPlayedChannel) {
            if (startupSettings.lastPlayedChannel.type == "existing") {
                Scripts.play_song(startupSettings.lastPlayedChannel.id, startupSettings.lastPlayedChannel.uid, startupSettings.lastPlayedChannel.title, startupSettings.lastPlayedChannel.image, startupSettings.lastPlayedChannel.playlist_url, startupSettings.lastPlayedChannel.listen_url);
            } else if (startupSettings.lastPlayedChannel.type == "custom") {
                Scripts.play_custom_song(startupSettings.lastPlayedChannel.id, startupSettings.lastPlayedChannel.title, startupSettings.lastPlayedChannel.image, startupSettings.lastPlayedChannel.listen_url);
            }
        }
    }

    PageStack {
        id: pagestack
        Component.onCompleted: home()
    }

    Tabs {
        id: tabs
        visible: false

        selectedTabIndex: startupSettings.tabIndex

        Tab {
            id: featuredChannelsTab

            FeaturedChannelsTab {
                id: featuredChannelsPage
            }
        }

        Tab {
            id: genresTab

            GenresTab {
                id: genresPage
            }
        }

        Tab {
            id: favoritesTab

            FavoritesTab {
                id: favoritesPage
            }
        }

        Tab {
            id: customTab

            CustomTab {
                id: customPage
            }
        }
    }

    Page {
        id: genre
        visible: false

        header: PageHeader {
            title: i18n.tr("Genre")
            trailingActionBar {
                numberOfSlots: 2
                actions: [settingsAction, searchAction]
            }
        }

        GenrePage {
            id: genrePage
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                bottomMargin: common_bmrgn
                top: genre.header.bottom
                topMargin: 0
            }
        }
    }

    Page {
        id: nowPlayingPage
        visible: false

        header: PageHeader {
            title: i18n.tr("Now Playing")
        }
    }

    // Share dialog for sharing url to other apps
    Component {
        id: shareDialog
        ContentShareDialog { }
    }
    Component {
        id: shareComponent
        ContentItem { }
    }

    BouncingProgressBar {
        id: bouncingProgress
        z: 10
        anchors.top: parent.top
        anchors.topMargin: units.gu(6)
        visible: false
    }

    // Player panel
    Rectangle {
        id: playerpanel
        z: 100000
        width: parent.width
        height: units.gu(7)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: units.gu(-7)
        color: "#191E28"
        Image {
            anchors.left: parent.left
            anchors.leftMargin: units.gu(1)
            anchors.top: parent.top
            anchors.topMargin: units.gu(1)
            height: source ? units.gu(5) : 0
            width: source ? height : 0
            id: panel_track_image
        }
        Label {
            id: panel_track_title
            color: "white"
            font.bold: true
            fontSize: "medium"
            anchors.top: parent.top
            anchors.topMargin: units.gu(1)
            anchors.left: panel_track_image.source != "" ? panel_track_image.right : parent.left
            anchors.leftMargin: units.gu(1)
            width: parent.width-controlsrow.width-units.gu(7)
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
            maximumLineCount: 1
        }
        Label {
            id: panel_track_artist
            color: "white"
            fontSize: "small"
            anchors.top: panel_track_title.bottom
            anchors.topMargin: units.gu(0.5)
            anchors.left: panel_track_image.source != "" ? panel_track_image.right : parent.left
            anchors.leftMargin: units.gu(1)
            width: parent.width-controlsrow.width-units.gu(7)
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
            maximumLineCount: 1
        }

        Row {
            id: controlsrow
            z: 100000
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            Rectangle {
                z: 100000
                width: units.gu(5)
                height: playerpanel.height
                color: "transparent"
                Icon {
                    id: play_button
                    name: player.playbackState === MediaPlayer.PlayingState ? "media-playback-pause" : "media-playback-start"
                    color: "#fff"
                    width: units.gu(4)
                    height: width
                    anchors.centerIn: parent
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (player.playbackState === MediaPlayer.PlayingState) {
                            player.stop()
                        } else {
                            player.play()
                        }
                    }
                }
            }
        }
    }
    NumberAnimation { id: playeropen; target: playerpanel; property: "anchors.bottomMargin"; duration: 200; from: units.gu(-7); to: 0; }

    Timer {
        id: timer
        repeat: false
        interval: 1000
        running: false

        property var ruid

        onTriggered: {
            Scripts.get_current_song(ruid)
        }
    }

    Audio {
        id: player
        autoLoad: false
        onVolumeChanged: { }
        onSourceChanged: { }
        onStopped: {
            startupSettings.lastPlayedChannel = {}
        }
        onPlaying: {
            startupSettings.lastPlayedChannel = lastPlayedChannelTemp
        }
        onPositionChanged: { }
        onBufferProgressChanged: { }
        onPlaybackStateChanged: { }
        onStatusChanged: {
            if (player.status === Audio.Buffered) {
                bouncingProgress.visible = false
            } else if (player.status == Audio.EndOfMedia) {
            } else if (player.status == Audio.Loaded) {
            } else if (player.status == Audio.InvalidMedia) {
            } else {
            }
        }
        onError: {
        }
    }
}
