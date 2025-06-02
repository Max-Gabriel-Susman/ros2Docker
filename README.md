# ros2Docker

This repository stores an use case agnostic ROS 2 Docker implementation for reference in other projects.

## Commands

Build a docker image: 
```
docker build -t my_image .
```

View new image: 
```
docker images
```

Mount to share files with the container:
```
docker run -it -v $PWD/source:/my_source_code my_image
```

Mount to share files with the container for a specific user:
```
docker run -it --user ros -v $PWD/source:/my_source_code my_image
```

Use host network:
```
docker run -it --user ros --network=host --ipc=host -v $PWD/source:/my_source_code my_image
```

Grant X Windows Permission: 
```
xhost +
```

Use X Windows to facillitate Graphics:
```
docker run -it --user ros --network=host --ipc=host -v $PWD/source:/my_source_code -v /tmp/.X11-unix:/tmp/.X11-unix:rw --env=DISPLAY my_image
```