
build: 
	docker build -t my_image .

# run: 
# 	docker run --rm -it \
# 	  --user ros \
# 	  --network host \
# 	  --ipc host \
# 	  -e DISPLAY=$(DISPLAY) \
# 	  -e QT_X11_NO_MITSHM=1 \
# 	  -v $(PWD)/source:/my_source_code \
# 	  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
# 	  my_image

run:               ## Launch RViz from the container
	./scripts/run_rviz.sh

run-fix: 
	xhost +si:localuser:ros
	docker run --rm -it \
		--env DISPLAY=$DISPLAY \
		--env QT_X11_NO_MITSHM=1 \
		-v /tmp/.X11-unix:/tmp/.X11-unix:rw \
		--device /dev/dri \
		my_image bash -c "rviz2"

run-inline:
	@docker run --rm -it \
	    -e DISPLAY=$$DISPLAY \
	    -e QT_X11_NO_MITSHM=1 \
	    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
	    my_image rviz2