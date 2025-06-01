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

Mount to share files with the container 
```
docker run -it -v $PWD/source:/my_source_code my_image
```