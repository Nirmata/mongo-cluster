var status = rs.status();
printjson(status);
if(status.ok == 0) {
	printjson(rs.initiate());
}
