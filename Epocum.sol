pragma solidity ^0.4.18;

contract decentralizedNetwork {

    event UserAcceptance(address user, string ipfsRedirectLink, address smartAd); 
    event addConnection(string ip, string website,address smartContract);
     
    function addVirtualConnection(string ip, string website,address smartContract) public {
         addConnection(ip, website, smartContract); 
     }
 
}

contract epocum is decentralizedNetwork {
  
    uint public usrs = 0;
    uint public webs = 0;
    uint public smartCount = 0;
    uint public $web;
    address public _epocum;
    
    function epocum() public{
       $web = 0;
       _epocum = msg.sender;
      
    }
    
     struct Websites {
		string url;
		bool cert;
	} 
	
    struct Users {
		string ipfs;
		address wallet;
		uint id;
		uint numWebsites;
		uint numSmartSharingContracts;
	}

    struct SmartSharingContract {
		address proprietary;
		bytes32 smartHash;
		string website;
		uint target;
		uint acceptances;
	}
	
	struct Acceptance {
	    uint id;
		bytes32 smartHash;
		string website;
		address advertiser;
		string dLink;
		uint connections;
	}
	
    mapping (uint => Users) UsersById;
    mapping (address => Users) UsersByAddr;
    
    mapping (address => mapping (uint => Websites)) WebChain;
    
    mapping (uint => SmartSharingContract) SmartChainId;
    mapping (bytes32 => SmartSharingContract) SmartChainHash;

    mapping (address => mapping (bytes32 => Acceptance)) acceptByAddress;
    mapping (string => Acceptance) acceptByIpfs;
    
    function () payable public {
        uint amount = msg.value;
    }

    function resetEpocum(address _newEpocum)  public constant returns (bool) {
        if (msg.sender != _epocum) revert();
		 _epocum = _newEpocum;
	}
	
    function isEpocum() public constant returns (bool) {
		return msg.sender == _epocum;
	}
	
	function isAlreadyIn() public constant returns (bool) {
		return msg.sender == UsersByAddr[msg.sender].wallet;
	}

    function addUser(string ipfs) public {
	    usrs++;
	    UsersByAddr[msg.sender] = Users(ipfs,msg.sender,0,usrs,0);
	} 
	
	function updateUser(string ipfs) public {
	    UsersByAddr[msg.sender].ipfs = ipfs;
	} 
	
	function addWeb(string myWebsite) public {
	    uint idx = UsersByAddr[msg.sender].numWebsites;
	    uint x = idx + 1;
	    WebChain[msg.sender][x].url = myWebsite;
	    WebChain[msg.sender][x].cert = false;
	    UsersByAddr[msg.sender].numWebsites = x;
	    webs++;
	}
	
	function NewSmartSharingContract(string _website, uint _target) public {
	    uint s = UsersByAddr[msg.sender].numSmartSharingContracts;
        bytes32 _hash = keccak256(msg.sender,_website,smartCount);
        SmartChainId[smartCount].proprietary = msg.sender;
        SmartChainId[smartCount].smartHash =  _hash;
        SmartChainHash[_hash].proprietary = msg.sender;
        SmartChainHash[_hash].website = _website;
        SmartChainHash[_hash].smartHash =  _hash;
        SmartChainHash[_hash].target = _target;
        SmartChainHash[_hash].acceptances = 0;
        uint x = s + 1;
        UsersByAddr[msg.sender].numSmartSharingContracts = x;
        smartCount++; 
    } 
    
	function Accept (bytes32 _smartHash, string _dLink) public {
	    uint numAcc = SmartChainHash[_smartHash].acceptances;
	    string _website = SmartChainHash[_smartHash].website;
	    uint x = acceptByAddress[msg.sender][_smartHash].id;
	    acceptByAddress[msg.sender][_smartHash].advertiser = msg.sender;
	    acceptByAddress[msg.sender][_smartHash].dLink = _dLink;
        acceptByAddress[msg.sender][_smartHash].connections = 0;
        acceptByAddress[msg.sender][_smartHash].website = _website;
        acceptByIpfs[_dLink].smartHash = _smartHash;
        uint y = x + 1;
        uint z = numAcc + 1;
        acceptByAddress[msg.sender][_smartHash].id = y;
        SmartChainHash[_smartHash].acceptances = z;
    } 
    
	function destroyUser() public{
        uint id = UsersByAddr[msg.sender].id;
        delete(UsersByAddr[msg.sender]);
        delete(UsersById[id]);
	}
	
	function set$Web(uint _$web) public {
	    if (!isEpocum()) revert();
	    $web = _$web;
	}
	
	function Certify(address inWebAddr, uint x) public {
	    if (!isEpocum()) revert();
        WebChain[inWebAddr][x].cert = true;
    }
	
	function getUserFromAddr(address user) public constant returns(string ipfsRoot) {
	    ipfsRoot = UsersByAddr[user].ipfs;
	}
	
	function getUserFromId(uint id) public constant returns(string ipfsRoot) {
	    ipfsRoot = UsersById[id].ipfs;
	}
	
	function countWebsite(address customer) public constant returns(uint count) {
        count = UsersByAddr[customer].numWebsites;
    }
    
    function countAllSmartSharingContract() public constant returns(uint count) {
        count = smartCount;
    }
    
    function countAllWebsite() public constant returns(uint count) {
        count = webs;
    }
    
    function countAllUsers() public constant returns(uint count) {
        count = usrs;
    }
    
    function countSmartSharingContract() public constant returns(uint count) {
        count = UsersByAddr[msg.sender].numSmartSharingContracts;
    }

    function getSmartSharingByID(uint id) public constant returns(address smartOwner, bytes32 smartHash) {
        smartOwner = SmartChainId[id].proprietary;
        smartHash = SmartChainId[id].smartHash;
    }
    
    function getSmartSharingByHash(bytes32 hash) public constant returns(address smartOwner, string smartWebsite, bytes32 smartHash, uint target, string ipfs, uint numAcc) {
        smartOwner = SmartChainHash[hash].proprietary;
        smartWebsite = SmartChainHash[hash].website;
        smartHash = SmartChainHash[hash].smartHash;
        target = SmartChainHash[hash].target;
        ipfs = UsersByAddr[smartOwner].ipfs;
        numAcc = SmartChainHash[hash].acceptances;
    }
    
    function getWebsite(address customer, uint index) public constant returns(string website, bool cert) {
        website = WebChain[customer][index].url;
        cert = WebChain[customer][index].cert;
    }
    
    function getAcceptance(bytes32 _smartHash) public constant returns(string dLink,string web,uint nConn) {
	    dLink = acceptByAddress[msg.sender][_smartHash].dLink;
	    web = acceptByAddress[msg.sender][_smartHash].website;
        nConn = acceptByAddress[msg.sender][_smartHash].connections;
    }
    
    function getSmartHash(string _dLink) public constant returns(bytes32 smartHash) {
	    smartHash = acceptByIpfs[_dLink].smartHash;
    }

}
