// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts@4.9.0/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.9.0/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {

    mapping(address => mapping(uint256 => uint256)) public inventory; 
    struct Item {
        string name;
        uint256 price;
    }

    Item[] public items;

    constructor() ERC20("Degen", "DGN") {
        items.push(Item("Apple", 20));
        items.push(Item("Spoon", 10));
        items.push(Item("Fork", 10));
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function buyFromMerchant(uint256 itemIndex) public returns (bool) {
        require(itemIndex < items.length, "Item not found");

        Item storage item = items[itemIndex];
        uint256 price = item.price;
        require(balanceOf(msg.sender) >= price, "Insufficient balance");

        _burn(msg.sender, price);
        // Add item to user's inventory
        inventory[msg.sender][itemIndex]++;

        return true;
    }

    function InventoryItemCount() external view returns (uint256) {
        return items.length;
    }
}
