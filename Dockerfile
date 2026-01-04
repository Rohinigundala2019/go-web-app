# Containerize the go application that we have created
# This is the Dockerfile that we will use to build the image
# and run the container

#start with base image

FROM golang:1.22.5 as base

#set up the working directory

WORKDIR /app

#copy the go.mod file to working directory

COPY go.mod ./

#download the dependencies

RUN go mod download

#copy the source code to working directory

COPY . .

#build the application

RUN go build -o main .


####################################

# Reduce the image size using multi-stage builds
# We will use a distroless image to run the application

FROM gcr.io/distroless/base

# Copy the binary from the previous stage

COPY --from=base /app/main .	

COPY --from=base /app/static ./static

# Expose the port on which the application will run
EXPOSE 8080

# Command to run the application
CMD ["./main"]
