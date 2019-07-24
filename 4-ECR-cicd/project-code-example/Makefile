image_name=my-container
image_tag=latest
all: build run


build:
	@docker build -t $(image_name):$(image_tag) .

run:
	@docker run -it --rm $(image_name):$(image_tag)
push:
	@docker push $(image_name):$(image_tag)
tag_latest:
	@docker tag $(image_name):$(image_tag) $(image_name):latest
push_latest:
	@docker push $(image_name):latest
