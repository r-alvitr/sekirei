NAME:=sekirei

build:
	sudo docker build . -t ${NAME}

pbuild:
	sudo docker build . -t ${NAME} --build-arg http_proxy=http://172.20.20.104:8080 --build-arg https_proxy=http://172.20.20.104:8080

run:
	sudo docker run -it --name ${NAME} -p '22:22' ${NAME} /bin/bash

kill:
	sudo docker container prune && sudo docker image prune
