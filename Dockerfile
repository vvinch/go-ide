FROM golang:1.11.5

# Configure apt proxy
RUN if [ ! -z "${HTTP_PROXY}" ]; then \
        echo "Acquire::http::No-Cache True;" > /etc/apt/apt.conf; \
        echo "Acquire::https::No-Cache True;" >> /etc/apt/apt.conf; \
        echo "Acquire::http::Pipeline-Depth 0;" >> /etc/apt/apt.conf; \
        echo "Acquire::http::Timeout 30;" >> /etc/apt/apt.conf; \
        echo "Acquire::BrokenProxy True;" >> /etc/apt/apt.conf; \
        echo "Acquire::http::Proxy \"${HTTP_PROXY}\";" >> /etc/apt/apt.conf; \
        echo "Acquire::https::Proxy \"${HTTP_PROXY}\";" >> /etc/apt/apt.conf; \       
    fi

# Configure wget proxy
RUN if [ ! -z "${HTTP_PROXY}" ]; then \
        echo "use_proxy=on" > ~/.wgetrc; \
        echo "http_proxy=${HTTP_PROXY}" >>  ~/.wgetrc; \
        echo "https_proxy=${HTTP_PROXY}" >>  ~/.wgetrc; \
    fi


# Install required packages
RUN apt-get update && apt-get install -y wget git libnotify4 libgconf-2-4 libnss3 libgtk2.0-0 libxss1 libgconf-2-4 libasound2 libxtst6 libcanberra-gtk-dev libgl1-mesa-glx libgl1-mesa-dri

# Install visual studio code
RUN wget --no-check-certificate https://go.microsoft.com/fwlink/?LinkID=760868 -O vscode.deb && \
    dpkg -i vscode.deb; \
    apt-get -f install -y && \
    rm vscode.deb && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m vscode -s /bin/bash
WORKDIR /go/src
USER vscode

# Configure GIT proxy settings for vscode user
RUN git config --global http.proxy ${http_proxy} && \
    git config --global http.sslVerify false

# Install Go extension for VS Code
RUN mkdir -p ~/.config/Code/User && \
    echo "{\n\"http.proxyStrictSSL\": false\n}" > ~/.config/Code/User/settings.json

RUN code --install-extension ms-vscode.go

# Install Go extensions
RUN go get -insecure -u -v github.com/ramya-rao-a/go-outline && \
    go get -insecure -u -v github.com/acroca/go-symbols  && \
    go get -insecure -u -v github.com/mdempsky/gocode  && \
    go get -insecure -u -v github.com/stamblerre/gocode && \
    go get -insecure -u -v github.com/rogpeppe/godef  && \
    go get -insecure -u -v github.com/ianthehat/godef && \
    go get -insecure -u -v golang.org/x/tools/cmd/godoc  && \
    go get -insecure -u -v github.com/zmb3/gogetdoc  && \
    go get -insecure -u -v golang.org/x/lint/golint  && \
    go get -insecure -u -v github.com/fatih/gomodifytags  && \
    go get -insecure -u -v golang.org/x/tools/cmd/gorename  && \
    go get -insecure -u -v sourcegraph.com/sqs/goreturns  && \
    go get -insecure -u -v golang.org/x/tools/cmd/goimports  && \
    go get -insecure -u -v github.com/cweill/gotests/...  && \
    go get -insecure -u -v golang.org/x/tools/cmd/guru  && \
    go get -insecure -u -v github.com/josharian/impl  && \
    go get -insecure -u -v github.com/haya14busa/goplay/cmd/goplay  && \
    go get -insecure -u -v github.com/uudashr/gopkgs/cmd/gopkgs  && \
    go get -insecure -u -v github.com/davidrjenni/reftools/cmd/fillstruct  && \
    go get -insecure -u -v github.com/alecthomas/gometalinter  && \
    go get -insecure -u -v github.com/derekparker/delve/cmd/dlv && \
    gometalinter --install

CMD [ "code", "--verbose", "--disable-gpu", "-n", "." ]