FEEGOW DOCKER
=====
This repository contains Dockerfiles, docker-compose files and other docker related stuff to make Feegow run within a docker container.

REQUIREMENTS
=====
- Windows 10/11 Pro or Enterprise edition (Home edition does not support virtualization but I'm working on a possible workaround)
- Docker Desktop v4.16.3+ (https://www.docker.com/products/docker-desktop)
- Docker Compose v2.0.0+ (https://docs.docker.com/compose/install/)

BEFORE YOU START
=====
- switch Docker Desktop to use Windows Containers
- enable experimental features in Docker Desktop settings
- enable Hyper-V and Containers in Windows Features

RUNNING FEEGOW
=====
- clone this repository
- Optional:
  - put the dumpfiles in the ./mysql/dump folder
      - note that importing the dumpfiles will take a <long> while
        - if you want to skip importing the dumpfiles, leave it alone and use your database manager to import the dumpfiles. 
        - I'm mapping port 3307 from the host machine to the mysql container, so you can use your database manager to connect to the database
- adjust the paths in the docker-compose.yml (feegoe-web volumes) file to match your environment
  - it's important to keep the bind mounts pointing to thw wwwroot folder as I wasn't able to handle permissions outdisde this folder 
- open a terminal in the root of this repository
- run `docker-compose up -d`
  - building the iis image will take a while
  - if you've chosen to import the dumpfiles, this will take a <large> while!
- open a browser and go to http://localhost:880

MAPPINGS
=====
- localhost:880 -> wwwroot folder in iis container
- localhost:3307 -> mysql container

TODO
=====
- Write a dockerfile to build a php imegae with the required extensions
  - it looks like the php image from docker hub won't work in this environment due to the STOPSIGNAL sent to the host machine
  - for while, it will work with the php running on the host machine
  - map feegow-api folder, set it's variables etc so it can run in the container