# Use an official Golang runtime as a base image
FROM golang:1.17 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Go application source code
COPY . .

# Install SQLc
RUN go get github.com/kyleconroy/sqlc/cmd/sqlc

# Copy the SQLc configuration and queries to the container
COPY ./db/sqlc.yaml /app/db/sqlc.yaml
COPY ./db/queries.sql /app/db/queries.sql

# Generate SQLc code
RUN sqlc generate

# Build the Go application
RUN go build -o main .

# Create a minimal image to run the application
FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/main .

# Expose the port the application runs on
EXPOSE 8080

# Command to run the executable
CMD ["./main"]