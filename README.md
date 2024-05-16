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

## Installation

1. Clone this [repository](git@github.com:stuartlynne/traefik_racedb.git)
2. make build-clean




