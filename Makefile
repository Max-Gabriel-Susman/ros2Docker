
build: 
	docker build -t my_image .

run: 
	docker run -it --user ros --network=host --ipc=host -v $$PWD/source:/my_source_code my_image ros2 topic list

run-fix:
	docker run --rm -it \
	  --user ros \
	  --network host \
	  --ipc host \
	  -e DISPLAY=$(DISPLAY) \
	  -e QT_X11_NO_MITSHM=1 \
	  -v $(PWD)/source:/my_source_code \
	  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
	  my_image