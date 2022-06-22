// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721ReceiverUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/IERC1155ReceiverUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165Checker.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
//import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";

// *****************************************************************************
// *** NOTE: almost all uses of _tokenAddress in this contract are UNSAFE!!! ***
// *****************************************************************************
contract NFTMarket is
    IERC721ReceiverUpgradeable,
    Initializable,
    AccessControlUpgradeable,
    PausableUpgradeable, 
    IERC1155ReceiverUpgradeable
{
    using SafeMath for uint256;
    using EnumerableSet for EnumerableSet.UintSet;
    using EnumerableSet for EnumerableSet.AddressSet;
    //using SafeERC20Upgradeable for IERC20;

    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
    bytes4 private constant _INTERFACE_ID_ERC1155 = 0xd9b67a26;

    bytes32 public constant GAME_ADMIN = keccak256("GAME_ADMIN");

    // ############
    // Initializer
    // ############
    function initialize(address payable _taxRecipient)
        public
        initializer
    {
        __AccessControl_init();
        __Pausable_init_unchained();

        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);

//        erc20token = _token;

        taxRecipient = _taxRecipient;
    }

    struct Listing {
        address payable seller;
        uint256 price;
    }

    struct Listing1155 {
        uint256 tokenId;
        address payable seller;
        uint256 price;
        uint256 amount;
    }

    // ############
    // State
    // ############
//    IERC20 public erc20token;

    address payable taxRecipient; 

    mapping(address => mapping(uint256 => Listing)) private listings;

    mapping(address => mapping(uint256 => Listing1155)) private listings1155;

    mapping(address => bool) public isUserBanned;

    mapping(address => uint256) public tax;

    mapping(address => uint256) private orderIds;


    // ############
    // Events
    // ############
    event NewListing(
        address indexed seller,
        IERC721 indexed nftAddress,
        uint256 indexed nftID,
        uint256 price
    );
    event ListingChange(
        address indexed seller,
        IERC721 indexed nftAddress,
        uint256 indexed nftID,
        uint256 newPrice
    );
    event CancelledListing(
        address indexed seller,
        IERC721 indexed nftAddress,
        uint256 indexed nftID
    );
    event PurchasedListing(
        address indexed buyer,
        address seller,
        IERC721 indexed nftAddress,
        uint256 indexed nftID,
        uint256 price
    );

    //1155
    event NewListing1155(
        IERC1155 indexed tokenAddr,
        uint256 indexed orderId,
        address indexed seller,
        uint256 tokenId,
        uint256 price,
        uint256 amount
    );
    event ListingChange1155(
        IERC1155 indexed tokenAddr,
        uint256 indexed orderId,
        uint256 newPrice,
        uint256 newAmount
    );
    event CancelledListing1155(
        IERC1155 indexed tokenAddr,
        uint256 indexed orderId
    );
    event PurchasedListing1155(
        IERC1155 indexed tokenAddr,
        uint256 indexed orderId,
        address indexed buyer,
        uint256 amount
    );   

    // ############
    // Modifiers
    // ############
    modifier restricted() {
        require(hasRole(GAME_ADMIN, msg.sender), "Not game admin");
        _;
    }

    modifier isListed(IERC721 _tokenAddress, uint256 id) {
        require(listings[address(_tokenAddress)][id].seller != address(0), "Token ID not listed");
        _;
    }

    modifier isListed1155(IERC1155 _tokenAddress, uint256 orderId) {
        require(listings1155[address(_tokenAddress)][orderId].seller != address(0), "Token ID not listed");
        _;
    }

    modifier isNotListed(IERC721 _tokenAddress, uint256 id) {
        require(listings[address(_tokenAddress)][id].seller == address(0), "Token ID was listed");
        _;
    }

    modifier isSeller(IERC721 _tokenAddress, uint256 id) {
        require(
            listings[address(_tokenAddress)][id].seller == msg.sender,
            "Access denied"
        );
        _;
    }

    modifier isSeller1155(IERC1155 _tokenAddress, uint256 orderId) {
        require(
            listings1155[address(_tokenAddress)][orderId].seller == msg.sender,
            "Access denied"
        );
        _;
    }

    modifier isSellerOrAdmin(IERC721 _tokenAddress, uint256 id) {
        require(
            listings[address(_tokenAddress)][id].seller == msg.sender ||
                hasRole(GAME_ADMIN, msg.sender),
            "Access denied"
        );
        _;
    }

    modifier isSellerOrAdmin1155(IERC1155 _tokenAddress, uint256 orderId) {
        require(
            listings1155[address(_tokenAddress)][orderId].seller == msg.sender ||
                hasRole(GAME_ADMIN, msg.sender),
            "Access denied"
        );
        _;
    }

    modifier userNotBanned() {
        require(isUserBanned[msg.sender] == false, "Forbidden access");
        _;
    }

    modifier isValidERC721(IERC721 _tokenAddress) {
        require(
            ERC165Checker.supportsInterface(
                address(_tokenAddress),
                _INTERFACE_ID_ERC721
            )
        );
        _;
    }

    modifier isValidERC1155(IERC1155 _tokenAddress) {
        require(
            ERC165Checker.supportsInterface(
                address(_tokenAddress),
                _INTERFACE_ID_ERC1155
            )
        );
        _;
    }

    // ############
    // Pause
    // ############
    function pause() public restricted {
        _pause();
    }

    function unpause() public restricted {
        _unpause();
    }

    // ############
    // Mutative
    // ############
    function addListing(
        IERC721 _tokenAddress,
        uint256 _id,
        uint256 _price
    )
        public
        userNotBanned
        isValidERC721(_tokenAddress)
        isNotListed(_tokenAddress, _id)
        whenNotPaused()
    {
        _tokenAddress.safeTransferFrom(msg.sender, address(this), _id);

        listings[address(_tokenAddress)][_id] = Listing(payable(msg.sender), _price);

        emit NewListing(msg.sender, _tokenAddress, _id, _price);
    }

    function changeListing(
        IERC721 _tokenAddress,
        uint256 _id,
        uint256 _newPrice
    )
        public
        userNotBanned
        isListed(_tokenAddress, _id)
        isSeller(_tokenAddress, _id)
        whenNotPaused()
    {
        listings[address(_tokenAddress)][_id].price = _newPrice;
        emit ListingChange(
            msg.sender,
            _tokenAddress,
            _id,
            _newPrice
        );
    }

    function cancelListing(IERC721 _tokenAddress, uint256 _id)
        public
        userNotBanned
        isListed(_tokenAddress, _id)
        isSellerOrAdmin(_tokenAddress, _id)
        whenNotPaused()
    {
        delete listings[address(_tokenAddress)][_id];

        _tokenAddress.safeTransferFrom(address(this), msg.sender, _id);

        emit CancelledListing(msg.sender, _tokenAddress, _id);
    }

    function purchaseListing(
        IERC721 _tokenAddress,
        uint256 _id
    ) public payable userNotBanned isListed(_tokenAddress, _id) whenNotPaused() {
        require(listings[address(_tokenAddress)][_id].seller != msg.sender, "buyer can't be seller");
        
        uint256 price = listings[address(_tokenAddress)][_id].price;
        require(msg.value == price, "value is error");
        
        uint256 sellerFee = price.mul(tax[address(_tokenAddress)]).div(10000);

        Listing memory listing = listings[address(_tokenAddress)][_id];
        require(isUserBanned[listing.seller] == false, "Banned seller");

        payTax(sellerFee);

        listings[address(_tokenAddress)][_id].seller.transfer(price.sub(sellerFee));

        _tokenAddress.safeTransferFrom(address(this), msg.sender, _id);

        delete listings[address(_tokenAddress)][_id];

        emit PurchasedListing(
            msg.sender,
            listing.seller,
            _tokenAddress,
            _id,
            msg.value
        );
    }

    function payTax(uint256 amount) internal {
        //erc20token.transferFrom(msg.sender, taxRecipient, amount);
        taxRecipient.transfer(amount);
    }

    function setUserBan(address user, bool to) external restricted {
        isUserBanned[user] = to;
    }

    function setUserBans(address[] calldata users, bool to) external restricted {
        for(uint i = 0; i < users.length; i++) {
            isUserBanned[users[i]] = to;
        }
    }

    function checkUserBanned(address user) public view returns (bool) {
        return isUserBanned[user];
    }

    function setTokenTax(address token, uint256 fee) external restricted {
        tax[token] = fee;
    }

    function onERC721Received(
        address, /* operator */
        address, /* from */
        uint256, /* id  */
        bytes calldata /* data */
    ) external override pure returns (bytes4) {
        return IERC721ReceiverUpgradeable.onERC721Received.selector;
    }

//1155
    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address,
        address,
        uint256[] memory,
        uint256[] memory,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC1155BatchReceived.selector;
    }
    

    function addListing1155(
        IERC1155 _tokenAddress,
        uint256 _tokenId,
        uint256 _price,
        uint256 _amount
    )
        public
        userNotBanned
        isValidERC1155(_tokenAddress)
        whenNotPaused()
    {
        _tokenAddress.safeTransferFrom(msg.sender, address(this), _tokenId, _amount, "");

        uint256 orderId = orderIds[address(_tokenAddress)]++;
        listings1155[address(_tokenAddress)][orderId] = Listing1155(_tokenId, payable(msg.sender), _price, _amount);

        emit NewListing1155(_tokenAddress, orderId, msg.sender, _tokenId, _price, _amount);
    }

    function changeListing1155(
        IERC1155 _tokenAddress,
        uint256 _orderId,
        uint256 _newPrice,
        uint256 _newAmount
    )
        public
        userNotBanned
        isListed1155(_tokenAddress, _orderId)
        isSeller1155(_tokenAddress, _orderId)
        whenNotPaused()
    {
        require(_newAmount>0, "amount error");

        Listing1155 storage order = listings1155[address(_tokenAddress)][_orderId];
        order.price = _newPrice;

        if( _newAmount != order.amount ) {
            if(_newAmount > order.amount) {
                _tokenAddress.safeTransferFrom(msg.sender, address(this), order.tokenId, _newAmount-order.amount, "");
            }else if(_newAmount < order.amount) {
                _tokenAddress.safeTransferFrom(address(this), msg.sender, order.tokenId, order.amount-_newAmount, "");
            }
            order.amount = _newAmount;
        }

        emit ListingChange1155(
            _tokenAddress,
            _orderId,
            _newPrice, 
            _newAmount
        );
    }

    function cancelListing1155(IERC1155 _tokenAddress, uint256 _orderId)
        public
        userNotBanned
        isListed1155(_tokenAddress, _orderId)
        isSellerOrAdmin1155(_tokenAddress, _orderId)
        whenNotPaused()
    {
        Listing1155 storage order = listings1155[address(_tokenAddress)][_orderId];

        _tokenAddress.safeTransferFrom(address(this), msg.sender, order.tokenId, order.amount, "");

        delete listings1155[address(_tokenAddress)][_orderId];

        emit CancelledListing1155(_tokenAddress, _orderId);
    }

    function purchaseListing1155(
        IERC1155 _tokenAddress,
        uint256 _orderId,
        uint256 _amount
    ) public payable userNotBanned isListed1155(_tokenAddress, _orderId) whenNotPaused() {
        Listing1155 storage order = listings1155[address(_tokenAddress)][_orderId];
        require(_amount<=order.amount, "amount error");
        require(isUserBanned[order.seller] == false, "Banned seller");
        require(order.seller != msg.sender, "buyer error");

        uint256 price = order.price.mul(_amount);
        require(msg.value == price, "value error");
        
        uint256 sellerFee = price.mul(tax[address(_tokenAddress)]).div(10000);

        payTax(sellerFee);

        order.seller.transfer(price.sub(sellerFee));
 
        _tokenAddress.safeTransferFrom(address(this), msg.sender, order.tokenId, _amount, "");
        uint256 left = order.amount - _amount;
        if( left == 0 ) {
            delete listings1155[address(_tokenAddress)][_orderId];
        }else{
            order.amount = left;
        }
        
        emit PurchasedListing1155(
            _tokenAddress,
            _orderId,
            msg.sender,
            _amount
        );
    }
}
