http = require("socket.http")

b, c, h = http.request("http://127.0.0.1/saveData.php/")
-- OR

b, c, h = http.request{

	url="http://127.0.0.1/saveData.php/"
	method="GET"

} 
