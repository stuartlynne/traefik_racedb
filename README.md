# traefik_racedb
# Thu May 16 10:31:32 AM PDT 2024

## Overview

This is a simple project to demonstrate how to use Traefik as a reverse proxy for RaceDB and QLMux Proxy.

*Traefik* is a modern HTTP reverse proxy and load balancer that makes deploying microservices easy. In this project, we will use Traefik to
route HTTPS requests to the RaceDB or the QLMux Proxy applications running in their respective Docker containers.

*RaceDB* is a web-based Race Management application that is used to manage cycling races. It is a Django application that uses a PostgreSQL database.
See [Git Repository](https://github.com/esitarski/RaceDB) for more information.

*QLMux Proxy* is a simple web application that acts as a proxy for the RaceDB application. It is a Flask application that uses SNMP Broadcast
discovery to find and manage Brother QL Label Printers and an Impinj RFID reader. See [Git Repository](git@github.com:stuartlynne/qlmux_proxy.git) for more information.


## Prerequisites

- port 80, 443, and 8080 are available on the host
- port 80 and 443 are passed through the firewall if you want to access the services from outside the host
- an account at a DNS provider that allows access through an API and you have the API key
- domain names for the services you want to run e.g.: racedb.wimsey.dev, qlmux.wimsey.dev
- the local DNS server is configured to resolve the domain names to the host IP address


## DNS API Configuration
See provider.env for the required environment variables for the DNS provider.

## Installation

1. Clone this [repository](git@github.com:stuartlynne/traefik_racedb.git)
2. Edit the two files in dynamic to set the domain names for the services.
3. make build-clean

## Local DNS Configuration

To access the services from within your network, you will need to configure your local DNS server to resolve the domain names to the host IP address.

If you only need to access the services from the host (or perhaps a small number of hosts), you can add the domain names to the /etc/hosts file on each host.
```
192.168.40.16 racedb.wimsey.dev
192.168.40.16 qlmuxproxy.wimsey.dev
```

On a PiHole server, you can add the following to the /etc/pihole/custom.list file:
```
192.168.40.16 racedb.wimsey.dev
192.168.40.16 qlmuxproxy.wimsey.dev
```


## RaceDB Configuration

RaceDB is a Django application and requires that the domain name being used is added
to the settings.py file, e.g.:

```
CSRF_TRUSTED_ORIGINS = ["https://racedb.wimsey.dev", ]
```

This can be done by editing the settings.py file in the RaceDB container, e.g. assuming "racedb_app" is the name of the container:
```
docker exec -it racedb_app bash
cd /RaceDB/RaceDB
echo "CSRF_TRUSTED_ORIGINS = ['https://racedb.wimsey.dev', ]" >> settings.py
```





