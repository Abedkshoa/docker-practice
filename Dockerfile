- Create Dockerfile for multi-stage build (2-step based on Alpine)
# Stage 1: Build cmatrix in a build container
FROM alpine as builder

RUN apk add --no-cache git build-base ncurses-dev

# Clone the cmatrix repo
RUN git clone https://github.com/abishekvashok/cmatrix.git /cmatrix

# Build the project
WORKDIR /cmatrix
RUN ./configure && make

# Stage 2: Final container
FROM alpine

# Only install runtime dependency
RUN apk add --no-cache ncurses

# Copy binary from builder stage
COPY --from=builder /cmatrix/cmatrix /usr/local/bin/cmatrix

# Run cmatrix by default
ENTRYPOINT ["cmatrix"]

 - Build the container
docker build -t cmatrix-alpine .

- Check the image size
docker image ls cmatrix-alpine

-Run the binary
docker run --rm -it cmatrix-alpine

