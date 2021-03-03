#FROM image-registry.openshift-image-registry.svc:5000/openshift/golang:latest as builder
#FROM registry.access.redhat.com/ubi8/go-toolset:1.14.12 as builder
FROM golang:alpine as builder

#RUN echo $PATH
#RUN echo $GOPATH
#RUN wget https://dl.google.com/go/go1.13.5.linux-amd64.tar.gz
#RUN tar -C /usr/local -xzf go1.13.5.linux-amd64.tar.gz
#ENV PATH $PATH:/usr/local/go/bin
#RUN go version
#RUN echo $PATH
#RUN echo $HOME
#RUN ls -l /usr/local
#RUN ls -l /opt/app-root/src
#RUN go version

WORKDIR /build
ADD . /build/

RUN export GARCH="$(uname -m)" && if [[ ${GARCH} == "x86_64" ]]; then export GARCH="amd64"; fi && GOOS=linux GOARCH=${GARCH} CGO_ENABLED=0 go build -mod=vendor -o api-server .

FROM scratch

WORKDIR /app
COPY --from=builder /build/api-server /app/api-server

CMD [ "/app/api-server" ]
