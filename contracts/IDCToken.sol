// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/presets/ERC20PresetMinterPauser.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract IDCToken is ERC20PresetMinterPauser, Ownable {
    // constructor(string memory _name, string memory _symbol)
    constructor()
        public
    ERC20PresetMinterPauser("iCraft Donbangseok Coin", "IDC")
    {
    }

    function transfer(address _sender, address _receiver, uint _amount) public {
        _transfer(_sender, _receiver, _amount);
    }

    function addMinter(address _minter) public onlyOwner {
        _setupRole(MINTER_ROLE, _minter);
    }
}