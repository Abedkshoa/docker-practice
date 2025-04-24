# 🐳 Docker Practice Exercises

This repo includes 3 simple Docker practices to help you understand containers, networks, volumes, and image optimization.

---

## 1️⃣ Practice: Networks & Containers

**What you'll do:**
- Create a custom Docker network (`vaio-net`)
- Run `alpine`, `nginx`, and `ubuntu/apache2` containers
- Test communication between them
- Connect a running container to a new network
- Clean up all containers, images, and networks

**Commands to try:**
```bash
docker network create vaio-net
docker run -dit --name alpine-box --network vaio-net alpine
docker run -dit --name nginx-box --network vaio-net nginx
docker run -dit --name apache-box ubuntu bash
docker network connect vaio-net apache-box
docker exec alpine-box ping apache-box
```

---

## 2️⃣ Practice: MySQL Data Persistence with Volumes

**What you'll do:**
- Create a Docker volume (`mysql-data`)
- Run a MySQL container using that volume
- Remove the container and run a new one using the same volume
- Check that the data still exists

**Commands to try:**
```bash
docker volume create mysql-data
docker run -d --name mysql-box -e MYSQL_ROOT_PASSWORD=rootpass -v mysql-data:/var/lib/mysql mysql
docker stop mysql-box && docker rm mysql-box
docker run -d --name mysql-new -e MYSQL_ROOT_PASSWORD=rootpass -v mysql-data:/var/lib/mysql mysql
docker exec -it mysql-new mysql -uroot -prootpass -e "SHOW DATABASES;"
```

---

## 3️⃣ Practice: Build a Small Image for cmatrix

**What you'll do:**
- Use Alpine to build the `cmatrix` app from source
- Use a multi-stage build to keep the final image small
- Run `cmatrix` in a container

**Dockerfile example:**
```Dockerfile
FROM alpine as builder
RUN apk add --no-cache git build-base ncurses-dev
RUN git clone https://github.com/abishekvashok/cmatrix.git /cmatrix
WORKDIR /cmatrix
RUN ./configure && make

FROM alpine
RUN apk add --no-cache ncurses
COPY --from=builder /cmatrix/cmatrix /usr/local/bin/cmatrix
ENTRYPOINT ["cmatrix"]
```

**Build and run:**
```bash
docker build -t cmatrix-alpine .
docker run --rm -it cmatrix-alpine
```

---

## 🧹 Cleanup (optional)
```bash
docker container stop $(docker ps -aq)
docker container rm $(docker ps -aq)
docker image rm -f $(docker images -aq)
docker volume rm mysql-data
docker network rm vaio-net
```

---

Happy Dockering! 🚢