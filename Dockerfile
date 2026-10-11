# Build stage
FROM golang:1.26 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 go build -o /kube-state-metrics .

# Runtime stage
FROM gcr.io/distroless/static-debian13:nonroot

COPY --from=builder /kube-state-metrics /kube-state-metrics

EXPOSE 8080 8081

ENTRYPOINT ["/kube-state-metrics", "--port=8080", "--telemetry-port=8081"]
