#!/bin/bash
cd `dirname "$0"`
if mkdir -v $1
    then
    . ./vars
    ./pkitool $1
else
    # pushd $1
    a=1
fi

cp -v keys/$1.crt $1/client.crt
cp -v keys/$1.key $1/client.key
cp -v keys/ca.crt $1/ca.crt
cp -v keys/ta.key $1/
cp -v client.ovpn $1/
pushd $1
zip -9 $1.zip client.crt client.key ca.crt ta.key client.ovpn
tar cvf - client.crt client.key ca.crt ta.key client.ovpn | gzip -9 - > $1.tgz

#(
#cat message.txt
#printf "\n\n"
#uuencode $1.zip $1.zip
#)|mail -s "VPN key for user $1" ihryamzik@gmail.com $1@gmail.com
python -m SimpleHTTPServer 8001
popd
