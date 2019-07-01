## Atom in Docker

Atom editor build from scratch as a docker image

### Synopsis

To have the same editor with the same plugins everywhere.

### Size

This dockerfile is a test right now. After build it is ridiculously big.

### Build

In order to build this image, run:

```
docker build -t atom .
```

### Run

In order to run this image with mounted local working directory, execute:

```
docker run --rm -it \
  -v /dev/shm:/dev/shm \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /home/user-name/your-work-dir/:/docker-work-dir \
  -e DISPLAY=$DISPLAY \
  atom
```
