// DB
function init() {
    var db = LocalStorage.openDatabaseSync("oxygenradio", "1.0", "Database for Oxygen Radio", "1000000");

    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS user(key TEXT UNIQUE, value TEXT)');

        tx.executeSql('CREATE TABLE IF NOT EXISTS Favorites(channel_id INT UNIQUE, channel_ruid TEXT)');
        tx.executeSql('CREATE TABLE IF NOT EXISTS Custom(channel_id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, listen_url TEXT, description TEXT, image TEXT)');
    });

    return db;
}
