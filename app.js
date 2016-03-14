var express = require('express'),
    playlist = require('./routes/playlists');
    //song = require('./routes/songs');
var body_parser = require('body-parser');
var logger = require('morgan');

var app = express();
app.use(logger('dev'));
app.use(body_parser.json());
app.use(body_parser.urlencoded({
    extended: true
}));

app.get('/routes/routes/playlists', playlist.findAll);
app.get('/routes/playlists/:id', playlist.findById);
app.post('/routes/playlists', playlist.addPlaylist);
app.put('/routes/playlists/:id/changeSong', playlist.updatePlaylistSong);
app.put('/routes/playlists/:id', playlist.updatePlaylist);
app.put('/routes/playlists/:id/loadSongs', playlist.loadSongs);
app.put('/routes/playlists/:id/addSong', playlist.addSong);
app.put('/routes/playlists/:id/upvote', playlist.upvote);
app.put('/routes/playlists/:id/downvote', playlist.downvote);
app.delete('/routes/playlists/:id', playlist.deletePlaylist);




//app.listen(3000);
//console.log('Listening on port 3000...');
var port = process.env.PORT || 8080;

app.listen(port, function() {
    console.log('Our app is running on http://localhost:' + port);
});