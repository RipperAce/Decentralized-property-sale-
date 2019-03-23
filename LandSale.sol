pragma solidity 0.4.25;
pragma experimental ABIEncoderV2;

contract LandSale{
	//address of contract creator
	address creator;
	//mapping to check the balance of particular consumer
	mapping(address => uint) public balance;

	//requirements passcode must be a number and not a string
	struct Owner{
		string name;
		uint256 govt_id;
		uint256 passcode;
	}

	//creating structure to maintain property details
	struct Property{
		bool p_type;
		string city;
		string state;
		uint256 plot_no;
		uint256 zip_code;
		uint256 length;
		uint256 breadth;
		uint256 no_floors;
		uint256 price;
		bool availability_status;
	}
	//mapping of property id to property details
	mapping(uint256 => Property) public property_stack;
	//mapping to store property details of user
	mapping (address =>mapping(uint256 => Property)) public property_details;
	//keeping track of addresses of users related to property
	uint256[] public property_id;

	//mapping to keep track of owner and address
	mapping(address => Owner) public owner_details;

	//creating array of structure property to keep track of available properties
	Property[] public p_array;

	//constructor to set owner of contract
	constructor() public{
		creator = msg.sender;
	}
	//event to trigger after user is created
	event OwnerCreated(address owner);
	event PlotRegistered(address owner);
	
	//to keep track of users
	address[] public users;

	//function to create owner by filling his details
	function createOwner(string memory nm, uint256 id, uint256 pw) public returns(bool){
		address owner = msg.sender;
		balance[owner] = 1000;
		users.push(owner) -1;
		owner_details[owner].name = nm;
		owner_details[owner].govt_id = id;
		owner_details[owner].passcode = pw;
		//event calls when user gets created
		emit OwnerCreated(owner);
		//return true on successfull user creation
		return true;
	}

	//function to add plot details by owner
	function addPlot(uint256 id, bool typ, string ct, string st, uint256 pltno, uint256 zp, uint256 ln, uint256 br, uint256 floors, uint256 pr, bool status) public returns(bool){
		address owner = msg.sender;
		property_id.push(id) -1;
		//basic details of property
		property_details[owner][id].p_type = typ;
		property_stack[id].p_type = typ;
		//detail address of property
		property_details[owner][id].city = ct;
		property_stack[id].city = ct;
		property_details[owner][id].state = st;
		property_stack[id].state = st;
		property_details[owner][id].plot_no = pltno;
		property_stack[id].plot_no = pltno;
		property_details[owner][id].zip_code = zp;
		property_stack[id].zip_code = zp;
		//detail dimensions of property
		property_details[owner][id].length = ln;
		property_stack[id].length = ln;
		property_details[owner][id].breadth = br;
		property_stack[id].breadth = br;
		if(typ){
			property_details[owner][id].no_floors = floors;
			property_stack[id].no_floors = floors;
		}
		else{
			property_details[owner][id].no_floors = 0;
			property_stack[id].no_floors = 0;
		}
		//price of property and its availability status
		property_details[owner][id].price = pr;
		property_stack[id].price = pr;
		property_details[owner][id].availability_status = status;
		property_stack[id].availability_status = status;
		//event trigger on successfull entry of property
		emit PlotRegistered(owner);
		//return true for successfull execution of property registry
		return true;
	}

	//function to modify property details
	function modifyProperty(uint256 pr, uint256 id, bool status) public returns(bool){
			address owner = msg.sender;
			//modifying details
			property_details[owner][id].price = pr;
			property_stack[id].price = pr;
			property_details[owner][id].availability_status = status;
			property_stack[id].availability_status = status;
			//event call on modifying details of property
			emit PlotRegistered(owner);
			//returns success status if successfull
			return true;
		}
	
	//function to get available properties
	function getProperties() public returns(Property[]){
		uint256 len = property_id.length;
		for(uint256 i = 0; i < len; i++){
			if(property_stack[property_id[i]].availability_status == true){
				p_array.push(property_stack[property_id[i]]);
			}
		}
		//returning available property details to user
		return p_array;
	}

	function propertyTransfer(uint256 p_id, uint256 s_id, string memory s_nm, uint256 b_id, string memory b_nm, uint256 pw) public returns(bool){
		uint256 pr;
		address seller_addr;
		uint256 len = p_array.length;
		//fetching the price of property
		pr = property_stack[p_id].price;
		//fetching the address of seller
		len = users.length;
		for(uint256 i = 0;i < len; i++){
			if(owner_details[users[i]].govt_id == s_id){
				seller_addr = users[i];
				break;
			}
			else{
				return false;
			}
		}
		//checking balance of buyer which must be greater than or equal to selling price of property
		require (balance[msg.sender] >= pr);
		//checking buyer id
		require (owner_details[msg.sender].govt_id == b_id);
		//checking buyer passcode
		require (owner_details[msg.sender].passcode == pw);

		//calling money transfer
		balance[msg.sender] -= pr;
		balance[seller_addr] += pr;

		//making the transaction
		property_details[msg.sender][p_id].p_type = property_stack[p_id].p_type;
		property_details[msg.sender][p_id].city = property_stack[p_id].city;
		property_details[msg.sender][p_id].state = property_stack[p_id].state;
		property_details[msg.sender][p_id].plot_no = property_stack[p_id].plot_no;
		property_details[msg.sender][p_id].zip_code = property_stack[p_id].zip_code;
		property_details[msg.sender][p_id].length = property_stack[p_id].length;
		property_details[msg.sender][p_id].breadth = property_stack[p_id].breadth;
		property_details[msg.sender][p_id].no_floors = property_stack[p_id].no_floors;
		property_details[msg.sender][p_id].price = property_stack[p_id].price;
		//deleting from user
		delete(property_details[seller_addr][p_id]);
		//setting availability status to false
		property_details[msg.sender][p_id].availability_status = false;
		property_stack[p_id].availability_status = false;
		//returning status of execution
		return true;
	}			
}