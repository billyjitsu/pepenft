//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "erc721a/contracts/ERC721A.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract PepeNFT is ERC721A, Ownable, ERC2981 {
    using Strings for uint256;

    IERC20 public Pepe;

    uint256 public constant MAX_SUPPLY = 10035;
    uint256 public constant PUBLIC_SALE_PRICE = 0.004 ether;

    string public baseTokenUri;
    string public holderTokenUri;
    string public whaleTokenUri;

    bool public publicSale;
    bool public paused;

    mapping(address => uint256) public totalPublicMint;

    constructor(
        uint96 _royaltyFeesInBips,
        address _royalty,
        string memory _URI,
        string memory _holderURI,
        string memory _whaleURI,
        IERC20 _pepe
    ) ERC721A("PEPE NFT", "PEPE") {
        _setDefaultRoyalty(_royalty, _royaltyFeesInBips);
        baseTokenUri = _URI;
        holderTokenUri = _holderURI;
        whaleTokenUri = _whaleURI;
        Pepe = _pepe;
    }

    function mint(uint256 _quantity) external payable {
        require(!paused, "Contract Paused");
        // require(publicSale, "Fiona - Not Yet Active.");
        // require((totalSupply() + _quantity) <= MAX_SUPPLY, "Fiona - Beyond Max Supply");
        // require(msg.value >= (PUBLIC_SALE_PRICE * _quantity), "Fiona - Below");

        totalPublicMint[msg.sender] += _quantity;
        _safeMint(msg.sender, _quantity);
    }

    function tokenBalance() public view returns (uint256) {
        return Pepe.balanceOf(msg.sender);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenUri;
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        address tokenOwner = ownerOf(tokenId);
        uint256 temp = Pepe.balanceOf(tokenOwner);

        if (temp > 0 && temp <= 10e18) {
            return
                bytes(baseTokenUri).length > 0
                    ? string(abi.encodePacked(holderTokenUri))
                    : "";
        } else if (temp > 10e18){
            return
                bytes(baseTokenUri).length > 0
                    ? string(abi.encodePacked(whaleTokenUri))
                    : "";
        }
         else {
            return
                bytes(baseTokenUri).length > 0
                    ? string(abi.encodePacked(baseTokenUri))
                    : "";
        }
    }

    function _startTokenId() internal pure virtual override returns (uint256) {
        return 1;
    }

    //Interface overide for possible royalties
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC721A, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function setTokenUri(string memory _baseTokenUri) external onlyOwner {
        baseTokenUri = _baseTokenUri;
    }

    function togglePublicSale() external onlyOwner {
        publicSale = !publicSale;
    }

    function togglePause() external onlyOwner {
        paused = !paused;
    }

    function withdraw() external onlyOwner {
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success);
    }
}
