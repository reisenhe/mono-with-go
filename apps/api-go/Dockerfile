FROM golang:1.23-alpine

WORKDIR /app

# Configure Go proxy for China mainland
ENV GOPROXY=https://goproxy.cn,direct
ENV GONOSUMCHECK=*

# Install basic tools
RUN apk add --no-cache wget ca-certificates

# Install air binary directly (avoid go install network issues)
RUN wget -O /usr/local/bin/air https://github.com/air-verse/air/releases/download/v1.61.7/air_1.61.7_linux_amd64 && \
    chmod +x /usr/local/bin/air

# Copy go mod files first for better Docker layer cache
COPY go.mod go.sum* ./
RUN go mod download

# Copy source code
COPY . .
RUN chmod +x entrypoint.sh

# Expose port
EXPOSE 8080

# Use entrypoint script for proper signal handling
ENTRYPOINT ["./entrypoint.sh"]
