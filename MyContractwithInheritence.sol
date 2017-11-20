pragma solidity ^0.4.0;

contract MyContract{

    address owner;
    //This will specifiy number of subscriptions can be made
    uint public subscriptions;
    //this price variable specifies the cost of each subscription
    uint constant price = 1 ether;
    
    //Here it is made public to see who is subscribing to which topic. 
    mapping(address => uint) public subscribers;
    
    //Now we have to create a constructor

    function MyContract(uint s) {
        //I have to specifiy who is owner. 
        owner = msg.sender;
        subscriptions = s;
    }
    
    //creating  a fall back function 
    
    function () payable {
        performSubscription(1);
    }
    
    //Declerations are done perfectly and here we have to specifiy a constructor for perform subscriptions. 
    function performSubscription(uint num_of_subscriptions) payable{
        //We have to check whethere subscriptions are available or not and balance that is requested is matching to our ticket value
        
        if (msg.value != (num_of_subscriptions * price) || num_of_subscriptions > subscriptions){
            throw;
        }
        
        //If everything is perfect we should subscriptions to the subscriber by increase the amount. 
        subscribers[msg.sender] += num_of_subscriptions;
        //Decrease the num_of_subscriptions from whole amount
        subscriptions -= num_of_subscriptions;
        
        //If all subscriptions got finished and contract functionality is donw. Send back the remaining amount back owner address(address to the contract deployed) and make the contract unavailable
        if (subscriptions == 0){
            selfdestruct(owner);
        }
    }
    
    //I want to do a digital signature which website is doing subscription contract
    function website() returns (string);
}

//If you want to pass any functionality to only particular type of contract like cancel subscriptions. 
//we have to build those funcitons on interfaces. 

interface cancelSubscription{
    function cancelSub(uint no_sum) returns (bool); 
}

contract WebsiteOneSubscriptionContract is MyContract(10), cancelSubscription{
    function cancelSub(uint no_sum) returns (bool){
        if (subscribers[msg.sender] < no_sum){
            return false;
        }
        
        msg.sender.transfer(no_sum * price);
        subscribers[msg.sender] -= no_sum;
        subscriptions += no_sum;
        return true;
    }
    function website() returns(string){
        return "http://1stWebsite.com";
    }
    
}

contract WebsiteTwoSubscriptionContract is MyContract(5){
    function website() returns(string){
        return "http://2ndWebsite.com";
    }
}

contract WebsiteThreeSubscriptionContract is MyContract(15){
    function website() returns(string){
        return "http://3rdWebsite.com";
    }
}
