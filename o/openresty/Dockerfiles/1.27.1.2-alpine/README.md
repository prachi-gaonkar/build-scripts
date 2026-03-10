## Build Instructions

### 1. Prerequisites

The Dockerfile is sourced from the following location:
https://github.com/openresty/docker-openresty/blob/1.27.1.2-11/alpine/Dockerfile

Ensure the following configuration files are present in the Docker build context directory:

- `nginx.conf`
- `nginx.vh.default.conf`

These files are obtained from the OpenResty Docker repository:

https://github.com/openresty/docker-openresty/tree/1.27.1.2-11


### 2. Navigate to the version directory

```bash
cd 1.27.1.2-alpine
```

### 3. Build the Docker image

```bash
docker build -t openresty-ppc64le:1.27.1.2-alpine .
```