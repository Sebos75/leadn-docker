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

# kopiowanie pliku z hosta do dockera (katalogu '/'')
# można podać wiele plików do skopiowania oraz używać '*'
COPY README.md .

# kopiowanie do katalogu '/nowy/' - jezeli brak - zostanie utworzony!
# na końcu katalogu koniecznie podać '/'!
COPY README.md /nowy/

# kopiowanie katalogu 'src' hosta, do obrazu: '/var/www'
# na końcu katalogu koniecznie podać '/'!
COPY src /var/www/


# polecenie ADD działa podobnie do COPY,
# pozwala jednak sciagnąc plik z internetu i go wgrać do obrazu
# ADD http://url/plik.html .

# drugie zastosowanie ADD, to rozpakowanie pliku i wrzucenie do obrazu
# ADD plik.tar.gz .