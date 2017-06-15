import React from "react"

import Chat from "./chat.js"
import Users from "./users.js"

let PointingParty = React.createClass({
  getInitialState() {
    return { }
  },

  componentDidMount() {
    this.props.channel.on("state", payload => {
      this.setState(payload)
    })
  },

  render() {
    return (
      <div>
        <Chat/>
        <Users/>
      </div>
    )
  }
})

export default PointingParty
