# learn-docker
Informacje dotyczące podstaw dockera i docker-compose

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

### przydatne komendy

```
# lista komend
docker --help

# pomoc dotyczące pojedyńczej komendy, np. komendy 'run'
docker run --help


# pobranie obrazu 'hello-world' z docker-huba
docker pull hello-world

# informacja o stanie dockera (liczba kontenerów, obrazów, cpu, mem, lokalizacji danych)
docker info

# uruchomienie servera apache na porcie hosta 8002 (http://localhost:8002)
# opcja `-p` mapuje nr portu zewnętrznego (hosta) do wewnętrznego (kontenera)
# opcja `-d` powoduje, że operacja wykona się w tle - zwolni shell'a
docker run -p 8002:80 -d httpd

# zatrzymanie działającego kontenera (wystarczy podać pierwsze znaki container_id)
docker stop _container_id_

# uruchomienie działającego kontenera
docker start _container_id_


# uruchomienie kontenera z obrazu 'ubuntu'
docker run -it ubuntu bash // -it = interactive + terminal




```
