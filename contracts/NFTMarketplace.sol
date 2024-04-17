// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract NFTMarketplace is ERC1155 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Counters.Counter private _itemsSold;

    uint256 listingPrice = 0.000001 ether;
    address payable owner;

    mapping(uint256 => MarketItem) private idToMarketItem;

    struct MarketItem {
        uint256 id;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
        uint256 amount;
    }

    event MarketItemCreated(
        uint256 indexed id,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold,
        uint256 amount
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can change the listing price");
        _;
    }

    constructor() ERC1155("https://yourapi.com/api/item/{id}.json") {
        owner = payable(msg.sender);
    }

    function createToken(string memory uri, uint256 price, uint256 amount)
        public
        payable
        returns (uint256)
    {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _mint(msg.sender, newTokenId, amount, "");
        _setURI(uri);
        createMarketItem(newTokenId, price, amount);
        return newTokenId;
    }

    function createMarketItem(uint256 tokenId, uint256 price, uint256 amount) private {
        require(price > 0, "Price must be at least 1 wei");
        require(msg.value == listingPrice, "Price must be equal to listing price");
        idToMarketItem[tokenId] = MarketItem(
            _tokenIds.current(),
            tokenId,
            payable(msg.sender),
            payable(address(this)),
            price,
            false,
            amount
        );
        emit MarketItemCreated(
            _tokenIds.current(),
            tokenId,
            msg.sender,
            address(this),
            price,
            false,
            amount
        );
    }

    function resellToken(uint256 id, uint256 price, uint256 amount) public payable {
        require(idToMarketItem[id].owner == msg.sender, "Only item owner can resell");
        require(msg.value == listingPrice, "Incorrect listing price");
        idToMarketItem[id].sold = false;
        idToMarketItem[id].price = price;
        idToMarketItem[id].amount = amount;
        idToMarketItem[id].seller = payable(msg.sender);
        idToMarketItem[id].owner = payable(address(this));
        _itemsSold.decrement();
        _safeTransferFrom(msg.sender, address(this), idToMarketItem[id].tokenId, amount, "");
    }

    function createMarketSale(uint256 id, uint256 amount) public payable {
        uint256 price = idToMarketItem[id].price;
        require(msg.value == price, "Please submit the asking price");
        idToMarketItem[id].owner = payable(msg.sender);
        idToMarketItem[id].sold = true;
        _itemsSold.increment();
        _safeTransferFrom(address(this), msg.sender, idToMarketItem[id].tokenId, amount, "");
        payable(owner).transfer(listingPrice);
        payable(idToMarketItem[id].seller).transfer(msg.value);
        idToMarketItem[id].seller = payable(address(0));
    }
}
