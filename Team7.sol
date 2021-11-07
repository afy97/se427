pragma solidity ^0.5.17;

import "./CellPathContract.sol";
import "./Ownable.sol";

contract Team7 is Ownable {
    address payable CC_ADDRESS=0xFa2A3C7eA3C1fd11B8A8f915D539F162b34F3508;
    CellPathContract cc = CellPathContract(CC_ADDRESS);
    
    function occupyingNonce(int _x, int _y) public view returns(bytes32) {
        bytes32 central = cc.getCellHash(_x, _y);
        bytes32 nonce   = 0x0;
        bytes32 next    = 0x0;
        
        while (next < central) {
            nonce = bytes32(keccak256(abi.encodePacked(block.difficulty, block.timestamp)));
            next  = sha256(abi.encodePacked(central, nonce));
        }
        
        return nonce;
    }
    
    function occupy(int _x, int _y) external payable {
        cc.setMyTeamContract(address(this));
        cc.setCellsFromContract(
            _x, _y,
            _x, _y,
            occupyingNonce(_x, _y)
        );
    }
    
    function occupyWithNonce(int _x, int _y, bytes32 nonce) external payable {
        cc.setMyTeamContract(address(this));
        cc.setCellsFromContract(
            _x, _y,
            _x, _y,
            nonce
        );
    }
    
    function setCellPathContractAdress(address payable _address) external isOwner {
        CC_ADDRESS = _address;
        cc = CellPathContract(CC_ADDRESS);
    }
}
