#!/bin/bash
cd `dirname "$0"`
if mkdir $1
    then
    . ./vars
    ./pkitool $1
else
    # pushd $1
    a=1
fi

# cp keys/$1.crt $1/client.crt
# cp keys/$1.key $1/client.key
# cp keys/ca.crt $1/ca.crt
# cp keys/ta.key $1/
# cp client.ovpn $1/

pushd $1
# zip -9 $1.zip client.crt client.key ca.crt ta.key client.ovpn
# tar cvf - client.crt client.key ca.crt ta.key client.ovpn | gzip -9 - > $1.tgz

cat <<EOF> {{ openvpn_name }}.ovpn
client
dev {{ openvpn_dev }}
proto udp
remote {{ openvpn_access_address }} {{ openvpn_listen_port }}
resolv-retry infinite
nobind
;user nobody
;group nogroup
persist-key
persist-tun
ns-cert-type server
;tls-auth ta.key 1
<ca>
$(cat ../keys/ca.crt)
</ca>
<cert>
$(cat ../keys/$1.crt)
</cert>
<key>
$(cat ../keys/$1.key)
</key>
comp-lzo
verb 3
EOF

# mkdir -vp share
#
# zip -9 -e -P $(openssl rand -base64 32|tee /dev/stderr) share/$1.zip {{ openvpn_name }}.ovpn

# cd share
# python -m SimpleHTTPServer 8001
popd
