rm log* 
./ezshare & 
sleep 1
./ezshare cli &
read myline
cat log.* 
echo "" 
cat log2*

