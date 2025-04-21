# Build image

docker build -t cups:latest .

# Run container

## Foreground
```
docker run --privileged --cap-add=NET_ADMIN -it --env-file env-file -p 1025:631 -v /opt/docker/volumes/cups:/etc/cups cups:latest
```
## Background
```
docker run -d --privileged --cap-add=NET_ADMIN -it --env-file env-file -p 1025:631 -v /opt/docker/volumes/cups:/etc/cups cups:latest
```
## Connect to running container by IMAGE name
```docker exec -it $(docker ps -qf "ancestor=cups:latest") bash```

## Check running docker containers
```
docker ps
docker stats
```

# Portainer container setup

## 1. Build image
- Pull latest changes:
```sh
git pull
```
- Build image from github repo:
```sh
cd cups
docker build -t cups:latest .
```

## 2. Setup container
- Name: CUPS
- Image: cups:latest
- Volumes:
  - /etc/cups
- Network
  - setup network as you wish
- Env:
  - TZ=UTC
  - CUPSADMIN=admin
  - CUPSPASSWORD=
- Runtime & resources
  - Privileged mode = OFF
  - Devices:
    - /dev/usb
    - /dev/bus/usb
  - Resources:
    - Memory reservation = 256MB
    - Memory limit = 1024MB
    - Max CPU usage = 1.0
- Capabilities
  - keep default


# Automatically Restarting CUPS on USB Printer Connection in Docker  

On your host machine which running Docker with USB Printer, follow these steps:  

## 1. Add the UDEV Rule  
Copy the `99-usb-printer-cups-restart.rules` file to the `/etc/udev/rules.d/` directory:  
```sh
    sudo cp 99-usb-printer-cups-restart.rules /etc/udev/rules.d/
```
## 2. Update UDEV Rules
Run the following commands to apply the changes:
```sh
    sudo udevadm control --reload-rules
    sudo udevadm trigger
```

These steps ensure that when a USB printer is connected, the CUPS service automatically restarts, 
allowing the device to be correctly recognized in Docker containers.
