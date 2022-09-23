pragma solidity ^0.8.11;
interface IFan{
    function Balance()external returns(uint);
    function Exchange(address _to,uint _amount)external;
}