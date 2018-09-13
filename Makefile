DOCKER_IMAGE="yolocat:latest"

dev:
	FLASK_ENV=development FLASK_APP=app/index.py venv/bin/flask run --debugger

flake8:
	flake8 app

pylint:
	pylint app

black:
	black -l 79 --check app

lint: flake8 black pylint

docker-build:
	docker build -t $(DOCKER_IMAGE) .

docker-run:
	docker run --rm -p 8080:8080 -v $(PWD)/.env:/app/.env:ro $(DOCKER_IMAGE)
