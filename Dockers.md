# Docker - Getting started

## Containers
- They basically slice and dice operating system unlike Hypervisor which slice and dice physical resources
- Operating System virtualization
- They are light weight 
- PID,Net and FS
### Docker commands
  - `docker ps` - list running containers
  - `docker info` - info of docker with running containers list etc..
  - `docker images`
  - `docker container ps --all`
### Docker 
- Installing docker gives CLient and Deamon
- Client inteprets the docker commands and sends appropriate info to deamon to execute
- Daemon implements the Docker remote API
- Docker hub is the public registry from where the images are pulled
- `docker run` starts a new conatiner

### Containers Lifecycle
-  start, stopped, removed
- ctrl p+q to exit container without killing container.
- `docker stop $(docker ps -aq)` stop all the container in a quite mode resulted from docker ps -aq  - q lists only ids of container
- `docker rm $(docker ps -aq)` remove all the containers

### Docker swarm mode and microservices
- A Cluster of Docker engine working together = A swarm
- Engines in a swarm run in swarm mode
- Manager nodes maintain the swarm
  - odd numbers are preffered similar to mongo replicas set concept
  - only one leader
- Worker nodes execute tasks
- Services - Is a declarative way of running and scaling tasks
- TAsks - Assigned to workers-basically containers
### cmds to build swarm mode
- `docker swarm init --advertise-addr ipadrress:2377 --listen-address ipadrress:2377`
- `docker swarm join-token worker or dokcer swarm join-token manager` - gives a token to be used to join the swarm
- `docker service create --name testapp -p 8080:8080 --replicas 5 image`
- `docker service inspect testapp`
- `docker service update --image imagename --update-delay 20s --update-paralleslism 3 servicename`
### Stacks


## Docker Networking
- Three Pillars of Docker networking
  - Container network model
  - Lib networks
  - Drivers
- CNM- Container network model - is a specification documentations proposed by Docker Inc
- CNM---->Libnetwork--->Driver
> CNI - Container Network Interface is rival spec of CNM its more suited to kubenetes environment
- CNM defines 3 major constructs
  - Sandbox -> namespace -i.e Isolated area of OS contains full network stack
  - Endpoint -> Network interface - ex eth0 
  - Network -> connected endpoints
- Libnetwork - Real -world implementation of CNM by Docker, Inc
- Driver - Network-specific detail
  - overlay
  - MACVLAN
  - IPVLAN
  - Bridge
- Docker network scopes
  - local - local host
  - swarm - multi host
- `docker network ls`
- `docker network inspect networkName`

#### Docker netwroking usercases and drivers
- Single-host networking
- Multi-host networking 
- working with existing networks
  - macvlan driver
  - IpVlan driver
- ---------------------------------------------- -
- Single host networking
  - Bridge netwrok are single host network scoped locally
  - `docker network create -d bridge --subnet 10.0.0.1/24 nameOfnerwork`
  - what it basically dose is create a 802.1d bridge a.k.a virtual switch /vswitch
- Multi host networking
  - Docker overlay driver
  - vxLAN tunnel
  - `docker network create -d overlay nameOfnerwork`
- Participating in existing network
  - MACVLAN driver - a linux specific driver
    - Every container gets its own IP and Own MAC address
    - MacVLAN networkf for docker is maily used when you want to add container to an existing VLAN without disrupting things
    - MACVLAN requires PROMICUOUS MODE!! on network card
      - most public cloud providers dont allow it
  - IPVLAN driver 
    - similar to Linux MACVLAN only diff is that the mac address is shared
    - similar to windows I2bridge
    - special consideration when working with DHCP since it assigns ip based on mac address
    - containers cannot ping their host
### Network Services
- Service discovery
  - SD is automatic in docker 
    - for container created with --name or --alias
    - for services
  - Every container gets a small DNS resolver
    - listens on 127.0.0.11:53
    - forwards requests to DNS server on Docker host 
  - DNS are networkScoped i.e container should be on same network
- Port-based Routing with Routing Mesh
  - Is all about routing and balancing request coming from outside
  - vip based routing/forwarding on ingress layer
- App-aware Routing with Http Routing Mesh(HRM)
  - limitation of port-based routing is that you cant have 2 services running in the same port
  - HRM operates at the application layer
  - Requires Docker Datacenter(a commercial version)

----------------------------------------------------------
## Docker for Web developers
- What is docker?
  - Simplify building, shipping, running apps
  - shipping container system for code 
  - runs nativerly on os
  - runs on windows or mac dev (with virtual machine)
- What is docker image?
  - Image that is used to create a running instance of a container.
  - A image is a readonly template composed of layered filesystems used to share common files used to create conatiners
  - Container - An isolated and secureed shipping container created from an image that can be run, started,stoped,moved and deleted
- Advantage of docker for web developers
  - accelerate developer onboarding
  - elimate app conflicts - legacy app dependency deployment
  - environment consistency  
  - ship software content
- How to get source code into container
  - Layered file system
    - imges layers are readonly layer but when you run a image it turns to container with a thin readwrite layer called container layer
    - this thin r/w layer is called volume
  - Docker Volumes
    - Special type of directory in a container typically refered as a data volume
    - can be shared and reused among containers
    - updates on image wont affect a data volume
    - data volume are persisted even after the conatiner is deleted
  - ` docker run -p 8080:3000 -v $(pwd):/var/www -w "/var/www" node npm start`
    - -w -> sets the working dir of the conatiner to /var/www
- Building cutom imaged with Dockerfile
  - Text file used to build docker images
  - contains build instructions
  - key docker file instructions
    - FROM 
    - MAITAINER
    - RUN
    - COPY
    - ENTRYPOINT - on sarting container what all should run
    - WORKDIR - set workdir
    - EXPOSE - port
    - ENV - set env variables
    - VOLUME -
    - CMD
   >Note : diff between run and cmd in docker file ..is that run cmd executes inside the docker image during build time and get written as an intemediate image layer. where as cmd lets you define a default command to run when your container starts
  - `docker build -t nameOfImage .`
- Publishing an image to docker hub
  - docker push username/nameOfContainer
- Communicating between docker containers
  - start a docker container with name
  - run another container to be linked this container with --link
    - `docker run -d --link containerName:aliasName  imageName` 
    - here you can access the container from another container with alias name ex: http://aliasname/ping
  - > `docker exec containerName cmdTobeExecuted`
  - bridge network
    - a container can be on multiple bridge network
    - `docker network create --driver bridge nameOfNetwork`  
    - `docker run -d --net=networkName --name mongodb mongo`
-------------------------------------------------------------------------
### Docker Compose
- start ,stop and rebuild services
- view the status of running services
- stream log output of running services
- run a one-off command on a service
- docker-composer.yml - a file specifing container and relations 
- build service-> startup services -> teardown service
- docker compose key configurations
  - build
  - environment
  - image
  - networks
  - ports
  - volumes
- Docker compose commands
  - docker-compose build
  - docker-compose up
  - docker-compose down
  - docker-compose logs
  - docker-compose ps
  - docker-compose stop
  - docker-compose start
  - docker-compose rm
  - `docker-compose build mongo` - builds only mongo
  - `docker-compose up ` - brings up entire docker-compose services in docker-compose yml
  - `docker-compose up --no-deps node` - only node image is bought up
  - --no-deps do not recreate services that node depend on
  - `docker-compose down --rmi all --volume`
  >Note: - `docker-compose build` works only on cutom image creation . For existing image to be build and used run `docker-compose up`.

