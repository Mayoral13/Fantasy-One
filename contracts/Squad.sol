pragma solidity ^0.8.11;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
contract Squad is ERC20{
constructor(address _ifan)
ERC20("SQUAD-TOKEN","SQD"){
    fan = _ifan;
}
address public fan;
address public SquadTreasury;
mapping(address => bool)private swapped;

function Swap()public{//APPROVE TRANSFERFROM  UI
IERC20 ifan = IERC20(fan);
require(swapped[msg.sender] == false,"You have already swapped");
require(ifan.balanceOf(msg.sender) >= 1000,"Insufficient Balance");
ifan.transferFrom(msg.sender,address(this),1000);
_mint(msg.sender,100);
swapped[msg.sender] = true;
}
}

// "0x4e2063c72Aa4D17f6FEd4870C8ff5F95DdC736de"
//'0xc7c720dca2b4bc7be225246d79ada4acc9a792f0815d09b2e5970590e469ed2b'
