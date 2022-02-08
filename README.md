# learn-docker
Informacje dotyczące podstaw dockera i docker-compose

Dokumentacja: https://docs.docker.com/reference/
Kurs na Youtube - [Programator](https://youtube.com/playlist?list=PLkcy-k498-V5AmftzfqinpMF2LFqSHK5n)
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
docker stop <container> // lub nazwa kontenera

# uruchomienie działającego kontenera
docker start <container>


# uruchomienie kontenera z obrazu 'ubuntu'
docker run -it ubuntu bash // -it = interactive + tty

# uruchomienie komendy w działającym kontenerze
docker exec <container> ls -l

# uruchomienie basha w działającym kontenerze
docker exec -it <container> bash

# kopiowanie plików z hosta do kontenera
# Uwaga, przy kopiowaniu nie trzeba uruchamiać kontenera!!
docker cp <file> <container>:/

# kopiowanie plików z hosta do kontenera
# Uwaga, przy kopiowaniu nie trzeba uruchamiać kontenera!!
docker cp <container>:<file> .

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
# Uwaga, powoduje to nadpisanie oryginalnego entrypointa (lub cmd) z obrazu!
docker run -it --entrypoint bash ubuntu
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

#### Wolumeny
Wolumeny zarządzane przez dockera

Wolumeny żyją niezależnie od kontenera.

Docker zarządza lokalizacją wolumenów.
```
# wyświetlenie wolumentów wirtualnych dockera
docker volume ls

# utworzenie
docker volume create my1

# usuwanie
docker volume rm my1

# podłączenie wolumenu 'my-vol1'(jeżeli nie istnieje - zostaje utworzony), po ":" podajemy folder, gdzie zostanie podłączony
docker run --volume <my-vol1>:/app <my-img1>

# istnieją rózwnież volumeny aninimowe, żeby do utworzyć nie podajemy jego nazwy, np.:
docker run --volume /app <my-img1>
# wówczas tworzy się volumen z losową nazwą


```
#### Wolumeny bind
Możemy zamiast wolumentu jako pliku podpiąć katalog, należy wówczas podać **ścieżkę bezględną**.





#### budowanie obrazu
- minimalistyczne: `docker build .`
- z podaniem nazwy obrazu: `docker build -t <nazwa-obrazu> .`
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
