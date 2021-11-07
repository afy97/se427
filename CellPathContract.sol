pragma solidity ^0.5.17;

contract CellPathContract { 
    function getCellTeamNumber(int x, int y) public view returns (int); 
    function getCellHash(int x, int y) public view returns (bytes32); 
    function getCellNonce(int x, int y) public view returns (bytes32); 
    function getCellShiftCount(int x, int y) public view returns (int); 
    function getSprintNumber() public view returns (int); 
    function getXdimension() public view returns (int); 
    function getYdimension() public view returns (int); 
    function getTeamNumberFromAccount(address teamAccount) public view returns (int); 
    function setMyTeamContract(address contractAddress) public; 
    function getMyTeamContract() public view returns (address); 
    function getMyTeamCount() public view returns (int); 
    function getMyTeamCallCount() public view returns (int); 
    function showCellTeamNumbers() public view returns (string memory); 
    function getMyTeamNumber() public view returns (int); 
    function showLeaderBoard() public view returns (string memory); 
    function showLeaderBoard_Calls() public view returns (string memory); 
    function setCellsFromContract(int xs, int ys, int xe, int ye, bytes32 nonce) public payable; 
    function getTxOrigin() public view returns (address); 
}
