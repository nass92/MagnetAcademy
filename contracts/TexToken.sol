// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract TexToken is ERC721URIStorage, ERC721Enumerable{
    using Counters for Counters.Counter;

    struct Text {
        address author;
        bytes32 textHashed;
        string txt;
        string url;
         string title;
    }

    //bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    Counters.Counter private _textId;
    
    
    mapping(uint256 => Text) private _text;
    mapping (uint256=> address) private _flw;
mapping(uint256 => uint256) private _price;
    constructor() ERC721("TEXT", "TXT") {}



    // mint function
    function certify(Text memory nft, address owner) public  returns (uint256) {
        
        uint256 newText= _textId.current();
        _mint(msg.sender, newText);
        _textId.increment();
        _setTokenURI(newText, nft.txt);
        _text[newText] = nft;
        _flw[newText] = owner;
        return newText;
        
    }
    
      

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721Enumerable, ERC721)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
    
      function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }
    
     function _burn(uint256 tokenId) internal virtual override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }
     function getTXTById(uint256 tokenId) public view returns (Text memory) {
        return _text[tokenId];
    }
    
    
    function _baseURI() internal view virtual override(ERC721) returns (string memory) {
        return "https://www.magnetgame.com/nft/";
    }
        function getPrice(uint256 id) public view returns (uint256) {
        return (_price[id]);
    }
       function listNFT(address marketPlace, uint256 id, uint256 price_) public {
        approve(marketPlace, id);
        _price[id] = price_;
    }
}
