pragma solidity ^0.7.0;


struct Issue{
    string link_to_issue;
    // string language;
    mapping(string=>address) users_in_this_issue;
    string maintainer;
    address maintainer_address;
    uint value;
    // bool solved;
    // User[] boosters;
}

contract bounty_hunter{
    mapping(string=>Issue) issue_table;
    mapping(string=>address) user_table;
    uint index_of_issues;
    
    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
    
    function compare(string memory _a, string memory _b) public returns (int) {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);
        uint minLength = a.length;
        if (b.length < minLength) minLength = b.length;
        //@todo unroll the loop into increments of 32 and do full 32 byte comparisons
        for (uint i = 0; i < minLength; i ++)
            if (a[i] < b[i])
                return -1;
            else if (a[i] > b[i])
                return 1;
        if (a.length < b.length)
            return -1;
        else if (a.length > b.length)
            return 1;
        else
            return 0;
    }
    /// @dev Compares two strings and returns true iff they are equal.
    function equal(string memory _a, string memory _b) public returns (bool) {
        return compare(_a, _b) == 0;
    }
    
    
    function createUser(string memory git_username) public{
        require(user_table[git_username] == address(0x0), "Usuario ja existe!");
        user_table[git_username] = msg.sender;
    }
    
    // function listUser(string memory param) public view returns(address){
    //     return user_table[param];
    // }
    
    function createIssue(string memory new_link, string memory maintainer) public payable{
        require(equal(issue_table[new_link].link_to_issue, ""), "Issue ja cadastrada");
        issue_table[new_link].link_to_issue = new_link;
        issue_table[new_link].maintainer = maintainer;
        issue_table[new_link].maintainer_address = msg.sender;
        issue_table[new_link].value = msg.value;
    }
    
    function closeIssue() public payable{
        
    }
    
    function viewIssue(string memory link_from_issue) public view returns(string memory){
        string memory json_string = issue_table[link_from_issue].link_to_issue;
        json_string = string(abi.encodePacked(json_string, ", "));
        json_string = string(abi.encodePacked(json_string, issue_table[link_from_issue].maintainer));
        json_string = string(abi.encodePacked(json_string, ", "));
        json_string = string(abi.encodePacked(json_string, uint2str(issue_table[link_from_issue].value)));
        return json_string;        
    }
    
    function listIssues() public view{
        
    }
    
    function acceptIssue() public{
        
    }
    
    // function boostIssue(){
        
    // }
    
    
}
