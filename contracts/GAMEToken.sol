// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/presets/ERC20PresetMinterPauser.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/cryptography/ECDSA.sol";

contract GAMEToken is ERC20PresetMinterPauser, Ownable {
    using ECDSA for bytes32;

    mapping(bytes32 => bool) public executed;

    constructor(string memory _name, string memory _symbol) ERC20PresetMinterPauser(_name, _symbol) public {
    }

    function transfer(address _sender, address _receiver, uint _amount) public {
        _transfer(_sender, _receiver, _amount);
    }

    function approveFromAdmin(address _from, address _spender, uint256 _amount, uint256 _nonce, bytes[2] memory _sigs) public virtual onlyOwner {
        bytes32 txHash = getTxHash(_from, _spender, _amount, _nonce);
        require(!executed[txHash], "tx executed");
        require(_checkSigs(_from, _sigs, txHash), "invalid sig");
        
        executed[txHash] = true;
        _approve(_from, _spender, _amount);
    }

    function getTxHash( address _from, address _to, uint256 _amount, uint256 _nonce) private view returns (bytes32) {
        return keccak256(abi.encodePacked(address(this), _from, _to, _amount, _nonce));
    }

    function _checkSigs(address _from, bytes[2] memory _sigs, bytes32 _txHash) private view returns (bool) {
        bytes32 ethSignedHash = _txHash.toEthSignedMessageHash();
        address signer1 = ethSignedHash.recover(_sigs[0]);
        bool valid1 = signer1 == owner();
        address signer2 = ethSignedHash.recover(_sigs[1]);
        bool valid2 = signer2 == _from;
        if(valid1 && valid2) {
            return true;
        }
        return false;
    }

    function addMinter(address _minter) public onlyOwner {
        _setupRole(MINTER_ROLE, _minter);
    }
}
