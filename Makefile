
build: 
	docker build -t my_image .

run: 
	docker run -it --user ros -v $$PWD/source:/my_source_code my_image