FROM golang:1.22 AS build
WORKDIR /src

COPY go.mod go.sum ./
RUN go env -w GO111MODULE=on
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /out/app ./...


FROM scratch
WORKDIR /app


COPY --from=build /out/app /app/app
COPY tracker.db /app/tracker.db

ENTRYPOINT ["/app/app"]
