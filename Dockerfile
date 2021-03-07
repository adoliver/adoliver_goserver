FROM golang:alpine

#Set environment variables needed for this image
ENV 	GO111MODULE=on \
	CGO_ENABLED=0 \
	GOOS=linux \
	GOARCH=amd64

WORKDIR /build

# Retrieve dependencies using go mod
COPY go.mod .
COPY go.sum .
RUN go mod download

#Copy the code into the container
COPY . .

#Build the application
RUN go build -o main .

#Move to the binary folder destination
WORKDIR /dist

#copy the binary into the destination
RUN cp /build/main .

# build a small image
FROM scratch

COPY --from=builder /dist/main /

# Command to run
ENTRYPOINT ["main"]
