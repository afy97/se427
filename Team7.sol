pragma solidity ^0.5.17;

import "./CellPathContract.sol";
import "./Ownable.sol";

contract Team7 is Ownable {
    CellPathContract cc = CellPathContract(0xFa2A3C7eA3C1fd11B8A8f915D539F162b34F3508);
    
    constructor() Ownable() public {
        cc.setMyTeamContract(address(this));
    }
    
    modifier indexLimited(int _sx, int _sy, int _ex, int _ey) {
        require((0 <= _sx) && (0 <= _sy) && (0 <= _ex) && (0 <= _ey));
        require((_sx < 20) && (_sy < 20) && (_ex < 20) && (_ey < 20));
        require((_ex >= _sx) && (_ey >= _sy));
        _;
    }

    function _getAllFromArea(int _sx, int _sy, int _ex, int _ey) public indexLimited(_sx, _sy, _ex, _ey) view returns(bytes32[] memory) {
        int x = (_ex - _sx) + 1;
        int y = (_ey - _sy) + 1;
        
        bytes32[] memory values = new bytes32[](uint(x * y));
        
        for (int i = 0; i < x; i++) {
            for (int j = 0; j < y; j++) {
                values[uint((i * x) + j)] = cc.getCellHash(i + _sx, j + _sy);
            }
        }
        
        return values;
    }
    
    function _findCommonNonce(int _sx, int _sy, int _ex, int _ey) public indexLimited(_sx, _sy, _ex, _ey) view returns(bytes32) {
        bytes32[] memory cells = _getAllFromArea(_sx, _sy, _ex, _ey);
        
        bytes32 nonce = 0x0;
        bytes32 next  = 0x0;
        
        bool flag = true;
        
        while (flag) {
            flag = false;
            nonce = bytes32(keccak256(abi.encodePacked(block.difficulty, block.timestamp)));
            
            for (uint8 i = 0; i < cells.length; i++) {
                next = sha256(abi.encodePacked(cells[i], nonce));
                
                if (next <= cells[i]) {
                    flag = true;
                    break;
                }
            }
        }
        
        return nonce;
    }
    
    function _occupyingNonce(int _x, int _y) public indexLimited(_x, _y, _x, _y) view returns(bytes32) {
        bytes32 central = cc.getCellHash(_x, _y);
        bytes32 nonce   = 0x0;
        bytes32 next    = 0x0;
        
        for (uint i = 0; i < 2**256 - 2; i++) {
            nonce = bytes32(keccak256(abi.encodePacked(block.difficulty, block.timestamp)));
            next  = sha256(abi.encodePacked(central, nonce));
            
            if (central < next) {
                break;
            }
        }
        
        return nonce;
    }
    
    function occupyArea(int _sx, int _sy, int _ex, int _ey) external indexLimited(_sx, _sy, _ex, _ey) payable {
        cc.setMyTeamContract(address(this));
        cc.setCellsFromContract.value(1 ether)(
            _sx, _sy,
            _ex, _ey,
            _findCommonNonce(_sx, _sy, _ex, _ey)
        );
    }
    
    function occupyAreaWithNonce(int _sx, int _sy, int _ex, int _ey, bytes32 nonce) external indexLimited(_sx, _sy, _ex, _ey) payable {
        cc.setMyTeamContract(address(this));
        cc.setCellsFromContract.value(1 ether)(
            _sx, _sy,
            _ex, _ey,
            nonce
        );
    }
    
    function occupySingle(int _x, int _y) external indexLimited(_x, _y, _x, _y) payable {
        cc.setMyTeamContract(address(this));
        cc.setCellsFromContract.value(1 ether)(
            _x, _y,
            _x, _y,
            _occupyingNonce(_x, _y)
        );
    }
    
    function occupySingleWithNonce(int _x, int _y, bytes32 nonce) external indexLimited(_x, _y, _x, _y) payable {
        cc.setMyTeamContract(address(this));
        cc.setCellsFromContract.value(1 ether)(
            _x, _y,
            _x, _y,
            nonce
        );
    }

    function setCellPathContractAdress(address payable _address) external isOwner {
        cc = CellPathContract(_address);
    }

    function _encodeTestJoin(bytes32 _a, bytes32 _b) external pure returns(bytes32) {
        return sha256(abi.encodePacked(_a, _b));
    }

    function _encodeTestSingle(bytes32 _a) external pure returns(bytes32) {
        return sha256(abi.encodePacked(_a));
    }
}
