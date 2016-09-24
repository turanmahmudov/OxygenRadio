TEMPLATE = aux
TARGET = OxygenRadio

RESOURCES += OxygenRadio.qrc

QML_FILES += $$files(*.qml,true) \
             $$files(*.js,true)

CONF_FILES +=  OxygenRadio.apparmor \
               OxygenRadio.png

AP_TEST_FILES += tests/autopilot/run \
                 $$files(tests/*.py,true)

IMG_FILES += $$files(*.png,true)

XML_FILES += $$files(*.xml,true) \
             $$files(*.js,true)

OTHER_FILES += $${CONF_FILES} \
               $${QML_FILES} \
               $${AP_TEST_FILES} \
               OxygenRadio.desktop

#specify where the qml/js files are installed to
qml_files.path = /OxygenRadio
qml_files.files += $${QML_FILES}

js_files.path = /OxygenRadio/js
js_files.files += $${QML_FILES}

ui_files.path = /OxygenRadio/ui
ui_files.files += $${QML_FILES}

components_files.path = /OxygenRadio/components
components_files.files += $${QML_FILES}

img_files.path = /OxygenRadio/img
img_files.files += $${IMG_FILES}

static_files.path = /OxygenRadio/static
static_files.files += $${XML_FILES}

themes_files.path = /OxygenRadio/themes
themes_files.files +=$${QML_FILES}

#specify where the config files are installed to
config_files.path = /OxygenRadio
config_files.files += $${CONF_FILES}

#install the desktop file, a translated version is 
#automatically created in the build directory
desktop_file.path = /OxygenRadio
desktop_file.files = $$OUT_PWD/OxygenRadio.desktop
desktop_file.CONFIG += no_check_exist

INSTALLS+=config_files qml_files js_files ui_files components_files img_files static_files themes_files desktop_file

DISTFILES += \
    ui/FeaturedChannelsTab.qml \
    js/scripts.js \
    components/TabsList.qml \
    ui/GenresTab.qml \
    ui/FavoritesTab.qml \
    js/localdb.js \
    ui/GenrePage.qml \
    static/genres.js \
    static/newstations.xml \
    components/BouncingProgressBar.qml \
    ui/CustomTab.qml \
    ui/Search.qml \
    ui/Settings.qml \
    ui/About.qml \
    ui/NewStation.qml \
    ui/EditStation.qml \
    components/ContentShareDialog.qml \
    ui/Credits.qml

