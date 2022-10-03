pragma solidity ^0.8.11;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

 contract PlayerMarketplace is Ownable,ERC1155,ERC1155Holder{
  address public SQUAD;
  uint public DEADLINE;
  uint private divisor = 10;
   mapping(uint => Player)private players;
   mapping(uint => uint)private playerPrice;
   mapping(uint => bool)private PositionSet;
   mapping(address => uint)private NetSpend;
   mapping(address => uint[])private MyTeam;

    enum Positions{
        Goalkeeper,
        Defender,
        Midfielder,
        Foward
    }
  struct Player{
    Positions position;
    uint tokenID;
    uint price;
  }
  
    constructor(address _squad)
    ERC1155("SET THIS"){
 
      SQUAD = _squad;
    }

    function MintPlayers(uint[]memory id,uint[] memory position,uint[] memory amount,uint[]memory price)onlyOwner public{
    require(id.length == position.length,"Invalid Team Size");
    require(position.length == amount.length,"Invalid Team Size");
    _mintBatch(address(this),id,amount,"");
    for(uint i = 0; i< id.length; i++){
      if(!PositionSet[id[i]]){
        _SetPosition(id[i],position[i],price[i]/divisor);
        playerPrice[id[i]] = price[i]/divisor;
        PositionSet[id[i]] = true;
      }
    }
    }
    function SelectSquad(uint[]memory id,uint[]memory position,uint[]memory amount)public{
      require(block.timestamp > DEADLINE,"DEADLINE Passed");
      require(id.length == position.length,"Invalid Team size");
      require(id.length == 15,"Invalid Squad size"); 
      _safeBatchTransferFrom(address(this),msg.sender,id,amount,"");
      for(uint256 i = 0; i<id.length; i++){
        MyTeam[msg.sender].push(id[i]);
      }
    }

    function SelectTeam(uint[]memory id,uint[]memory position,uint[]memory amount)public{
      require(block.timestamp > DEADLINE,"DEADLINE Passed");
      require(id.length == 11,"Invalid Squad size");
      require(id.length ==position.length,"Invalid Squad Size");
       for(uint i = 0; i < MyTeam[msg.sender].length; i++){
      if(MyTeam[msg.sender][i] == id[i]){
      revert("Already picked player");
  }
    _safeBatchTransferFrom(address(this),msg.sender,id,amount,"");
 }
    }
    function _SetPosition(uint _ID,uint _position,uint _price)internal{
      require(_position == 0 ||_position  == 1 || _position== 2 || _position == 3);
      if(_position == 0){
        players[_ID].position = Positions.Goalkeeper;
        players[_ID].tokenID = _ID;
        players[_ID].price = _price;
      }
      else if(_position == 1){
        players[_ID].position = Positions.Defender;
        players[_ID].tokenID = _ID;
        players[_ID].price = _price;
      }
       else if(_position == 2){
        players[_ID].position = Positions.Midfielder;
        players[_ID].tokenID = _ID;
        players[_ID].price = _price;
      }
       else{
        players[_ID].position = Positions.Foward;
        players[_ID].tokenID = _ID;
        players[_ID].price = _price;
      }
    }
 function ViewPlayerByID(uint8 _ID)public view returns(Player memory){
  require(players[_ID].price != 0);
  return players[_ID];
 }
 function ViewTeam()public view returns(uint[]memory){
  require(MyTeam[msg.sender].length != 0,"No Team");
  return MyTeam[msg.sender]; 
 }
 function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155,ERC1155Receiver) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
    function SetDeadline(uint _time)public onlyOwner{
      require(_time != 0);
      DEADLINE = _time + block.timestamp;
    }
    function ViewSquadValue()public view returns(uint){
      return NetSpend[msg.sender];
    }
 }