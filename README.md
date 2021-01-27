# Malpedia to MISP Docker

1. [Malpedia to MISP Docker](#malpedia-to-misp-docker)
   1. [About](#about)
   2. [Requirements](#requirements)
   3. [Setup](#setup)
   4. [Recommended Update Schedule](#recommended-update-schedule)

## About

The Malpedia to MISP docker project is an offshoot of the [Malpedia to MISP ingestor project](https://github.com/malwaredevil/malpedia_to_misp). The aim of this project is to make deploying the Malpedia to MISP ingestor a much simpler process.

## Requirements

1) You will need [docker](https://www.docker.com/) and [docker-compose](https://docs.docker.com/compose/) installed.
2) You will need a working [MISP](https://www.misp-project.org/) instance.
   1) Recommended:
      1) 10 Default and Prio workers running
   2) Required
      1) A MISP Key that can add incidents
3) You will need a [Malpedia](https://malpedia.caad.fkie.fraunhofer.de/) account
   1) Required:
      1) [A Malpedia api key](https://malpedia.caad.fkie.fraunhofer.de/usage/api)
      2) [ A ssh key associated with your account so you can download the Malpedia corpus from github](https://malpedia.caad.fkie.fraunhofer.de/usage/website)
4) Create an .env file in the ./docker/m2m directory using the instructions contained in the [example.env](./.docker/m2m/example.env) file.
5) Create a ssh.key_pub.txt file and ssh_key.txt file using the instructions contained each of their example files:
   1) [example.ssh_key_pub.txt](./.docker/m2m/example.ssh_key_pub.txt)
   2) [example.ssh_key.txt](./.docker/m2m/example.ssh_key.txt)

## Setup

1) Copy/Clone this project onto your docker host machine.
2) From the ./docker/m2m directory run docker-compose up.
3) The first time it is executed it will:
   1) Setup the Malpedia to MISP ingestor container and a PostgreSQL container
   2) Create 2 volumes for the database and the requisite git repos
   3) Download the Malpedia malware corpus
   4) Catalog and push the malware into your MISP instance.
   5) Shut down
4) Every time thereafter, it will:
   1) Download updates to the Malpedia corpus
   2) Update any new threat actors, malware families, or specimens
   3) Shut down

## Recommended Update Schedule

1) To keep your MISP instance up to date, create a cron job or scheduled task to start the Malpedia to MISP container (and the PostgreSQL container if you shut it down, [it does not automatically shutdown like the Malpedia to MISP container container]).
