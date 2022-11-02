pragma solidity ^0.8.11;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

 contract PlayerMarketplace is Ownable,ERC1155,ERC1155Holder{
  address public SQUAD;
  uint public DEADLINE;
  uint private divisor = 10;
    mapping (uint256 => string) private _uris;
   mapping(uint => Player)private players;
   mapping(uint => uint)private playerPrice;
   mapping(uint => bool)private PositionSet;
   mapping(address => uint)private NetSpend;
   mapping(address => uint[])private MySquad;
   mapping(address => uint[])private MyTeam;
   mapping(address =>mapping(uint => bool))private OwnPlayer;
   mapping(address =>mapping(uint => bool))private InTeam;
   event playerRemoved(uint id);
   event playerSelected(uint id);
   event teamSubmitted(uint when,address who);

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
    ERC1155("https://gateway.pinata.cloud/ipfs/QmNktTRfCjjiEAvmHxqw4UnZhJ25mjmqxwrbrGNAp5yD81/{id}.json"){
 
      SQUAD = _squad;
    }
    function uri(uint256 tokenId) override public view returns (string memory) {
        return(_uris[tokenId]);
    }
    
    function setTokenUri(uint256 tokenId, string memory _uri) public onlyOwner {
        require(bytes(_uris[tokenId]).length == 0, "Cannot set uri twice"); 
        _uris[tokenId] = _uri; 
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
    function SelectSquad(uint id)public{
      uint price = playerPrice[id];
      uint amount = 1;
      require(OwnPlayer[msg.sender][id] == false,"You own player");
      require(block.timestamp > DEADLINE,"DEADLINE Passed");
      require(MySquad[msg.sender].length <= 14,"Limit reached");
      require(NetSpend[msg.sender] < 100,"Balance Exceeded");
        require(IERC20(SQUAD).balanceOf(msg.sender) >= price);
         _safeTransferFrom(address(this),msg.sender,id,amount,"");
        NetSpend[msg.sender] += price;
        MySquad[msg.sender].push(id);
       IERC20(SQUAD).transferFrom(msg.sender,address(this),(price* (10 ** 18)));
        OwnPlayer[msg.sender][id] = true;
        emit playerSelected(id);
      }
    
      function SelectPlayers(uint id)public view returns(bool){
      require(OwnPlayer[msg.sender][id] == true,"You do not own player");
      require(block.timestamp > DEADLINE,"DEADLINE Passed");
      /* for(uint i = 0; i < MyTeam[msg.sender].length; i++){
      if(MyTeam[msg.sender][i] == id){
       _RemovePlayer(id);
      }
     }
      MyTeam[msg.sender].push(id);
      InTeam[msg.sender][id] = true;
      emit playerSelected(id);
      */
     return OwnPlayer[msg.sender][id];
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
   
    function SubmitTeam()public{
      uint id = 0;
      uint amount = 50;
      require(block.timestamp > DEADLINE,"DEADLINE Passed");
      require(MySquad[msg.sender].length == 15,"Incomplete Squad");
     _mint(msg.sender,id,(amount ),"Baller Rewards");
     emit teamSubmitted(block.timestamp,msg.sender);
    }
    function _RemovePlayer(uint _id)internal{
      require(block.timestamp > DEADLINE,"DEADLINE Passed");
      require(OwnPlayer[msg.sender][_id] == true,"You do not own player");
      require(MyTeam[msg.sender].length != 0,"No Squad");
      (bool _isPlayer,uint256 i) = PositioninTeam(_id);{
        if(_isPlayer){
          MyTeam[msg.sender][i] = MyTeam[msg.sender][MyTeam[msg.sender].length - 1];
          MyTeam[msg.sender].pop();
        }
      }
      InTeam[msg.sender][_id] = false;
      emit playerRemoved(_id);
    }
    function PositioninTeam(uint _id)public view returns(bool,uint256){
       require(OwnPlayer[msg.sender][_id] == true,"You do not own player");
       require(MyTeam[msg.sender].length != 0);
     for(uint i = 0; i<MyTeam[msg.sender].length; i++){
      if(_id == MyTeam[msg.sender][i])return(true,i);
     }return (false,0);
    }
    /*
    function RevealFormation(uint[]memory id)public view returns(uint def,uint mid,uint fwd){
      require(MyTeam[msg.sender].length >=10,"Incomplete Team");
      require(MySquad[msg.sender].length == 15,"Incomplete Squad");
      require(id.length == 11,"Set your Players IDs");
      for(uint i = 0; i<id.length; i++){
        require(OwnPlayer[msg.sender][id[i]] == true,"You do not own player");
        if(players[id[i]].position == Positions.Defender){
          def++;
        }
        if(players[id[i]].position == Positions.Midfielder){
          mid++;
        }
         if(players[id[i]].position == Positions.Foward){
          fwd++;
        }
      }
      return (def,mid,fwd);
    } 
    */
    /*
     function ViewTeam()public view returns(Player[]memory){
      require(MyTeam[msg.sender].length >= 10,"Pick 11 Players");
      uint totalItemCountx = MySquad[msg.sender].length;
        uint itemCountx = 0;
        uint currentIndexx = 0;
        for(uint i = 0; i<totalItemCountx; i++){
          if(InTeam[msg.sender][i + 1] == true){
            itemCountx+=1;
          }
        }
        Player[]memory myteam = new Player[](itemCountx);
        for(uint i = 0; i<totalItemCountx; i++){
          if(InTeam[msg.sender][i + 1] == true){
            uint currentIdx = i + 1;
            Player storage currentitemsx = players[currentIdx];
            myteam[currentIndexx] = currentitemsx;
            currentIndexx += 1;
          }
        }
        return myteam;
    }
    */
    
     function ViewSquad()public view returns(Player[]memory){
       require(MySquad[msg.sender].length == 15,"Add 15 Players to Squad");
       uint totalItemCount = MySquad[msg.sender].length;
        uint itemCount = 0;
        uint currentIndex = 0;
        uint currentId;
        for(uint i = 0; i<totalItemCount; i++){
          if(OwnPlayer[msg.sender][i + 1] == true){
            itemCount +=1;
          }
        }
        Player[]memory mysquad = new Player[](itemCount);
        for(uint i = 0; i<totalItemCount; i++){
          if(OwnPlayer[msg.sender][i + 1] == true){
            currentId +=1;
            Player storage currentitems = players[currentId];
            mysquad[currentIndex] = currentitems;
            currentIndex += 1;
          }
        }
        return mysquad;
 }
 }
 

  
 