# traefik_racedb
## Stuart.Lynne@gmail.com
## Sat Jun  8 12:11:48 PM PDT 2024

## Overview

This is a standalone project showing how to use *Traefik* as a reverse proxy for *RaceDB* and *QLMuxProxy*.

This allows *RaceDB* and *QLMuxProxy* to be accessed via *HTTPS* using domain names.

*Traefik* is a modern HTTP reverse proxy and load balancer that makes deploying micro-services easy. 
In this project, we will use Traefik to route HTTPS requests to the RaceDB or the QLMux Proxy applications running in their respective Docker containers.

Depending on requirements this setup can support access to the applications from within the local network or from the Internet. 
Access from the Internet will require additional configuration of the firewall and DNS.

Traefik will automatically generate and renew Let's Encrypt certificates for the domain names used to access the services. 
This requires that access to your DNS provider is available via an API and that you have an API key.


### RaceDB
*RaceDB* is a web-based Race Management application that is used to manage cycling races. 
See [Git Repository](https://github.com/esitarski/RaceDB) for more information.

The default access for RaceDB is via HTTP which causes problems with modern browsers:
- Chrome will warn about the site being insecure
- Chrome will prevent downloading files from the site without jumping through hoops to verify the file is should be kept

### QLMuxProxy
*QLMuxProxy* is a simple web application that acts as a proxy for the RaceDB application. It is a Flask application that uses SNMP Broadcast
discovery to find and manage Brother QL Label Printers and an Impinj RFID reader. See [Git Repository](git@github.com:stuartlynne/qlmux_proxy.git) for more information.

The default access is via HTTP. There are no inherent security issues with this application, but it is convenient to have it available via HTTPS.


## Prerequisites

- port 80, 443, and 8080 are available on the host
- port 80 and 443 are passed through the firewall if you want to access the services from outside the host
- an account at a DNS provider that allows access through an API and you have the API key
- domain names for the services you want to run e.g.: racedb.wimsey.pro, qlmux.wimsey.pro
- the local DNS server is configured to resolve the domain names to the host IP address


## DNS API Configuration
See docker.env for the required environment variables for the DNS provider.

For testing this project I bought a domain name from Namecheap and used their DNS service which has an API that Traefik can use to update the DNS records.
The cost for this was $10 for the domain name. The API key is available in the Namecheap account settings, but is only enabled if you have 20 domains
registered with them or if you maintain a balance of $50 in your account (this is to prevent abuse of the API).


## Installation

Clone the repository to the host where you want to run the services. Copy and edit these files:

```
  cp docker.env-template docker.env
  cp dnschallenge.env-template
```

N.b. The docker.env file contains the environment variables for the Traefik container. 
The dnschallenge.env file contains the environment variables for the DNS challenge.

*DO NOT* add the dnschallenge.env file to the repository as it contains sensitive information.


## DNS Configuration

This requires a *split-horizon* DNS configuration. The domain names used to access the services must resolve to the host IP address
from within the local network and to the public IP address from the Internet.

### Local DNS Configuration

To access the services from within your network, you will need to configure your local DNS server to resolve the domain names to the host IP address.

If you only need to access the services from the host (or perhaps a small number of hosts), 
you can add the domain names to the */etc/hosts* file on each host that needs to access them.

On a Linux host you can add the following to the /etc/hosts file:
```
192.168.40.16 racedb.wimsey.pro
192.168.40.16 qlmuxproxy.wimsey.pro
```

On a PiHole server, you can add the following to the /etc/pihole/custom.list file:
```
192.168.40.16 racedb.wimsey.pro
192.168.40.16 qlmuxproxy.wimsey.pro
```

### DNS Configuration for Internet Access

If you need to access the services from the Internet, you will need to configure your DNS provider to resolve the domain names to the host IP address
for each service.
```
racedb.wimsey.pro. CNAME whiskey4.wimsey.co.
```

Your router firewall will need to forward port *443* to the host running the services.


## RaceDB Configuration

RaceDB is a Django application and requires that the domain name being used is added
to the settings.py file, e.g.:

```
CSRF_TRUSTED_ORIGINS = ["https://racedb.wimsey.pro", ]
```

This can be done by editing the settings.py file in the RaceDB container, e.g. assuming "racedb_app" is the name of the container:
```
docker exec -it racedb_app bash
cd /RaceDB/RaceDB
echo "CSRF_TRUSTED_ORIGINS = ['https://racedb.wimsey.pro', ]" >> settings.py
```

## Traefik Configuration

In this example all of the Traefik configuration is done in the docker-compose.yml file using docker commands and labels.
That allows the configuration to be changed via environemnt variables in the traefik.env file.

For more advanced configuration:
- the command options are moved to either a traefik.toml file or traefik.yml file
- the routers and service definitions would be moved to dynamic configuration files in the dynamic directory.

While the dynamic configuration is more flexible, it is also more complex and requires more knowledge of Traefik and
cannot be configured via environment variables. But there are also more options available that may be required for
more complex setups.

## Certificate Configuration

To keep this example simple a single wild-card certificate is used for all of the services. E.g: *.wimsey.pro

There are reasonable arguments for using a separate certificate for each service, but that is not covered in this example.

Separate certificates would require separate DNS challenges for each service and would require more complex Traefik configuration.
But would be more secure. This would be suggested for a production environment if making them available on the Internet.


## [Traefik Readme](traefik.md)

## [Makefile](makefile.md)

## [Related Projects](related.md)

