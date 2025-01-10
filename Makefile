.PHONY: install_requirements docker_up npm_start run_tests

install_requirements:
	@echo "Installing Python dependencies..."
	pip install -r requirements.txt

docker_up:
	@echo "Running docker-compose up..."
	cd script && docker-compose up -d && cd ..

npm_start:
	@echo "Installing npm dependencies and starting the app..."
	cd sample-app && npm i && npm run start:dev && cd ..

run_tests:
	@echo "Running robot tests..."
	robot tests

all: install_requirements docker_up npm_start run_tests
