This dockerfile is a test right now. After build it is ridiculously big.

Build:  
```
docker build -t atom .
```

Run:  
```
docker run --rm -it \
  -v /dev/shm:/dev/shm \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /home/user-name/your-work-dir/:/docker-work-dir \
  -e DISPLAY=$DISPLAY \
  atom
