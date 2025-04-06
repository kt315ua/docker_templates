# Build image

docker build -t testing:latest .

# Run container

## Foreground
```
docker run -it -p 8080:8080 -p 1935:1935 --device /dev/dri -v /opt/docker/volumes/owncast:/app/data testing:latest
```
## Background
```
docker run -d -it -p 8080:8080 -p 1935:1935 --device /dev/dri -v /opt/docker/volumes/owncast:/app/data testing:latest
```
## Connect to running container by IMAGE name
```docker exec -it $(docker ps -qf "ancestor=testing:latest") bash```

## Check running docker containers
```
docker ps
docker stats
```

