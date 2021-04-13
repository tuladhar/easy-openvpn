## Introduction

> Easy OpenVPN allows you to hassel-free setup an OpenVPN server using Docker with a single command.

## Installation
```
$ curl -sSL https://raw.githubusercontent.com/tuladhar/easy-openvpn/main/easy-openvpn.sh > easy-openvpn.sh
$ chmod +x easy-openvpn.sh
```

## Easy OpenVPN Installation

**NOTE:**
* `ENDPOINT` can be an IP address or domain name of the openvpn server.
* Allow the UDP port 1194 (openvpn) on the firewall.

```
$ ./easy-openvpn.sh --name example --endpoint ENDPOINT
```

## Generate Client Configuration

```
$ ./easy-openvpn.sh --client client1
$ ./easy-openvpn.sh --client client2
$ ./easy-openvpn.sh --client client3
```
