![](easy-openvpn.png)

> Quick and easy way to setup an OpenVPN server using Docker with a single command.

## Installation
```
$ curl -fsSLO https://raw.githubusercontent.com/tuladhar/easy-openvpn/main/easy-openvpn.sh
$ chmod +x easy-openvpn.sh
```

## OpenVPN Easy Installation

**NOTE:**
* `ENDPOINT` can be an IP address or domain name of the openvpn server.
* Allow the UDP port 1194 (openvpn) on the firewall.

```
$ ./easy-openvpn.sh --name example --endpoint ENDPOINT
```

## Generate Client Configuration

```
$ ./easy-openvpn.sh --name example --client client1
$ ./easy-openvpn.sh --name example --client client2
$ ./easy-openvpn.sh --name example --client client3
```

## Powered By
* https://openvpn.net/
* https://www.docker.com/
* https://github.com/kylemanna/docker-openvpn
