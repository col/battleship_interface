var phoenix = require('phoenix')

var socket = new phoenix.Socket("/socket", {})
socket.connect()

function new_channel(subtopic) {
  return socket.channel("game:"+subtopic, {})
}

function join(channel) {
  channel.join().receive("ok", response => {
    console.log("Joined successfully!", response)
  }).receive("error", response => {
    console.log("Unable to join", response)
  })
}

function leave(channel) {
  channel.leave().receive("ok", response => {
    console.log("Left sucessfully", response)
  }).receive("error", response => {
    console.log("Unable to leave", response)
  })
}

function new_game(channel) {
  channel.push("new_game").receive("ok", response => {
    console.log("New Game!", response)
  }).receive("error", response => {
    console.log("Unable to start a new game.", response)
  })
}

function add_player(channel, player) {
  channel.push("add_player", player).receive("error", response => {
    console.log("Unable to add new player: "+player, response)
  })
}

function set_ship_coordinates(channel, player, ship, coordinates) {
  var params = {"player": player, "ship": ship, "coordinates": coordinates}
  channel.push("set_ship_coordinates", params).receive("ok", response => {
    console.log("New coordinates set!", response)
  }).receive("error", response => {
    console.log("Unable to set new coordinates.", response)
  })
}

function set_ships(channel, player) {
  channel.push("set_ships", player).receive("error", response => {
    console.log("Unable to set ships for player: "+player, response)
  })
}

export var GameChannel = {
  connect: function(name) {
    var game_channel = new_channel(name)

    game_channel.on("player_added", response => {
      console.log("Player Added", response)
    })

    game_channel.on("player_set_ships", response => {
      console.log("Player Set Ships", response)
    })

    join(game_channel)
    return game_channel
  },
  new_game: new_game,
  add_player: add_player,
  set_ship_coordinates: set_ship_coordinates,
  set_ships: set_ships
}
