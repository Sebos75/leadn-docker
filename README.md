# learn-docker
Informacje dotyczące podstaw dockera i docker-compose

Dokumentacja: https://docs.docker.com/reference/
Kurs na Youtube - [Programator](https://youtube.com/playlist?list=PLkcy-k498-V5AmftzfqinpMF2LFqSHK5n)


Artykuł po polsku z Microsoftu: https://docs.microsoft.com/pl-pl/visualstudio/docker/tutorials/docker-tutorial

Tricki z Infoshare: https://gist.github.com/lukaszlach/f205b2a2d3aba27ea9a3bed104f17307
## Informacje ogólne

Docker to platforma do uruchamiana aplikacji z kontenerami, Docker jest jedną z implementacji kontenerów (nie jedyną).

### Definicje
**image** (obraz) - jest pakietem zawierającym kod, biblioteki, pliki konfiguracyjne i zmienne środowiskowe.
```
# wylistowanie dostępnych obrazów
docker image ls // lub krócej: 'docker images'
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
2. Klient łączy się z deamonem (dostęp do demona możliwy jest przez REST api, nawet z innego hosta).
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
# (chyba, że dodamy flagę '--rm')
docker run -p 8002:80 -d httpd

# uruchomienie kontenera z nadaniem nazwy 'my-apache' (bez = nadawana jest automatycznie)
docker run --name my-apache -p 8002:80 -d httpd

# zatrzymanie działającego kontenera (wystarczy podać pierwsze znaki container_id)
docker stop <container> // lub nazwa kontenera

# uruchomienie istniejącego kontenera
docker start <container>


# uruchomienie kontenera z obrazu 'ubuntu'
# (bez podania "-it" kontener wyłączy się zaraz po uruchomieniu)
docker run -it ubuntu // -it = interactive + tty

# flaga '--rm', powoduje, że kontener zostastanie usunięty po zakończeniu pracy
# opcja użyteczna podczas testowania kontenerów
docker run --rm -it ubuntu

# uruchomienie komendy w działającym kontenerze
docker exec <container> ls -l

# uruchomienie basha w działającym kontenerze
docker exec -it <container> bash

# podłączenie się pod działający kontener
docker attach <container>

# odłączenie się od kontenera, bez zamykania:
# CTRL + p, p

# kopiowanie plików z hosta do kontenera
# Uwaga, przy kopiowaniu nie trzeba uruchamiać kontenera!!
docker cp <file> <container>:/

# kopiowanie plików z kontenera do hosta
# Uwaga, przy kopiowaniu nie trzeba uruchamiać kontenera!!
docker cp <container>:<file> .

```
### komendy dodatkowe
```
# informacja o stanie dockera (liczba kontenerów, obrazów, cpu, mem, lokalizacji danych)
docker info

# informacja szczegółowa o kontenerze
docker inspect <container>

# sprawdzenie wersji jądra linuksa
docker run ubuntu uname -a

# informacja o warstwach obrazu
docker history ubuntu

# obrazy nie posiadające "entrypoint" wyłaczają się od razu po uruchomieniu
# (np. ubuntu) w takim przypadku można dodać parametr 'entrypoint' nadpisujący
# Uwaga, powoduje to nadpisanie oryginalnego entrypointa (lub cmd) z obrazu!
docker run -it --entrypoint bash ubuntu

# inne użycie (uruchamia komendę 'cat' z podanym argumentem )
docker run --rm --entrypoint cat ubuntu /etc/hosts


# wyświetlenie zmiennych środowiskowych za pomocą komendy `env`
docker run ubuntu env

# dodanie zmiennej środowiskowej 'db=elastic'
docker run -e db=elastic ubuntu env

# wyświeltenie ostatnich logów kontenera
docker logs <container>


# wylistowanie tylko identyfikatorów dockerów
docker ps -q

# operacja na wielu kontenerach, z użyciem "$()"
docker inspect $(docker ps -q)

```

### Dockerfile

Plik `Dockerfile` służy do tworzenia przepisu budowy obrazu na podstawie innego, istniejącego obrazu.

Jeżeli użyjemy wywałania `docker run <image-name> bash`, czyli podamy na końcu jakąś komendę,
to w takim przypadku nadpisujemy komendę `CMD` lub `ENTRYPOINT` zapisany w `Dockerfile` - nie zostanie on wykonany.

Komenda `ENTRYPOINT` umieszczona w `Dockerfile`, w odróżnieniu od `CMD`, pozwala na przekazanie parametrów podczas uruchamiania obrazu, np.
`docker run <my-image> arg1`
- w takim przypadku do komendy umieszczonej w `ENTRYPOINT` zostanie przekazany argunet `arg1`

Jednoczesne umieszczenie  `CMD` i `ENTRYPOINT`, powoduję, że `ENTRYPOINT` użyje wartości z tablicy `CMD` jako domyślnego argumentu (działa tylko dla formy "exec" - tablicowej).

Komenda `docker run --entrypoint <my-cmd>` pozwala na nadpisanie ENTRYPOINTA podczas wywołania.

Przykładowy plik `Dockerfile` z komentarzami znajduje się w bieżącym katalogu.

Mechanizm **multi stage build** polega na tworzenia tymczasowego obrazu, wykorzystywanego następnie w obrazie docelowym. Definicja odbywa się w pliku `Dockerfile` za pomocą klauzuli `AS` w komendzie `FROM`.
Głównym powodem stosowanie tej techniki jest znaczne zmniejszenie wynikowego obrazu.
Przykładem może być kompilacja projektu angulara do plików wynikowych (`js`), następnie udostępnienie w finalnym obrazie za pomocą `nginx` tylko statycznych plików wynikowych (bez kodu źródłowego).
#### Wolumeny
Wolumeny zarządzane przez dockera i żyją niezależnie od kontenera.

Docker zarządza lokalizacją wolumenów.

wyświetlenie wolumentów wirtualnych dockera
`docker volume ls`

utworzenie
`docker volume create my1`

usuwanie
`docker volume rm my1`

podłączenie wolumenu 'my-vol1' (jeżeli nie istnieje - zostaje utworzony), po ":" podajemy folder, gdzie zostanie podłączony
`docker run --volume <my-vol1>:/app <my-img1>`

istnieją rózwnież volumeny anonimowe, żeby go utworzyć nie podajemy jego nazwy, np.:
`docker run --volume /app <my-img1>`
wówczas tworzy się volumen z losową nazwą


#### Wolumeny bind
Możemy zamiast wolumentu jako pliku podpiąć katalog, należy wówczas podać **ścieżkę bezględną**.




### network

Wyświetlenie dostępnych sieci

`docker network ls`

Docker tworzy domyślnie sieć `bridge` o typie bridge, sieć `bridge`
pozwala na łączenie kontenerów między sobą oraz zapewnia dostęp do internetu za pomocą komputera hosta.
Każdy nowy kontener jest domyślnie podłączany pod sieć `bridge`.

Domyślna sieć `bridge` zapewnia połączenia pomiędzy kontenerami wyłącznie za pomocą adresów IP, ale nie za pomocą nazw.

Wyświetlenie informacji o sieci:
```
docker network inspect bridge
```

Tworzenie nowej sieci
```
docker network create <nazwa-sieci>
```

Podłączenie kontenera do sieci (musi istnieć jedno i drugie)
```
docker network connect <nazwa-sieci> <container>
```

Odłączenie od sieci
```
docker network disconnect <nazwa-sieci> <container>
```


Jeżeli dwa kontenery będą podłączone do określonej (nie domyślnej sieci bridge),
to widzą się na wzajem poprzez nazwę kontenera.
Widać to za pomocą komendy `network insepect <nazwa sieci>`

Sieci własne możemy dowolnie podłączać i odłączać w czasie pracy kontenerów również od sieci domyślnej `bridge`.

Jeżeli podczas tworzenia kontenera podamy sieć przez flagę `--network`, to tworzyny kontener
będzie podłączony tylko do tej sieci (nie zostanie podłączony do domyślnej sieci `bridge`).

#### budowanie obrazu
- minimalistyczne: `docker build .`
- z podaniem tagu (nazwy obrazu): `docker build -t <nazwa-obrazu> .`
- z podaniem kontekstu*: `docker build -t <nazwa-obrazu> ./src`
- z inną lokalizacją pliku i kontekstu:
    `docker build -t <nazwa-obrazu> -f Dockerfile  ./src`

*Kontekst oznacza folder, który wraz z pod-folderami zostanie wysłany do damona dockera. Tylko do tych plików można się odwołać w pliku 'Dockerfile' (np. przez COPY). Kontekst jest jednocześnie bieżącym folderem dla poleceń typu COPY.
#### utrwalanie kontenerów
```
# stworzenie obrazu na podstawie istniejącego kontenera
docker commit _container_ _new_image_name_

# zmiana nazwy obrazu (kopiowanie)
docker tag <old_image_name> <new_name>
docker tag <old_image_name> <new_name:latest>  // z podaniem taga

# zapis obrazu do pliku
docker save <image_name> > <file-name.tar>

# odczyt obrazu z pliku
docker load < <file-name.tar>
```


### przesyłanie obrazu do docker huba

```
# logowanie
docker login -u <user_name>

# zmiana nazwy (kopiowanie) obrazu (musi prefiks musi być zgodny z nazwą użytkownika)
docker tag <old_image_name> <user/new_name:latest>  // z podaniem taga

# wysłanie obrazu do docker huba
docker push <user/my-image>

```

### zalecenia dotyczące optymalizacji
- W pliku `Dockerfile` używać jak najmniej osobnych linii COPY  (tworzyć jedną łączoną przez `&&`) - każda linia, podczas budowy obrazu tworzy tymczasową warstwę (obraz).
- Do kontektu przekazywać tylko niezbędne katalogi (nie podawać katalogu głównego gdzie znajduje się wiele plików, np. pliku z folderu .git). Ponieważ wszystkie pliki z kontektu muszą byćp rzesłane do demona Dockera. Informacja o wielkości dostępna jest w pierwszej linii budowania dockera: `Sending build context to Docker daemon xxx`


## docker-compose
**Docker-compose** konfiguracji uruchomienia jednego lub wielu obrazów ze sobą. Zastępuje "ręczne" uruchamianie obrazu (tworzenie kontenera) z podawania parametrów. Upraszcza uruchomienie i zatrzymanie kompletu obrazów, wprowadza zależności pomiędzy nimi.
Definicja pliku, (zgodnie z yaml) odbywa się na zasadzie kluczy i wartości.

Konfiguracja znajduje się domyślnie w pliku `docker-compse.yml`, przykładowy pliku znajduje się w bieżącym katalogu.

Jeżeli w pliku nie dodamy nazwy kontenera (`container_name`), wówczas kontener będzie się nazwał wg wzorca:
`<nazwa-katalogu>_<nazwa-serwisu>_1`
### Podstawowe komendy

Pobranie/budowanie obrazów oraz stworzenie i uruchomienie konenerów,
flaga `-d`, oznacza uruchomienie w tle:
`docker-compose up -d`

Uwaga, uruchomienie bez flagi `-d` i wciśnięcie `CTRL-C` **nie usuwa kontenerów**, tylko je zatrzymuje!


Zatrzymanie kontenerów (**Uwaga!!** usuwa kontenery!! ):
`docker-compose down`

Bezpieczne zatrzymanie kontenerów (bez usuwania):
`docker-compose stop`

Uruchomienie kontenerów:
`docker-compose start`

Uruchomienie z buildem obrazów (jeżeli takie były w definicji):
`docker-compose up -d --build`

Wyświetlenie logów (wszystkich kontenerów):
`docker-compose logs`


Zmiana ustawień sieciowych wymaga przebudowy kontenerów, czyli wykonania `down/up`

Dowolny usługę (kontener) mozna włączyć/wyłączyć używając komendy:
`docker-compose start|stop <nazwa-uslugi>`

## Konfiguracja

Format wynikowy komendy `docker ps` można kongigutować w pliku `~/.docker/config.json`, dopisując linię
```
{
  "psFormat": "table {{.ID}}\\t{{.Image}}\\t{{.Status}}\\t{{.Names}}"
}
```
źródło: https://devdojo.com/bobbyiliev/how-to-change-the-docker-ps-output-format


Wyłączanie usługi dockera:
```
sudo systemctl stop docker
sudo systemctl stop docker.socket
```
