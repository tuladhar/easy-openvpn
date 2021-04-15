#!/bin/bash
# Author: Puru Tuladhar
# GitHub: http://github.com/tuladhar/easy-openvpn

set -e
set -o pipefail

#########
# INPUT #
#########
NAME=
OPENVPN_ENDPOINT=
CLIENT=
OVPN_DATA=

function install_docker {
	which docker > /dev/null && return
	curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh get-docker.sh
}

function init_openvpn {
	sudo docker volume inspect $OVPN_DATA > /dev/null && return
	sudo docker volume create --name $OVPN_DATA
	sudo docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u udp://$OPENVPN_ENDPOINT
	sudo docker run -v $OVPN_DATA:/etc/openvpn --rm -it -e "EASYRSA_BATCH=1" -e "EASYRSA_REQ_CN=CA" kylemanna/openvpn ovpn_initpki nopass
}

function install_openvpn_systemd {
	[ -f /etc/systemd/system/docker-openvpn@$NAME.service ] && return
	# Maybe use? is-active?
	curl -L https://raw.githubusercontent.com/kylemanna/docker-openvpn/master/init/docker-openvpn%40.service | sudo tee /etc/systemd/system/docker-openvpn@$NAME.service
	sudo systemctl enable --now docker-openvpn@$NAME.service
	sudo systemctl status docker-openvpn@$NAME.service
}

function generate_client_config {
	sudo docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full $CLIENT nopass
	sudo docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient $CLIENT > $CLIENT.ovpn
	echo "OpenVPN client configuration successfully saved as $CLIENT.ovpn"
}

flags=(
    "name"
    "endpoint"
    "client"
)

cli=$(getopt \
    --longoptions "$(printf "%s:," "${flags[@]}")" \
    --name "$(basename "$0")" \
    --options "" \
    -- "$@"
)

eval set -- "$cli"

while true; do
	case "$1" in
	--name)
		NAME=$2
		shift 2;
		;;
	--endpoint)
		OPENVPN_ENDPOINT=$2
		shift 2;
		;;
	--client)
		CLIENT=$2
		shift 2;
		;;
	*)
		break
		;;
	esac
done

if [[ -z $NAME ]]; then
	echo -e "Error: --name is required"
	exit 1
fi

OVPN_DATA="ovpn-data-$NAME"

if [[ ! -z $CLIENT ]]; then
        generate_client_config
	exit 0
fi

if [[ -z $OPENVPN_ENDPOINT ]]; then
	echo -e "Install OpenVPN:\n\t$0 --name [NAME] --endpoint [OPENVPN_ENDPOINT]"
	echo
	echo -e "Generate and Download Client Configuration:\n\t$0 --name [NAME] --client [CLIENT_NAME]"
	exit 1
fi

install_docker
init_openvpn
install_openvpn_systemd	

