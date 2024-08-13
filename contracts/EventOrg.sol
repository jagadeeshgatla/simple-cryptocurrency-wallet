pragma solidity >=0.8.2 <0.9.0;
contract EventOrgContract
{
    struct Event{
       address eventOrganizer;
       string attendeeName;
       uint eventDate;
       uint eventPrice;
       uint ticketCount;
       uint ticketPending;
    }
       mapping(uint=>Event) public events;
       mapping(address=>mapping(uint=>uint)) public tickets;
       uint public eventId;

       function createEvent(string memory attendeeName, uint eventDate, uint eventPrice, uint ticketCount) external 
       {
        require(eventDate>block.timestamp, "Please organize your event in future dates");
        require(ticketCount>0,"You can't book tickets for zero, it should be greater than equal to 1");
        events[eventId]=Event(msg.sender, attendeeName, eventDate, eventPrice, ticketCount, ticketCount);
        eventId++;
       }

       function buyEventTicket(uint buyId, uint buyquantity) external payable
       {
        require(events[buyId].eventDate!=0, "There is no event exists");
        require(events[buyId].eventDate>block.timestamp, "This event already occured");
        Event storage _event = events[buyId];
        require(msg.value==(_event.eventPrice*buyquantity), "Ethers are not enough to buy");
        require(_event.ticketPending>buyquantity, "Not enough Event tickets are available");
        _event.ticketPending = buyquantity;
        tickets[msg.sender][buyId]+=buyquantity;

       }

       function transferEventTicket(uint buyId, uint buyquantity, address transferToAddr) external 
       {
        require(events[buyId].eventDate!=0, "There is no event exists");
        require(events[buyId].eventDate>block.timestamp, "This event already occured");
        require(tickets[msg.sender][buyId]>=buyquantity, "You do not have enough event tickets");
        tickets[msg.sender][buyId]-=buyquantity;
        tickets[transferToAddr][buyId]+=buyquantity;

       }
    
}