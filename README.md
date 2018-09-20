# Quick Start

- Unzip `Corda-Server.zip` in `{project-root-folder}/`
- Open a terminal session to that folder
- Run `docker-compose build`
- Run `docker-compose up -d`
- Run `docker exec -it corda-builder bash`
- At this point you must be inside the docker container, in the root folder of the project. From there, you can run the commands as usual:
	- `./gradlew build -x test`
	- `./gradlew node:capsule:build webserver:webcapsule:build -x test`
	- (...)
- When you finish working with the container, type `exit`
- Run `docker-compose down` to stop the service.

# Dockerfile

Dockefile is created on top of Ubuntu 18.04 image.

Corda is actively supported on Oracle JDK 8, so in Dockerfile we setup the latest Oracle JDK 8.
This is the minimal required software required to build and run Corda apps.

Besides Oracle JDK we also install git. It will be helpful on dev environment.

# docker-compose.yml

The docker-compose.yml file contains a single service: `builder`.

We share all Corda sources from our local environment with Docker container. There is volume with mapping shared sources to `/app` folder:

```yaml
    volumes:
      - .:/app:Z
```

In the root of mounted volume we should have the `gradlew` script file.
Because we can run docker-compose from Windows environment, we need to make sure that `gradlew` script is executable, so we have this command in docker-compose.yml:

```yaml
    command: bash -c "chmod +x gradlew && bash"
```

In docker-compose we expose two ranges of ports:

```yaml
    ports:
      - "7005-7010:7005-7010"
      - "10000-10020:10000-10020"
```

The first range 7005-7010 is used by Jolokia JVM agents. These JVM agents are started automatically when we run a Corda app.

Using the range 10000-10020 we open all possible ports which are used by Corda apps in samples.
Single Corda node may use multiple ports (for RPC messaging, P2P messaging, H2 database). And for single sample we may start 3-4 Corda nodes. So the ports range is so big.

# Deploying Docker container

Place Dockerfile, docker-compose.yml and .dockerignore files inside project root folder.

To build the docker image execute:

```
docker-compose build
```

To run the docker container execute:

```
docker-compose up -d
```

To connect to docker container execute:

```
docker-compose exec builder bash
```

# Building

To build all Corda sources including tools and samples (without tests running):

```
./gradlew build -x test
```

To build Corda core and webserver jars only (without tests running):

```
./gradlew node:capsule:build webserver:webcapsule:build -x test
```

# Running bank-of-corda sample

There are instructions taken from README.md file of bank-of-corda sample app:

1. Run ``./gradlew samples:bank-of-corda-demo:deployNodes`` to create a set of configs and installs under
   ``samples/bank-of-corda-demo/build/nodes``
2. Run ``./samples/bank-of-corda-demo/build/nodes/runnodes`` to open up three new terminal tabs/windows with the three
   nodes
3. Run ``./gradlew samples:bank-of-corda-demo:runRPCCashIssue`` to trigger a cash issuance request
4. Run ``./gradlew samples:bank-of-corda-demo:runWebCashIssue`` to trigger another cash issuance request.
   Now look at your terminal tab/window to see the output of the demo

There are two Corda webserver apps running on ports 10007 and 10010, you can open it in you browser to make sure that app is running.