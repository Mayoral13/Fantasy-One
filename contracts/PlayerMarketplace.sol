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
   mapping(address => uint[])private MySquad;
   mapping(address => uint[])private MyTeam;
   mapping(address =>mapping(uint => bool))private OwnPlayer;

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
      require(NetSpend[msg.sender] < 100,"Balance Exceeded");
      require(id.length == position.length,"Invalid Team size");
      require(id.length == 15,"Invalid Squad size"); 
      _safeBatchTransferFrom(address(this),msg.sender,id,amount,"");
      for(uint256 i = 0; i<id.length; i++){
        require(IERC20(SQUAD).balanceOf(msg.sender) >= playerPrice[id[i]]);
        NetSpend[msg.sender] += playerPrice[id[i]];
        MySquad[msg.sender].push(id[i]);
        IERC20(SQUAD).transferFrom(msg.sender,address(this),playerPrice[id[i]]);
        OwnPlayer[msg.sender][id[i]] = true;
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
 function ViewSquad()public view returns(uint[]memory){
  require(MySquad[msg.sender].length != 0,"No Team");
  return MySquad[msg.sender]; 
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
    function ViewTeam()public view returns(uint[]memory){
     return MyTeam[msg.sender];
    }
    function SubmitTeam()public{
      uint id = 0;
      uint amount = 100;
      require(block.timestamp > DEADLINE,"DEADLINE Passed");
      require(MyTeam[msg.sender].length == 11,"Incomplete Team");
      require(MySquad[msg.sender].length == 15,"Incomplete Squad");
     _mint(msg.sender,id,amount,"Baller Rewards");
    }
    function RemovePlayer(uint _id)public{
      require(block.timestamp > DEADLINE,"DEADLINE Passed");
      require(OwnPlayer[msg.sender][_id] == true,"You do not own player");
      for(uint i = 0; i < MyTeam[msg.sender].length; i++){
      if(MyTeam[msg.sender][i] == _id){
       MyTeam[msg.sender].pop();
      }
     }
    }
     function SelectPlayers(uint id)public{
      require(OwnPlayer[msg.sender][id] == true,"You do not own player");
      require(block.timestamp > DEADLINE,"DEADLINE Passed");
       for(uint i = 0; i < MyTeam[msg.sender].length; i++){
      if(MyTeam[msg.sender][i] == id){
       revert("Already picked player");
      }
     }
      MyTeam[msg.sender].push(id);
    }
 }