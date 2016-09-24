function get_current_song(radio_uid) {
    timer.stop()

    var url = "https://www.radionomy.com/en/OnAir/GetCurrentSong";

    var xhr = new XMLHttpRequest;
    xhr.open("POST", url);

    xhr.setRequestHeader("Content-type","application/x-www-form-urlencoded; charset=UTF8");
    xhr.setRequestHeader("X-Accept", "application/json");

    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            var all_res = xhr.responseText;
            var parsed_res;

            var n = all_res.lastIndexOf('</html>');

            if (n != -1) {
                var m = n+7;
                var res = all_res.substr(m);
                parsed_res = JSON.parse(JSON.parse(res));
            } else {
                parsed_res = JSON.parse(JSON.parse(all_res));
            }

            //console.log(JSON.stringify(parsed_res))

            current_channel_artist = parsed_res.Title ? (parsed_res.Artist ? (parsed_res.Artist + ' - ' + parsed_res.Title) : parsed_res.Title) : i18n.tr("Unknown")
            panel_track_artist.text = current_channel_artist
            panel_track_image.source = parsed_res.TrackCover ? parsed_res.TrackCover : current_channel_image

            //bouncingProgress.visible = false

            if (parsed_res.Duration != 0) {
                timer.ruid = radio_uid;
                timer.interval = parseInt(parsed_res.Callback);
                timer.start();
            }
        }
    }

    var data = "radioUID="+radio_uid+"&f=s";

    xhr.send(data);
}

function get_playable_url_by_m3u(playlist_url, callback) {
    var playlist_url_split = playlist_url.split('.');
    if (playlist_url_split[playlist_url_split.length-1] != "m3u") {
        callback([playlist_url]);
    }

    var xhr = new XMLHttpRequest;
    xhr.open("GET", playlist_url);

    xhr.setRequestHeader("X-Accept", "application/json");

    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            var lines = xhr.responseText.split('\n');

            callback(lines);
        }
    }

    xhr.send();
}

function play_song(id, uid, title, image, playlist_url, listen_url) {
    bouncingProgress.visible = true;

    // get playable url from m3u
    get_playable_url_by_m3u(listen_url, function(lines) {
        current_channel_id = id
        current_channel_uid = uid
        current_channel_title = title
        current_channel_image = image

        current_channel_artist = i18n.tr("Unknown")

        panel_track_artist.text = current_channel_artist
        panel_track_title.text = current_channel_title
        panel_track_image.source = image

        player.source = lines[0]
        player.stop();
        player.play();

        oxygenRadioMetrics.increment();

        if (playing == false) {
            playing = true
            playeropen.start()
            common_bmrgn = units.gu(7);
        }

        if (startupSettings.playLastPlayedChannel == true) {
            startupSettings.lastPlayedChannel = {"id": id, "uid": uid, "title": title, "image": image, "playlist_url": playlist_url, "listen_url": listen_url, "type": "existing"}
            lastPlayedChannelTemp = startupSettings.lastPlayedChannel
        } else {
            startupSettings.lastPlayedChannel = {}
            lastPlayedChannelTemp = startupSettings.lastPlayedChannel
        }

        if (startupSettings.getCurrentSongInfo == true) {
            get_current_song(uid)
        }

        // delete after buffer fix
        bouncingProgress.visible = false;
    });
}

function play_custom_song(id, title, image, listen_url) {
    timer.stop()

    bouncingProgress.visible = true;

    // get play
    current_channel_id = id
    current_channel_uid = ''
    current_channel_title = title
    current_channel_image = image

    current_channel_artist = i18n.tr("Unknown")

    panel_track_artist.text = current_channel_artist
    panel_track_title.text = current_channel_title
    panel_track_image.source = image

    player.source = listen_url
    player.stop();
    player.play();

    if (playing == false) {
        playing = true
        playeropen.start()
        common_bmrgn = units.gu(7);
    }

    if (startupSettings.playLastPlayedChannel == true) {
        startupSettings.lastPlayedChannel = {"id": id, "title": title, "image": image, "listen_url": listen_url, "type": "custom"}
        lastPlayedChannelTemp = startupSettings.lastPlayedChannel
    } else {
        startupSettings.lastPlayedChannel = {}
        lastPlayedChannelTemp = startupSettings.lastPlayedChannel
    }

    // delete after buffer fix
    bouncingProgress.visible = false;
}

function fav_channel(channel_id, val) {
    if (val == '1') {
        var db = LocalDB.init();
        db.transaction(function(tx) {
            var rs = tx.executeSql("INSERT INTO Favorites(channel_id) VALUES(?)", channel_id);
        });
    } else {
        var db = LocalDB.init();
        db.transaction(function(tx) {
            var rs = tx.executeSql("DELETE FROM Favorites WHERE channel_id = ?", channel_id);
        });
    }
}

function delete_channel(channel_id) {
    var db = LocalDB.init();
    db.transaction(function(tx) {
        var rs = tx.executeSql("DELETE FROM Custom WHERE channel_id = ?", channel_id);
    });
}

function add_custom_radio() {
    bouncingProgress.visible = true;

    var db = LocalDB.init();
    db.transaction(function(tx) {
        var rs = tx.executeSql("INSERT INTO Custom(title, listen_url, description, image) VALUES(?, ?, ?, ?)", [nameOfStation.text, urlOfStation.text, descriptionOfStation.text, logoOfStation.text]);

        bouncingProgress.visible = false;
        pagestack.pop();
        customPage.get_stations()

    });
}

function edit_custom_radio(radio_id) {
    bouncingProgress.visible = true;

    var db = LocalDB.init();
    db.transaction(function(tx) {
        var rs = tx.executeSql("UPDATE Custom SET title = ?, listen_url = ?, description = ?, image = ? WHERE channel_id = ?", [nameOfStation.text, urlOfStation.text, descriptionOfStation.text, logoOfStation.text, radio_id]);

        bouncingProgress.visible = false;
        pagestack.pop();
        customPage.get_stations()

    });
}
