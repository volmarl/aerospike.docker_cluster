ipaddress=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' aerospike3)
echo $ipaddress
for f in {3..9} ; do
ipaddress2=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' aerospike${f})
echo $ipaddress2
asinfo -v "tip:host=${ipaddress};port=3002" -h ${ipaddress2} 
done;
