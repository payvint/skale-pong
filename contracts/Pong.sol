pragma solidity >=0.4.24;

contract Pong {

  uint public constant MAX_POINT = 3;

  struct MultiPlayer {
    bool status;
    string name;
    uint bid;
    address player1;
    uint x1;
    address player2;
    uint x2;
    address ball;
    uint points1;
    uint points2;
  }

  uint public platformX = 450;

  mapping(bytes32 => MultiPlayer) public games;

  event RoomCreated (
    string name,
    address player1,
    uint bid,
    address ball
  );

  constructor () {

  }

  function createMultiPlayerGame(string roomName, address ballAddress) public payable {
    bytes32 index = keccak256(abi.encodePacked(roomName));
    require(!games[index].status, "Room is active");
    games[index] = MultiPlayer({
      status: true,
      name: roomName,
      bid: msg.value,
      player1: msg.sender,
      x1: 0,
      player2: address(0),
      x2: 0,
      ball: ballAddress,
      points1: 0,
      points2: 0
    });
    emit RoomCreated(roomName, msg.sender, msg.value, ballAddress);
  }

  function joinMultiPlayerGame(string roomName) public payable {
    bytes32 index = keccak256(abi.encodePacked(roomName));
    require(games[index].status, "Room is not active");
    require(games[index].player2 == address(0), "Room is busy");
    require(games[index].bid == msg.value, "Your bid is not equal to game bid");
    games[index].player2 = msg.sender;
    games[index].status = false;
  }

  /*function ballAtPlatformPlace(string roomName, uint x, uint y) public returns (bool) {
    bytes32 index = keccak256(abi.encodePacked(roomName));
    require(games[index].status, "Room is not active");
    require(games[index].player2 != address(0), "Game is not started");
    require(games[index].ball == msg.sender, "Sender is not a ball");
    if (y == 0) {
      if (games[index].x1 + 50 <= x && games[index].x1 - 50 >= x) [
        return true;
      ] else return false;
    } else if (y == 1000) {
      if (games[index].x2 + 50 <= x && games[index].x2 - 50 >= x) [
        return true;
      ] else return false;
    } else {
      revert();
    }

  }*/

  function movePlatform(bytes32 gameIndex, uint x) {
      if (games[gameIndex].player1 == msg.sender) {
        games[gameIndex].x1 = x;
      } else if (games[gameIndex].player2 == msg.sender) {
        games[gameIndex].x2 = x;
      } else {
        revert();
      }
  }

  function testMovePlatform(uint x) {
    platformX = x;
  }

}
