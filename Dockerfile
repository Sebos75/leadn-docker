# obraz wzorcowy
FROM ubuntu:20.04

# ustawienie strefy
ENV TZ=Europe/Warsaw

# wylaczenie pytan
ENV DEBIAN_FRONTEND=noninteractive

# wazne, aby zminimalizowac liczbe linii "RUN",
# - kazda tworzy osobna warstwe
RUN apt update && apt install vim -y \
    && apt install mc -y \
    && apt install telnet -y

# kopiowanie pliki z hosta do dockera
COPY README.md .
