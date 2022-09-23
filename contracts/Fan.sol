pragma solidity ^0.8.11;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract Fan is ERC20{
constructor()
ERC20("FAN-TOKEN","FAN"){
    _mint(msg.sender,100000);
}
function Balance()external view returns(uint){
    return balanceOf(msg.sender);
}
function Exchange(address _to,uint _amount)external{
    transfer(_to,_amount);
}
}