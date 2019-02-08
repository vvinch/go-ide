# go-ide

## Description

Docker image which offers a Golang development environment with Visual Studio Code IDE.

## Installed toolset

- Go environment (latest)
- Visual Studio Code with Go extension

## Usage

```bash
docker run --rm -it -v /tmp/.X11-unix:/tmp/.X11-unix \
                    -v sources_folder:/go/src
                    vvinch/go-ide
```

### Volumes

- /tmp/.X11-unix

   This location must be mapped to the Docker host X11 socket. Typically at the same location.

- /go/src

   This folder is the root path for Go projects. This should be mapped to an external volume containing the sources in order to backing up the data and the build results.

### Environment

- DISPLAY=:0.0

   This environment variable is defined by default.
