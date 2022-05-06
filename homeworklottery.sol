pragma solidity ^0.5.2;

contract Lottery{
    
    address payable[11] participants;
    uint8 participantsCount = 0;
    uint randNonce = 0;
	uint256 public roud=1;
    uint lottery_StartTime=now ;//彩票首次开始时间
  

    function join() public payable {
	    
        require(msg.value == 1 ether, "assume one lottery ticket 1 ether，must be this ");
        require(joined(msg.sender) == false, "Already joined");
        participants[participantsCount++] = msg.sender;
        
        if((participantsCount == 11)||(now >= lottery_StartTime + 1 hours)){
            selectWinner();
        }
    }
    
    function selectWinner() private {
        uint rand = uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % 3;
        address payable winner = participants[rand];
        winner.transfer(address(this).balance);
        delete participants;
        participantsCount = 0;
		roud++;
		lottery_StartTime=now;
    }
    
    function joined(address payable _participant) private view returns(bool){
        for(uint i=0; i<participantsCount; i++){
            if(participants[i] == _participant){
                return true;
            }
        }
        return false;
    }
    
    function countParticipants() public view returns(uint){
        return participantsCount;
    }
    function participant(uint _index) public view returns(address payable){
        require(_index < 11, "Please input a number less than 11");
        return participants[_index];
    }
    function contractBalance() public view returns(uint){
        return address(this).balance;
    }
}