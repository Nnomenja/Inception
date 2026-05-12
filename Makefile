HOST_DATA_DIR := $(HOME)/data
HOST_MARIADB_DATA := $(HOST_DATA_DIR)/mysql
HOST_WORDPRESS_DATA := $(HOST_DATA_DIR)/wordpress

all : build

make build:
	mkdir -p "$(HOST_MARIADB_DATA)"
	mkdir -p "$(HOST_WORDPRESS_DATA)"
	sudo docker compose -f ./srcs/docker-compose.yml build

make up:
	mkdir -p "$(HOST_MARIADB_DATA)"
	mkdir -p "$(HOST_WORDPRESS_DATA)"
	sudo docker compose -f ./srcs/docker-compose.yml up -d

make down:
	sudo docker compose -f ./srcs/docker-compose.yml down

make clean:
	sudo docker compose -f ./srcs/docker-compose.yml down -v --rmi all
	sudo rm -rf "$(HOST_MARIADB_DATA)/*"
	sudo rm -rf "$(HOST_WORDPRESS_DATA)/*"

make fclean: clean
	sudo rm -rf "$(HOST_DATA_DIR)"
	sudo docker system prune -a --volumes -f

make re: fclean all