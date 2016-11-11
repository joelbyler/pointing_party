import "phoenix_html"
import {Socket, Presence} from "phoenix"


if (window.userToken) {

  let user_token = window.userToken;
  let party_token = window.partyToken;

  let socket = new Socket("/socket", {params: {token: user_token}})

  socket.connect()

  let party = socket.channel("party:" + party_token, {})
  let presences = {}

  let listBy = (user, {metas: metas}) => {
    return {
      user: user,
    }
  }

  let userList = document.getElementById("users")
  let render = (presences) => {
    userList.innerHTML = Presence.list(presences, listBy)
      .map(presence => `
        <li><b>${presence.user}</b></li>
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
}
