enum ConnectionRequest {
  sent,
  came,
  connected,
  accepted,
  rejected,
  notconnected
}

enum GameStatus { paused, running, completed }

enum PlayerStatus { playing, available, none }

enum PlayerInRoomStatus { joined, leaved }

PlayerStatus playerStatusFromName(String status) {
  switch (status) {
    case "playing":
      return PlayerStatus.playing;
      break;
    case "available":
      return PlayerStatus.available;
      break;
    case "none":
      return PlayerStatus.none;
      break;
    default:
      return PlayerStatus.none;
  }
}

ConnectionRequest parseConnectionRequest(String str) {
  switch (str.toLowerCase()) {
    case "sent":
      return ConnectionRequest.sent;
    case "came":
      return ConnectionRequest.came;
    case "connected":
      return ConnectionRequest.connected;
    case "accepted":
      return ConnectionRequest.accepted;
    case "rejected":
      return ConnectionRequest.rejected;
    case "notconnected":
      return ConnectionRequest.notconnected;
    default:
      return ConnectionRequest.notconnected;
  }
}
