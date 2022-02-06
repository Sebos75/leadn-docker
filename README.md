# learn-docker
Informacje dotyczące podstaw dockera i docker-compose

Dokumentacja: https://docs.docker.com/reference/

## Informacje ogólne

Docker to platforma do uruchamiana aplikacji z kontenerami, Docker jest jedną z implementacji kontenerów (nie jedyną).

### Definicje
**image** (obraz) - jest pakietem zawierającym kod, biblioteki, pliki konfiguracyjne i zmienne środowiskowe.
```
# wylistowanie dosatępnych obrazów
docker image ls // lub krócej: docker images
```

**container** (kontener) - to instacja obrazu, może być uruchomiona z dodatkowymi zmiennymi środowiskowymi. Każdy kontener ma własny identyfikator.
```
# wylistowanie aktywnych (działających) kontenerów
docker ps

# wylistowanie wszystkich kontenerów
docker ps -a
```

**docker hub** - ogólnodostępne repozytorium obrazów dostępne pod adresem https://hub.docker.com/

### Zasada działania Dockera

1. Na serwerze działa deamon `/usr/bin/dockerd`.
2. Klient łączy się z deamonem.
3. Deamon pobiera obraz (w pierwszej kolejności szuka go lokalnie).
4. Docker tworzy kontener z obrazu (instację) i go uruchamia.
5. jeżeli kontener zatrzymany nadal istnieje i można go usunąć.

### podstawowe komendy


```
# lista komend
docker --help

# pomoc dotyczące pojedyńczej komendy, np. komendy 'run'
docker run --help


# pobranie obrazu 'hello-world' z docker-huba
docker pull hello-world

# uruchomienie servera apache na porcie hosta 8002 (http://localhost:8002)
# opcja `-p` mapuje nr portu zewnętrznego (hosta) do wewnętrznego (kontenera)
# opcja `-d` powoduje, że operacja wykona się w tle - zwolni shell'a
# Uwaga, operacja 'run' za każdym razem tworzy nowy kontener!
docker run -p 8002:80 -d httpd

# uruchomienie kontenera z nadaniem nazwy 'my-apache' (bez = nadawana jest automatycznie)
docker run --name my-apache -p 8002:80 -d httpd

# zatrzymanie działającego kontenera (wystarczy podać pierwsze znaki container_id)
docker stop _container_id_ // lub nazwa kontenera

# uruchomienie działającego kontenera
docker start _container_id_


# uruchomienie kontenera z obrazu 'ubuntu'
docker run -it ubuntu bash // -it = interactive + tty

# uruchomienie komendy w działającym kontenerze
docker exec _container_id_ ls -l

# uruchomienie basha w działającym kontenerze
docker exec -it _container_id_ bash


```
### komendy dodatkowe
```
# informacja o stanie dockera (liczba kontenerów, obrazów, cpu, mem, lokalizacji danych)
docker info

# sprawdzenie wersji jądra linuksa
docker run ubuntu uname -a

# informacja o warstwach obrazu
docker history ubuntu

# obrazy nie posiadające "entrypoint" wyłaczają się od razu po uruchomieniu
# (np. ubuntu) w takim przypadku można dodać parametr 'entrypoint' nadpisujący
# Uwaga, powoduje to nadpisanie oryginalnego entrypointa z obrazu!
docker run -it --entrypoint bash ubuntu
```
#### utrwalanie kontenerów
```
# stworzenie własnego obrazu na podstawie istniejącego kontenera
docker commit _container_ _new_image_name_

# zapis obrazu do pliku
docker save _image_name_ > _file-name_.tar

# odczyt obrazu z pliku
docker load < _file-name_.tar
```
