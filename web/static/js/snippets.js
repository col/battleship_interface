var phoenix = require('phoenix')

var socket = new phoenix.Socket("/socket", {})
socket.connect()

function new_channel(subtopic, screen_name) {
  return socket.channel("game:"+subtopic, {screen_name: screen_name})
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

function say_hello(channel, greating) {
    channel.push("hello", {"message": greating}).receive("ok", response => {
      console.log("Hello", response.message)
    }).receive("error", response => {
      console.log("Unable to say hello to the channel.", response.reason)
    })
}

var game_channel = new_channel("moon", "moon")

game_channel.on("said_hello", response => {
  console.log("Returned Greeting:", response.message)
})

join(game_channel)
// say_hello(game_channel, "World!")
