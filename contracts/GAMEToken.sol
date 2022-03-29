// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/presets/ERC20PresetMinterPauser.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GAMEToken is ERC20PresetMinterPauser, Ownable {
    constructor()
        public
    ERC20PresetMinterPauser("Donbangseok Game Token", "DGT")
    {

    }

    function transfer(address _sender, address _receiver, uint _amount) public {
        _transfer(_sender, _receiver, _amount);
    }

    function addMinter(address _minter) public onlyOwner {
        _setupRole(MINTER_ROLE, _minter);
    }
}
