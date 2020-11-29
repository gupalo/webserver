NAME = gupalo/webserver

.PHONY: all build release run

all: build run

build:
	docker build -t $(NAME) --rm --pull .

release:
	docker push $(NAME):latest

run:
	docker-compose up -d
