FROM golang:latest

# Install required packages
RUN apt-get update && apt-get install -y wget git libxkbfile1 libsecret-1-0 libnotify4 libgconf-2-4 libnss3 libgtk2.0-0 libxss1 libgconf-2-4 libasound2 libxtst6 libcanberra-gtk-dev libgl1-mesa-glx libgl1-mesa-dri

# Install visual studio code
RUN wget https://go.microsoft.com/fwlink/?LinkID=760868 -O vscode.deb && \
    dpkg -i vscode.deb; \
    apt-get -f install -y && \
    rm vscode.deb && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m vscode -s /bin/bash
WORKDIR /go/src
USER vscode

RUN code --install-extension ms-vscode.go

# Install Go extensions
RUN go get -u -v github.com/ramya-rao-a/go-outline && \
    go get -u -v github.com/acroca/go-symbols  && \
    go get -u -v github.com/mdempsky/gocode  && \
    go get -u -v github.com/stamblerre/gocode && \
    go get -u -v github.com/rogpeppe/godef  && \
    go get -u -v github.com/ianthehat/godef && \
    go get -u -v golang.org/x/tools/cmd/godoc  && \
    go get -u -v github.com/zmb3/gogetdoc  && \
    go get -u -v golang.org/x/lint/golint  && \
    go get -u -v github.com/fatih/gomodifytags  && \
    go get -u -v golang.org/x/tools/cmd/gorename  && \
    go get -u -v sourcegraph.com/sqs/goreturns  && \
    go get -u -v golang.org/x/tools/cmd/goimports  && \
    go get -u -v github.com/cweill/gotests/...  && \
    go get -u -v golang.org/x/tools/cmd/guru  && \
    go get -u -v github.com/josharian/impl  && \
    go get -u -v github.com/haya14busa/goplay/cmd/goplay  && \
    go get -u -v github.com/uudashr/gopkgs/cmd/gopkgs  && \
    go get -u -v github.com/davidrjenni/reftools/cmd/fillstruct  && \
    go get -u -v github.com/alecthomas/gometalinter  && \
    go get -u -v github.com/derekparker/delve/cmd/dlv && \
    gometalinter --install

# Environment variables
ENV DISPLAY=:0.0

CMD [ "code", "--verbose", "--disable-gpu", "-n", "." ]