pragma solidity ^0.7.0;
pragma abicoder v2;


struct Issue{
    string link_to_issue;
    mapping(string=>address) users_in_this_issue;
    string maintainer;
    address maintainer_address;
    uint value;
    bool solved;
}

contract bounty_hunter{
    mapping(string=>Issue) issue_table;
    mapping(string=>address) user_table;
    string[] issue_links;
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
    
    function compare(string memory _a, string memory _b) pure private returns (int) {
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
    function equal(string memory _a, string memory _b) pure private returns (bool) {
        return compare(_a, _b) == 0;
    }
    
    //function used to create a user and persist it on the maaping user_table.
    function createUser(string memory git_username) public{
        require(user_table[git_username] == address(0x0), "User already exists!");
        user_table[git_username] = msg.sender;
    }
    
    //function used to create an issue and persist it on the maaping issue_table.
    //maintainer must exist in the db and the link to the issue act as unique key.
    function createIssue(string memory new_link, string memory maintainer) public payable{
        require(user_table[maintainer] != address(0x0), "This user does not exists!");
        require(equal(issue_table[new_link].link_to_issue, ""), "Issue with this link already created!");
        issue_table[new_link].link_to_issue = new_link;
        issue_table[new_link].maintainer = maintainer;
        issue_table[new_link].maintainer_address = msg.sender;
        issue_table[new_link].value = msg.value;
        issue_links.push(new_link);
        index_of_issues += 1;
    }
    
    //Returns issue informations(link, maintainer name, value) based on the link parameter passed.
    function viewIssue(string memory link_from_issue) public view returns(string memory){
        string memory json_string = issue_table[link_from_issue].link_to_issue;
        json_string = string(abi.encodePacked(json_string, ", "));
        json_string = string(abi.encodePacked(json_string, issue_table[link_from_issue].maintainer));
        json_string = string(abi.encodePacked(json_string, ", "));
        json_string = string(abi.encodePacked(json_string, uint2str(issue_table[link_from_issue].value)));
        return json_string;        
    }
    
    function listIssues() public view returns(string memory){
        string memory concatenate_issues;
        for(uint i = 0; i < issue_links.length; i++){
            concatenate_issues = string(abi.encodePacked(concatenate_issues, viewIssue(issue_links[i])));
            concatenate_issues = string(abi.encodePacked(concatenate_issues, "\n"));
        }
        
        return concatenate_issues;
    }
    
    function countIssues() public view returns(string memory){
        string memory total = string(abi.encodePacked(uint2str(index_of_issues), " issues have already been persisted in this contract"));
        return total;
        // require(false, total);
    }
    
    function acceptIssue(string memory issue_link, string memory git_username) public{
        require(issue_table[issue_link].users_in_this_issue[git_username] == address(0x0), "User already working in this issue!");
        issue_table[issue_link].users_in_this_issue[git_username] = msg.sender;
    }
    
    function closeIssue(string memory issue_link, string memory user_that_solved_this_issue) public payable{
        require(msg.sender == issue_table[issue_link].maintainer_address, "This user is not the maintainer of this issue!");
        address payable sender = payable(issue_table[issue_link].users_in_this_issue[user_that_solved_this_issue]);
        sender.transfer((issue_table[issue_link].value/10)*9);
        issue_table[issue_link].solved = true;
        issue_table[issue_link].value = 0;
        issue_table[issue_link].maintainer_address = address(0x0);
    }
    
    function boostIssue(string memory issue_link) public payable{
        issue_table[issue_link].value += msg.value;
    }
    
    
}
