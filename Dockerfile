# Use a minimal base image
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Copy go modules for faster dependency fetching
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the rest of the application code
COPY . .

# Build the application
RUN go build -o main -ldflags="-s -w"

# Create a minimal runtime image
FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/main .

# Expose the port
EXPOSE 8080

# Command to run the application
CMD ["./main"]
