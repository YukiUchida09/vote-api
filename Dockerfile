FROM image-registry.openshift-image-registry.svc:5000/openshift/golang:1.12.4-alpine3.9 as builder

WORKDIR /build
ADD . /build/

ENV PATH $PATH:/usr/local/go/bin

RUN export GARCH="$(uname -m)" && if [[ ${GARCH} == "x86_64" ]]; then export GARCH="amd64"; fi && GOOS=linux GOARCH=${GARCH} CGO_ENABLED=0 go build -mod=vendor -o api-server .

FROM scratch

WORKDIR /app
COPY --from=builder /build/api-server /app/api-server

CMD [ "/app/api-server" ]
