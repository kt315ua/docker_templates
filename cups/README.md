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
