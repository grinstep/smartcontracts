
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * Grinstep NFTs
 * @author Grinstep
 */
contract GrinstepNFT is ERC721Enumerable, Ownable(msg.sender) {

    using Strings for uint256;

    using Counters for Counters.Counter;

    // Declaring some state variables
    Counters.Counter private supply;

    string public uriPrefix = ""; // A prefix for the base URI of the token metadata
    string public uriSuffix = ".json"; // A suffix for the base URI of the token metadata

    // Declaring an event for receiving ether
    event Received(address, uint256);

    // Declaring an event for minting tokens
    event Minted(address, uint256, uint256); 

    // base uri for nfts
    string private _buri;

    constructor() ERC721("Grinstep", "GSNFT") {}

    function burn(uint256 tokenId) public virtual {
       require(
            _isAuthorized(ownerOf(tokenId), _msgSender(), tokenId),
            "burn caller is not owner nor approved"
        );
        _burn(tokenId);
    }

    // Defining a fallback function that emits an event when receiving ether
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    // Defining a function that allows anyone to mint tokens by paying the cost
    function mint(uint256 _mintAmount)
        public
        onlyOwner
    {
        _mintLoop(msg.sender, _mintAmount);
    }

    // Defining a helper function that mints tokens in a loop
    function _mintLoop(address _receiver, uint256 _mintAmount) internal {
        for (uint256 i = 0; i < _mintAmount; i++) {
            supply.increment();
            uint256 _tokenId = supply.current();
            _safeMint(_receiver, _tokenId);
            // Emitting the Minted event with the sender address, the token ID, and the amount of tokens minted
            emit Minted(_receiver, _tokenId, _mintAmount);
        }
    }

    // Defining a function that allows the owner to withdraw the contract balance
    function withdraw() public onlyOwner {
        (bool success, ) = payable(owner()).call{value: address(this).balance}(
            ""
        );
        require(success, "Transfer failed.");
    }

    // Defining a function that returns the token URI based on the revealed flag
    function tokenURI(uint256 _tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(ownerOf(_tokenId) != address(0), "Token does not exist");
        string memory currentBaseURI = _baseURI();
        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        _tokenId.toString(),
                        uriSuffix
                    )
                )
                : "";
    }

    // Defining a function that returns the base URI
    function _baseURI() internal view virtual override returns (string memory) {
        return uriPrefix;
    }

    // Defining a function that allows the owner to set the base URI prefix
    function setUriPrefix(string memory _uriPrefix) public onlyOwner {
        uriPrefix = _uriPrefix;
    }

    // Defining a function that allows the owner to set the base URI suffix
    function setUriSuffix(string memory _uriSuffix) public onlyOwner {
        uriSuffix = _uriSuffix;
    }
}
