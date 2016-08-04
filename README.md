#Design Rules:
 * All Firebase calls go in FirebaseHelper. No Firebase calls are to be made outside of FirebaseHelper. The same goes for EventHelper an calls to Eventbright

#Firebase Structure:

 <RoomId> will be the eventbright eventId

ChatRooms:
	<RoomId>: <isActive>,
	<RoomId>: <isActive>,
	<RoomId>: <isActive>

ChatRoomDetails:
	<RoomId>: 
		isActive: <isActive>,
		name: <eventName>,
		userList:
			<UserId>: false,
			<UserId>: false

Messages:
	<RoomId>:
		<MessageId>: 
			body: <messageBody>,
			sender: <UserId>
		<MessageId>: 
			body: <messageBody>,
			sender: <UserId>
	<RoomId>:
		<MessageId>: 
			body: <messageBody>,
			sender: <UserId>
		<MessageId>: 
			body: <messageBody>,
			sender: <UserId>

