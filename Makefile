SHELL := /bin/bash

dev:
	FLASK_ENV=development FLASK_APP=app/index.py venv/bin/flask run --debugger

flake8:
	flake8 app

pylint:
	pylint app

black:
	black -l 79 --check app

lint: flake8 black pylint
