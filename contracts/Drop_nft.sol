// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";


import "hardhat/console.sol";


contract Drop_nft is ERC721, ERC721URIStorage,ERC721Pausable, AccessControl, ERC721Burnable {
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    
    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    mapping(uint256 => string) private _hashIPFS;
    mapping(uint256 => address) private _ownBurnableToken;


    uint256 public cost = 0.01 ether;
    bool public revealed = false;
    string public hiddenMetadataUri = "https://salmon-opposite-porcupine-429.mypinata.cloud/ipfs/QmS1NgXrU9NpNPFjMcZEDQAWBVckijXPjsPKGCRY7vrGCq";

    address[] white_list = 
    [
        0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266,
        0x728BfdEfb4b69f69C38DD09f54915eDa66907C01
    ];

    bool start = false;


    constructor()
        ERC721("Drop_nft", "DROP")
    {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    

    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://salmon-opposite-porcupine-429.mypinata.cloud/ipfs/";
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

  
    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl,ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }


    function safeMint(string[] memory _hashes) public  payable onlyRole(MINTER_ROLE) validateWhiteList(msg.sender){


        require(msg.value >= cost * _hashes.length, "Insufficient funds!");

        for (uint256 i = 0; i < _hashes.length; i++){
            
            uint256 tokenId = _tokenIdCounter.current();


            _safeMint(msg.sender, tokenId);
            _hashIPFS[tokenId] = _hashes[i];
            _ownBurnableToken[tokenId] = msg.sender; 
            _tokenIdCounter.increment();
        }

    }

    function tokenURI(uint256 tokenId)
    public
    view
    override(ERC721, ERC721URIStorage)
    returns (string memory)
    {

        string memory currentBaseURI = _baseURI();


        
        if (revealed == false) {

            return hiddenMetadataUri;

        }


        return
            (bytes(currentBaseURI).length > 0 &&
                bytes(_hashIPFS[tokenId]).length > 0)
            ? string(abi.encodePacked(currentBaseURI, _hashIPFS[tokenId]))
            : "";

    }

    function setRevealed(bool _state) public onlyRole(DEFAULT_ADMIN_ROLE) {

        revealed = _state;

    }

    function iniciate(bool _start) public onlyRole(DEFAULT_ADMIN_ROLE) {

        start = _start;

    }

    modifier validateWhiteList(address user) {

        bool in_white_list = false;

        for (uint256 i = 0; i < white_list.length; i++){

            if(white_list[i] == user)
            {
                in_white_list = true;
            }
        }

        if(start == false){

            require(in_white_list == true, "uninitiated sale");
                _;
        }

    }


}