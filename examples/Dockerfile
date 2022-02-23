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


# polecenie WORKDIR tworzy katalog (jeżeli nie istnieje)
# oraz ustawia się w tym katalogu
WORKDIR /app


# kopiowanie pliku z hosta do dockera (katalogu '/'')
# można podać wiele plików do skopiowania oraz używać '*'
# W pliku '.dockerignore' można umieścić nazwy plików i katalogów do zignorowania
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

# instrukcja CMD pozwala na wykonywanie instrukcji wewnątrz kontenera
# można umieścić tylko jedną instrukcję,
# Istnieje dwie formy CMD: shellowa oraz exec

# forma shellowa:
# CMD echo 'Current directory: ' && pwd
# CMD - forma shellowa CMD skladająca się z kilku poleceń:
# CMD echo 'Current directory: ' && pwd

# forma exec - komenda z listą argumentów,
# nie działają potoki itp., służy do uruchomienia pojedyńczego programu
# CMD [ "ls", "/etc","-lS" ]
# jest to odpowienik: 'ls /etc -lS'


# instrukcja ENTRYPOINT działa analogicznie do CMD, z tą różnicą,
# że pomożna do niej z zewnątrz przekazać argumenty
# (podczas instancji uruchomiania kontenera)
# ENTRYPOINT [ "ls", "/etc","-lS" ]

