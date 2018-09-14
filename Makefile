DOCKER_IMAGE=yolocat:latest
OC=oc-3.10
OPENSHIFT_DOCKER_REGISTRY=$(shell $(OC) registry info)
OPENSHIFT_PROJECT=yolo-apps
OPENSHIFT_DOCKER_IMAGE=$(OPENSHIFT_DOCKER_REGISTRY)/$(OPENSHIFT_PROJECT)/$(DOCKER_IMAGE)

dev:
	FLASK_ENV=development FLASK_APP=yolo/index.py venv/bin/flask run --debugger

flake8:
	flake8 yolo

pylint:
	pylint yolo

black:
	black -l 79 --check yolo

lint: flake8 black pylint

docker-build:
	docker build -t $(DOCKER_IMAGE) -t $(OPENSHIFT_DOCKER_IMAGE) .

docker-run:
	docker run --rm -p 8080:8080 -v $(PWD)/.env:/app/.env:ro $(DOCKER_IMAGE)

docker-push: docker-build
	docker login -u developer -p $(shell $(OC) whoami -t) $(OPENSHIFT_DOCKER_REGISTRY);
	docker push $(OPENSHIFT_DOCKER_IMAGE);
