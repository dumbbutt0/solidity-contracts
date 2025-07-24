// SPDX-License-Identifier: MIT
//Message-Board created and Deployed by Clownstr1k3
//Donations and Motivations accepted at 0x022eFf0B46A27f37200F57b1E128343b138FA356

pragma solidity 0.8.24;

import "./Ownable.sol";


contract MessageBoard is Ownable{

    //Format for MESSAGES
    struct Message{
        uint MessageId;
        string Name;
        string Text;
        address sender;
    }

    
    event MessageSent(Message _message);
    Message[] Messages;
    mapping(string => Message[]) MessagesByName;


    //Sends Messages to the BlockChain and stores them in Arrays and Mappings 
    function SendMessage(string memory _name, string memory _text) public returns(Message memory){
       bytes memory NameLength = bytes(_name);
       bytes memory TextLength = bytes(_text);
       if(NameLength.length > 24){
        revert("Your name is too long ;)");
       }
       if(TextLength.length > 650){
        revert("Your message is too long ;)");
       }
       Message memory message;
       message.MessageId = Messages.length + 1;
       message.Name =_name;
       message.Text = _text;
       message.sender = msg.sender;
       Messages.push(message);
       MessagesByName[_name].push(message);
       emit MessageSent(message);
       return message;
    }

    //Reads most recent by the array index
    function MostRecent()public view returns(Message memory){
        uint MessageID =Messages.length;
        if (MessageID == 0){
            revert("No Messages have been sent, You can be the first!");
        }
        return Messages[MessageID -1];
    }

    //Reads message by specified ID
    function ReadById(uint ID) public view returns(Message memory){
        if(ID >= Messages.length|| ID == 0){
            revert("That Message Doesnt Exist. :(");
        }
        return Messages[ID-1];
    }
    //Reads all messages of a specified user
    function ReadByName(string memory _name) public view returns(Message[] memory){
         return MessagesByName[_name]; } 

    //Reads all messages
    function ReadAll() public view returns(Message[] memory){
        return Messages;
    }

    //Delete a message
    function Delete(uint _ID) public onlyOwner{
       if (_ID == 0 || _ID > Messages.length) {
        revert("Invalid Message ID");
    }
    uint bye =_ID -1;

    string memory name = Messages[bye].Name; // Save name to update mapping
    
    // Remove from MessagesByName (shift and pop)
    Message[] storage nameMsgs = MessagesByName[name];
    for (uint i = 0; i < nameMsgs.length; i++) {
        if (nameMsgs[i].MessageId == _ID) {
            for (uint j = i; j < nameMsgs.length - 1; j++) {
                nameMsgs[j] = nameMsgs[j + 1];
            }
            nameMsgs.pop();
            break;
        }
    }
    
    delete Messages[bye];
    }
}


