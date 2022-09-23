pragma solidity ^0.8.11;
import "./IFan.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract Squad is ERC20{
constructor(address _ifan)
ERC20("SQUAD-TOKEN","SQD"){
    ifan = IFan(_ifan);
}
IFan private ifan;
mapping(address => bool)private swapped;

function Swap()public{
require(swapped[msg.sender] == false,"You have already swapped");
require(ifan.Balance() >= 1000,"Insufficient");
ifan.Exchange(address(this),1000);
_mint(msg.sender,100);
swapped[msg.sender] = true;
}
}