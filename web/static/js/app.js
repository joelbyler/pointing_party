import "phoenix_html"
import {Socket, Presence} from "phoenix"
import $ from "jquery"

if (window.userToken) {

  let user_token = window.userToken;
  let party_key = window.partyKey;

  let socket = new Socket("/socket", {params: {token: user_token}})

  socket.connect()

  let party = socket.channel("party:" + party_key, {})
  let presences = {}

  let listBy = (user, {metas: metas}) => {
    return {
      user: user,
      points: metas[0].points || ""
    }
  }

  let userList = document.getElementById("users")
  let render = (presences) => {
    userList.innerHTML = Presence.list(presences, listBy)
      .map(presence => `
        <li class="list-group-item list-group-item-action">${presence.user} [ ${presence.points} ]</a>
      `)
      .join("")
  }
  party.on("presence_state", state => {
    presences = Presence.syncState(presences, state)
    render(presences)
  })
  party.on("presence_diff", diff => {
    presences = Presence.syncDiff(presences, diff)
    render(presences)
  })
  party.join()

  // Chat
  let message_input = document.getElementById("message-input")
  message_input.addEventListener("keypress", (e) => {
    if (e.keyCode == 13 && message_input.value != "") {
      party.push("message:new", message_input.value)
      message_input.value = ""
    }
  })

  let message_list = document.getElementById("messages")
  let render_message = (message) => {
    let message_element = document.createElement("li")
    message_element.innerHTML = `
      <b>${message.user}</b>
      <p>${message.body}</p>
    `
    message_list.appendChild(message_element)
    message_list.scrollTop = message_list.scrollHeight;
  }
  party.on("message:new", message => render_message(message))

  $( ".btn-points" ).click(function() {
    let points = $(this).data("points")
    party.push("points:new", points)
  });

  $( "#btn-clear" ).click(function() {
    party.push("points:reset")
  });
}
