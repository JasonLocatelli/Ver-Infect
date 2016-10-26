require ("socket.http")
require ("ltn12")
response_body = {}
request_body = "name=nom&time=temps"
socket.http.request {

	url = "http://127.0.0.1/saveData.php",
	method = "POST",
	headers = {
	
		["Content-Length"] = string.len(request_body),
		["Content-Type"] = "application/x-www-form-urlencoded"
		},
	source = ltn12.source.string(request_body),
	sink = ltn12.sink.table(response_body)
}
table.foreach(response_body,print)